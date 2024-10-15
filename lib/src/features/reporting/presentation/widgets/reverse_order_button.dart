import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/filters_controllers.dart';

class ReverseOrderButton extends ConsumerWidget {
  const ReverseOrderButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reverseOrder = ref.watch(reverseOrderFilterProvider);

    return IconButton(
      icon: Icon(
        reverseOrder
            ? Icons.arrow_downward
            : Icons.arrow_upward, // Freccia verso l'alto o il basso
      ),
      onPressed: () {
        ref.read(reverseOrderFilterProvider.notifier).toggle(); // Inverte l'ordine
      },
    );
  }
}
