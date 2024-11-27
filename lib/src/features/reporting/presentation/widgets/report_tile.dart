import '../../../../utils/context_extensions.dart';

import '../../../../l10n/string_extensions.dart';
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
          pathParameters: {'id': report.id},
        ),
        child: ListTile(
          leading: ReportStatusIcon(status: report.status),
          titleAlignment: ListTileTitleAlignment.center,
          title: Text(
            '[${report.category}] - ID: ${report.id}',
            overflow: TextOverflow.ellipsis,
          ),
          isThreeLine: true,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${report.building.name} - ${report.buildingSpot}',
                style: TextStyle(overflow: TextOverflow.ellipsis),
              ),
              Text('${context.loc.assignedTo.capitalizeFirst()} ${report.nameAuditor}'),
            ],
          ),
          trailing: report.priority.index >= 2
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    report.priority.index - 1, // Da 3 (una priorità media-alta) in su
                    (index) => const Icon(
                      Icons.priority_high,
                      color: Colors.red,
                      size: 20, // Puoi regolare la dimensione se necessario
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
