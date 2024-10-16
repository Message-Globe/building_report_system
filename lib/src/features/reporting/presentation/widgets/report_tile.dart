import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../routing/app_router.dart';
import '../../../../utils/date_formatter.dart';
import '../../domain/report.dart';
import 'report_status_icon.dart';

class ReportTile extends ConsumerWidget {
  final Report report;

  const ReportTile({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: Sizes.p8,
        horizontal: Sizes.p16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(Sizes.p12),
        onTap: () => ref.read(goRouterProvider).pushNamed(
              AppRoute.editReport.name,
              extra: report,
            ),
        child: ListTile(
          leading: ReportStatusIcon(status: report.status),
          title: Text(
            report.title,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${report.buildingId} - ${ref.read(dateFormatterProvider).format(report.timestamp)}',
            overflow: TextOverflow.ellipsis,
          ),
          trailing: report.priority == PriorityLevel.urgent
              ? const Icon(
                  Icons.priority_high,
                  color: Colors.red,
                )
              : null,
        ),
      ),
    );
  }
}
