import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_formatter.g.dart';

@riverpod
DateFormat dateAndTimeFormatter(Ref ref) {
  return DateFormat('dd/MM/yy - HH:mm', 'it_IT');
}

@riverpod
DateFormat dateFormatter(Ref ref) {
  return DateFormat('dd/MM/yy', 'it_IT');
}
