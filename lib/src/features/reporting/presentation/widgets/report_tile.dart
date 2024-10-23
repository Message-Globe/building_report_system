import 'package:building_report_system/src/features/authentication/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final userProfile = ref.read(authRepositoryProvider).currentUser!;
    final building = userProfile.assignedBuildings[report.buildingId];

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
          title: Text(
            report.title,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '$building - ${ref.read(dateFormatterProvider).format(report.createdAt)}',
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
