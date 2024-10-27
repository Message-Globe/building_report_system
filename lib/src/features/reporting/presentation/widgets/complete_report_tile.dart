import '../../../../l10n/string_extensions.dart';

import '../../../../utils/context_extensions.dart';

import 'package:flutter/material.dart';

import '../../../../constants/app_sizes.dart';

class CompleteReportTile extends StatelessWidget {
  final Future<bool> Function() onComplete;
  final bool isAssignedToMe;

  const CompleteReportTile({
    super.key,
    required this.onComplete,
    required this.isAssignedToMe,
  });

  @override
  Widget build(BuildContext context) {
    if (!isAssignedToMe) return Container();

    return Column(
      children: <Widget>[
        Text(context.loc.swipeToComplete.capitalizeFirst()),
        gapH8,
        Dismissible(
          key: const Key('reportStatusDismissible'),
          direction: DismissDirection.startToEnd,
          background: Container(
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.circular(Sizes.p8),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                const Icon(Icons.check, color: Colors.white, size: 30),
                gapW12,
                Expanded(
                  child: LinearProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Colors.green.withOpacity(0.3),
                    value: 1,
                  ),
                ),
              ],
            ),
          ),
          confirmDismiss: (_) => onComplete(),
          onDismissed: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.loc.reportStatusCompleted.capitalizeFirst()),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(Sizes.p16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(Sizes.p8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  context.loc.swipeToComplete.capitalizeFirst(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Icon(
                  Icons.swipe_right,
                  color: Colors.greenAccent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
