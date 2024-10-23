import '../../../../utils/context_extensions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../utils/date_formatter.dart';

class DateDisplay extends ConsumerWidget {
  final DateTime date;

  const DateDisplay({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateAndTimeFormatter = ref.read(dateAndTimeFormatterProvider);

    return Text(
      "${context.loc.datetime}: ${dateAndTimeFormatter.format(date)}",
      style: const TextStyle(
        fontSize: Sizes.p16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
