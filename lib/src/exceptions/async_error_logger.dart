import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_exception.dart';
import 'error_logger.dart'; // Assicurati che questa classe sia correttamente importata

class AsyncErrorLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final errorLogger = container.read(errorLoggerProvider);

    // Log the provider update
    debugPrint('Provider updated: ${provider.name ?? provider.runtimeType}');

    // Verifica se c'è un errore nell'AsyncValue
    final error = _findError(newValue);
    if (error != null) {
      // Log l'errore tramite il logger
      if (error.error is AppException) {
        // Se è un'AppException, usa il logger specifico per AppException
        errorLogger.logAppException(error.error as AppException);
      } else {
        // Altrimenti logga tutto l'errore e lo stacktrace
        errorLogger.logError(error.error, error.stackTrace);
      }
    }
  }

  // Funzione che trova un eventuale AsyncError nel nuovo valore del provider
  AsyncError<dynamic>? _findError(Object? value) {
    if (value is AsyncError) {
      return value;
    } else {
      return null;
    }
  }
}
