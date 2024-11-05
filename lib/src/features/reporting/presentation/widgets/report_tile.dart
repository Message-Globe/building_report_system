import 'package:building_report_system/src/l10n/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../routing/app_router.dart';
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
        onTap: () => context.goNamed(
          AppRoute.editReport.name,
          extra: report,
        ),
        child: ListTile(
          leading: ReportStatusIcon(status: report.status),
          titleAlignment: ListTileTitleAlignment.center,
          title: Text(
            report.title,
            overflow: TextOverflow.ellipsis,
          ),
          isThreeLine: true,
          subtitle: Text(
            '${report.building.name} - ${report.buildingSpot}\n'
                    'Assigned to: ${report.nameAuditor}'
                .hardcoded,
            maxLines: 2,
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
