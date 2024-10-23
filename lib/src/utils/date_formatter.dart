import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_formatter.g.dart';

@riverpod
DateFormat dateAndTimeFormatter(DateFormatterRef ref) {
  return DateFormat('dd/MM/yy - HH:mm', 'it_IT');
}

@riverpod
DateFormat dateFormatter(DateFormatterRef ref) {
  return DateFormat('dd/MM/yy', 'it_IT');
}
