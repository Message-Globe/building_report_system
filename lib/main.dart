import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app_bootstrap.dart';
import 'src/exceptions/async_error_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carica il file .env
  await dotenv.load();

  // Crea il ProviderContainer con gli observer per tracciare errori async
  final container = ProviderContainer(
    observers: [AsyncErrorLogger()], // Aggiungi l'osservatore per gli errori
  );

  // Crea l'istanza di AppBootstrap e inizializza l'app eseguendo i seguenti passaggi:
  // - Inizializza Firebase
  // - Imposta gli handler degli errori globali
  // - Configura il date formatting per la localizzazione
  // - Applica la URL strategy per rimuovere il simbolo '#' (se in modalità web)
  // - Esegue il check del token di autenticazione
  final appBootstrap = AppBootstrap();
  await appBootstrap.initializeApp(container);

  // Avvia l'app
  runApp(
    appBootstrap.createRootWidget(container: container),
  );
}
