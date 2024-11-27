import '../../data/reports_repository.dart';
import '../widgets/category_selection_dropdown.dart';

import '../../../authentication/domain/building.dart';
import '../controllers/edit_report_screen_controller.dart';
import '../../../../l10n/string_extensions.dart';

import '../../../../utils/context_extensions.dart';

import '../widgets/building_area_selection_list.dart';
import '../widgets/building_selection_dropdown.dart';
import '../widgets/complete_report_tile.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/date_display.dart';
import '../widgets/priority_selection_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../routing/app_router.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../authentication/domain/user_profile.dart';
import '../../domain/report.dart';
import '../widgets/combined_image_gallery.dart';

class EditReportScreen extends ConsumerStatefulWidget {
  final String reportId;

  const EditReportScreen({
    super.key,
    required this.reportId,
  });

  @override
  ConsumerState<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends ConsumerState<EditReportScreen> {
  late Future<Report> _reportFuture;
  // final _titleController = TextEditingController();
  final _resolveByController = TextEditingController();
  final _descriptionController = TextEditingController();
  late String _selectedCategory;
  late Building _selectedBuilding;
  late Map<String, String> _selectedArea;
  late PriorityLevel _selectedPriority;
  late bool _escalatedToAdmin;
  late bool _areaNotAvailable;
  final List<String> _localImages = [];
  final List<String> _remoteImages = [];
  final _repairDescriptionController = TextEditingController();
  final List<String> _repairLocalImages = [];
  final List<String> _repairRemoteImages = [];

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  Future<void> _fetchReport() async {
    final currentUser = ref.read(authRepositoryProvider).currentUser!;
    _reportFuture = ref.read(reportsRepositoryProvider).fetchReport(
          currentUser: currentUser,
          reportId: widget.reportId,
        );
    _reportFuture.then(
      (report) {
        setState(() {
          _selectedCategory = report.category;
          // _titleController.text = report.title;
          _descriptionController.text = report.description;
          _resolveByController.text = report.resolveBy;
          _selectedArea = {
            'id': report.buildingSpotId,
            'name': report.buildingSpot,
          };
          _selectedBuilding = report.building;
          _selectedPriority = report.priority;
          _escalatedToAdmin = report.escalatedToAdmin;
          _areaNotAvailable = report.areaNotAvailable;
          _remoteImages.addAll(report.photoUrls);
          _repairDescriptionController.text = report.maintenanceDescription;
          _repairRemoteImages.addAll(report.maintenancePhotoUrls);
        });
      },
    );
  }

  @override
  void dispose() {
    // _titleController.dispose();
    _descriptionController.dispose();
    _repairDescriptionController.dispose();
    _resolveByController.dispose();
    super.dispose();
  }

  void _updateReport(Report report, bool isReporter) async {
    // final title = _titleController.text;
    final description = _descriptionController.text;
    final resolveBy = _resolveByController.text;
    final maintenanceDescription = _repairDescriptionController.text;

    if (isReporter) {
      if (_selectedCategory.isEmpty || description.isEmpty || _selectedArea.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.loc.completeAllFields.capitalizeFirst())),
        );
        return;
      }
    } else {
      if (maintenanceDescription.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.loc.provideRepairDetails.capitalizeFirst())),
        );
        return;
      }
    }

    await ref.read(editReportScreenControllerProvider.notifier).updateReport(
          report: report,
          category: _selectedCategory,
          building: _selectedBuilding,
          buildingAreaId: _selectedArea['id'],
          priority: _selectedPriority,
          // title: title,
          description: description,
          resolveBy: resolveBy,
          photosUrls: _remoteImages,
          newPhotos: _localImages,
          maintenanceDescription: maintenanceDescription,
          escalatedToAdmin: _escalatedToAdmin,
          areaNotAvailable: _areaNotAvailable,
          maintenancePhotoUrls: _repairRemoteImages,
          newMaintenancePhotos: _repairLocalImages,
        );

    ref.read(goRouterProvider).pop();
  }

  Future<bool> _completeReport(Report report) async {
    final maintenanceDescription = _repairDescriptionController.text;
    if (_escalatedToAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.cannotCompleteReport.capitalizeFirst()),
        ),
      );
      return Future.value(false);
    }
    if (maintenanceDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.provideRepairDetails.capitalizeFirst())),
      );
      return Future.value(false);
    }

    await ref.read(editReportScreenControllerProvider.notifier).completeReport(
          report: report,
          maintenanceDescription: maintenanceDescription,
          maintenancePhotoUrls: _repairRemoteImages,
        );

    ref.read(goRouterProvider).pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _reportFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(context.loc.failedToLoadReport.capitalizeFirst()));
        } else if (snapshot.hasData) {
          final report = snapshot.data!;

          final userProfile = ref.watch(authRepositoryProvider).currentUser!;
          final isReporter = userProfile.role == UserRole.reporter;
          final isOperator = userProfile.role == UserRole.operator;
          final reportEditable = report.status == ReportStatus.opened;
          final isLoading = ref.watch(editReportScreenControllerProvider).isLoading;
          final isAssignedToMe = report.assignedTo == userProfile.appUser.uid &&
              report.status == ReportStatus.assigned;

          return Stack(
            children: <Widget>[
              Scaffold(
                appBar: AppBar(
                  title: Text(context.loc.editReport.capitalizeFirst()),
                  actions: <Widget>[
                    if ((isReporter && reportEditable) || isAssignedToMe)
                      IconButton(
                        icon: const Icon(Icons.save),
                        onPressed: () => _updateReport(report, isReporter),
                      ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: ListView(
                    children: <Widget>[
                      //ID
                      Text('ID: ${report.id}'),
                      gapH16,

                      // Categoria
                      if (isReporter && reportEditable)
                        CategorySelectionDropdown(
                          selectedCategory: _selectedCategory,
                          onCategorySelected: (value) =>
                              setState(() => _selectedCategory = value),
                        )
                      else
                        Text('${context.loc.category} $_selectedCategory'),
                      gapH16,

                      // Data
                      DateDisplay(date: report.createdAt),
                      gapH16,

                      Text(
                        'Creata da: ${report.createdByName}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      gapH16,

                      Text(
                        '${context.loc.assignedTo.capitalizeFirst()} ${report.nameAuditor}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      gapH16,

                      // Descrizione
                      if (isReporter && reportEditable)
                        CustomTextField(
                          controller: _descriptionController,
                          labelText: context.loc.description.capitalizeFirst(),
                          maxLines: 3,
                        )
                      else
                        Text(
                            "${context.loc.description.capitalizeFirst()}: ${report.description}"),
                      gapH16,

                      // Da risolvere entro il
                      if (isReporter && reportEditable)
                        CustomTextField(
                          controller: _resolveByController,
                          labelText: context.loc.resolveBy.capitalizeFirst(),
                        )
                      else
                        Text(
                            '${context.loc.resolveBy.capitalizeFirst()}: ${report.resolveBy}'),
                      gapH16,

                      if (isReporter && reportEditable)
                        BuildingSelectionDropdown(
                          buildings: userProfile.assignedBuildings,
                          selectedBuilding: _selectedBuilding,
                          onBuildingSelected: (newBuilding) {
                            if (newBuilding != null) {
                              setState(() => _selectedBuilding = newBuilding);
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  child: BuildingAreaSelectionList(
                                    buildingId: newBuilding.id,
                                    onSelected: (area) {
                                      setState(() {
                                        _selectedArea = area;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      else
                        Text(
                            "${context.loc.building.capitalizeFirst()}: ${report.building.name}"),
                      gapH16,

                      Text(
                          '${context.loc.selectedArea.capitalizeFirst()} ${_selectedArea['name']}'),
                      gapH16,

                      // Priority Level (Dropdown)
                      if (isReporter && reportEditable)
                        PrioritySelectionDropdown(
                          selectedPriority: _selectedPriority,
                          onPrioritySelected: (PriorityLevel? newPriority) {
                            if (newPriority != null) {
                              setState(() => _selectedPriority = newPriority);
                            }
                          },
                        )
                      else
                        Text(
                          "${context.loc.priority.capitalizeFirst()}: ${report.priority.toLocalizedString(context).capitalizeFirst()}",
                        ),
                      gapH16,

                      // Galleria combinata (locali e remote)
                      CombinedImageGallery(
                        isOperator: false,
                        localImages: _localImages,
                        remoteImages: _remoteImages,
                        canEdit: isReporter && reportEditable,
                        onRemoveLocal: (file) =>
                            setState(() => _localImages.remove(file)),
                        onRemoveRemote: (url) =>
                            setState(() => _remoteImages.remove(url)),
                      ),

                      // Descrizione dei lavori (solo per operator)
                      if (isOperator) ...<Widget>[
                        gapH8,
                        const Divider(),
                        gapH8,
                        if (isAssignedToMe)
                          CustomTextField(
                            controller: _repairDescriptionController,
                            labelText: context.loc.repairDescription.capitalizeFirst(),
                            maxLines: 3,
                          )
                        else
                          Text(
                              "${context.loc.repairDescription.capitalizeFirst()}: ${report.maintenanceDescription}"),
                        gapH16,
                        CombinedImageGallery(
                          isOperator: true,
                          localImages: _repairLocalImages,
                          remoteImages: _repairRemoteImages,
                          canEdit: isAssignedToMe,
                          onRemoveLocal: (file) =>
                              setState(() => _repairLocalImages.remove(file)),
                          onRemoveRemote: (url) =>
                              setState(() => _repairRemoteImages.remove(url)),
                        ),
                        if (isAssignedToMe) ...[
                          gapH16,
                          CheckboxListTile(
                            title: Text(context.loc.spaceNotUsable.capitalizeFirst()),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.all(0),
                            value: _areaNotAvailable,
                            onChanged: (value) => setState(
                                () => _areaNotAvailable = value ?? _areaNotAvailable),
                          ),
                          gapH16,
                          CheckboxListTile(
                            title: Text(context.loc.reportNotSolvable.capitalizeFirst()),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.all(0),
                            value: _escalatedToAdmin,
                            onChanged: (value) => setState(
                                () => _escalatedToAdmin = value ?? _escalatedToAdmin),
                          ),
                          if (!_escalatedToAdmin) ...[
                            gapH16,
                            CompleteReportTile(
                              onComplete: () => _completeReport(report),
                              isAssignedToMe: isAssignedToMe,
                            ),
                          ]
                        ],
                      ],
                    ],
                  ),
                ),
              ),
              if (isLoading) ...<Widget>[
                ModalBarrier(
                  color: Colors.black.withOpacity(0.5),
                  dismissible: false, // Impedisce di interagire con la schermata sotto
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ],
          );
        }
        return Center(child: Text(context.loc.reportNotFound.capitalizeFirst()));
      },
    );
  }
}
