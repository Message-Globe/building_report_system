import '../../../../localization/string_hardcoded.dart';
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
        const Text('Swipe to complete report:'),
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
                content: Text('Report status Completed'.hardcoded),
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Swipe right to mark as Completed',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(
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
