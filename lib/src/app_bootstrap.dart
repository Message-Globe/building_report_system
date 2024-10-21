import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'exceptions/error_logger.dart';
import 'features/authentication/data/auth_repository.dart';

class AppBootstrap {
  /// Metodo che inizializza l'app e la configura
  Future<void> initializeApp(ProviderContainer container) async {
    // Inizializzazione dei servizi, ad esempio la splash screen
    FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
    );

    // Altre inizializzazioni globali come setup delle date, localizzazione, ecc.
    await initializeDateFormatting('it_IT', null);
    usePathUrlStrategy();

    // Esegui il check del token
    await _checkToken(container);
  }

  /// Controlla il token all'avvio e gestisce gli eventuali errori
  Future<void> _checkToken(ProviderContainer container) async {
    final authRepository = container.read(authRepositoryProvider);

    try {
      await authRepository.checkToken();
    } finally {
      FlutterNativeSplash.remove();
    }
  }

  /// Crea il widget root dell'app all'interno del ProviderScope
  Widget createRootWidget({required ProviderContainer container}) {
    // Registra gli handler di errore
    final errorLogger = container.read(errorLoggerProvider);
    registerErrorHandlers(errorLogger);

    // Restituisce l'app inserita nel ProviderScope
    return UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    );
  }

  /// Registra gli handler globali degli errori
  void registerErrorHandlers(ErrorLogger errorLogger) {
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
          title: const Text('An error occurred'),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }
}
