import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app_bootstrap.dart';
import 'src/exceptions/async_error_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Crea il ProviderContainer con gli observer per tracciare errori async
  final container = ProviderContainer(
    observers: [AsyncErrorLogger()], // Aggiungi l'osservatore per gli errori
  );

  // Crea l'istanza di AppBootstrap e inizializza l'app, eseguendo il check del token
  final appBootstrap = AppBootstrap();
  await appBootstrap.initializeApp(container);

  // Avvia l'app
  runApp(
    appBootstrap.createRootWidget(container: container),
  );
}
