import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:universal_io/io.dart';

import '../firebase_options.dart';
import 'app.dart';
import 'exceptions/error_logger.dart';
import 'features/authentication/data/auth_repository.dart';
import 'l10n/string_extensions.dart';

class AppBootstrap {
  /// Metodo che inizializza l'app e la configura
  Future<void> initializeApp(ProviderContainer container) async {
    // Inizializzazione dei servizi, ad esempio la splash screen
    FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
    );

    // Inizializzazione delle device info
    await _getDeviceInfo(container);

    // Inizializzazione di Firebase
    await Firebase.initializeApp(
        name: 'building-report-system',
        options: DefaultFirebaseOptions.currentPlatform);
    _configureFirebaseMessaging();
    final notificationsPermitted = await _askNotificationsPermision();
    await _initializeFirebaseMessagingToken(container, notificationsPermitted);

    // Altre inizializzazioni globali come setup delle date, localizzazione, ecc.
    await initializeDateFormatting('it_IT', null);
    usePathUrlStrategy();

    // Esegui il check dello user token
    await _checkUserToken(container);
  }

  Future<void> _getDeviceInfo(ProviderContainer container) async {
    final deviceInfo = DeviceInfoPlugin();
    String? deviceId;
    String deviceType = kIsWeb ? 'web' : Platform.operatingSystem;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; // Ottieni l'Android ID
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor; // Ottieni l'identifier per iOS
    }

    debugPrint("Device ID: $deviceId, Device Type: $deviceType");

    final authRepository = container.read(authRepositoryProvider);
    authRepository.deviceType = deviceType;
    authRepository.deviceId = deviceId;
  }

  void _configureFirebaseMessaging() async {
    // Gestisci le notifiche in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
        "Titolo Messaggio in foreground in arrivo: ${message.notification?.title}",
      );
      debugPrint(
        "Contenuto Messaggio in foreground in arrivo: ${message.notification?.body}",
      );
    });
  }

  Future<bool> _askNotificationsPermision() async {
    // Richiedi i permessi solo su iOS e Web
    if (defaultTargetPlatform == TargetPlatform.iOS || kIsWeb) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      try {
        await messaging.deleteToken();
      } catch (e) {
        debugPrint("Error deleting Firebase messaging token: $e");
      }

      NotificationSettings settings = await messaging.requestPermission();

      // Verifica se i permessi sono stati concessi
      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        return false;
      }
    }
    return true;
  }

  Future<void> _initializeFirebaseMessagingToken(
    ProviderContainer container,
    bool notificationPermitted, {
    int maxRetries = 5, // Maximum number of retries
    Duration retryDelay = const Duration(seconds: 2), // Delay between retries
  }) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? fcmToken;
    int retryCount = 0;

    if (!notificationPermitted) {
      debugPrint(
          "Notification permissions not granted. Token initialization skipped.");
      return;
    }
    while (retryCount < maxRetries) {
      try {
        // Check APNs token only on iOS
        if (Platform.isIOS) {
          String? apnsToken = await messaging.getAPNSToken();
          if (apnsToken == null) {
            debugPrint("APNS token not yet available. Retrying...");
            retryCount++;
            if (retryCount >= maxRetries) {
              debugPrint(
                  "APNS token could not be retrieved after $maxRetries retries.");
              return; // Exit if retries are exhausted
            }
            await Future.delayed(retryDelay);
            continue; // Retry
          }
          debugPrint("APNS Token: $apnsToken");
        }

        // Get the FCM token
        fcmToken = await messaging.getToken();
        if (fcmToken != null) {
          debugPrint("Firebase Messaging Token: $fcmToken");
          break; // Exit the retry loop on success
        } else {
          debugPrint("Failed to retrieve FCM token. Retrying...");
          retryCount++;
          if (retryCount >= maxRetries) {
            debugPrint(
                "FCM token could not be retrieved after $maxRetries retries.");
            return; // Exit if retries are exhausted
          }
          await Future.delayed(retryDelay);
        }
      } catch (e) {
        debugPrint("Error initializing Firebase Messaging token: $e");
        retryCount++;
        if (retryCount >= maxRetries) {
          debugPrint(
              "Token initialization failed after $maxRetries retries: $e");
          return; // Exit if retries are exhausted
        }
        await Future.delayed(retryDelay);
      }
    }

    // Update the auth repository if the token is successfully retrieved
    if (fcmToken != null) {
      final authRepository = container.read(authRepositoryProvider);
      authRepository.fcmToken = fcmToken;

      // Listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        debugPrint("Refreshed FCM Token: $newToken");
        authRepository.fcmToken = newToken;
      });
    } else {
      debugPrint(
          "Firebase Messaging token is null. Token was not set in AuthRepository.");
    }
  }

  /// Controlla lo user token all'avvio e gestisce gli eventuali errori
  Future<void> _checkUserToken(ProviderContainer container) async {
    final authRepository = container.read(authRepositoryProvider);

    try {
      await authRepository.checkUserToken();
    } finally {
      FlutterNativeSplash.remove();
    }
  }

  /// Registra gli handler globali degli errori
  void _registerErrorHandlers(ErrorLogger errorLogger) {
    // Cattura errori Flutter non gestiti
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      errorLogger.logError(details.exception, details.stack);
    };

    // Gestione degli errori di piattaforma
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      errorLogger.logError(error, stack);
      return true;
    };

    // Gestione degli errori durante la build di un widget
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('An error occurred'.hardcoded),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }

  /// Crea il widget root dell'app all'interno del ProviderScope
  Widget createRootWidget({required ProviderContainer container}) {
    // Registra gli handler di errore
    final errorLogger = container.read(errorLoggerProvider);
    _registerErrorHandlers(errorLogger);

    // Restituisce l'app inserita nel ProviderScope
    return UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    );
  }
}
