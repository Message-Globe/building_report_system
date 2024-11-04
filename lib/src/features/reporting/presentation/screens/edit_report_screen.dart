import '../../../authentication/domain/building.dart';
import '../controllers/edit_report_screen_controller.dart';
import '../../../../l10n/string_extensions.dart';

import '../../../../utils/context_extensions.dart';

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
  final Report report;

  const EditReportScreen({super.key, required this.report});

  @override
  ConsumerState<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends ConsumerState<EditReportScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _buildingSpotController = TextEditingController();
  late Building _selectedBuilding;
  late PriorityLevel _selectedPriority;
  final List<String> _localImages = [];
  final List<String> _remoteImages = [];
  final _repairDescriptionController = TextEditingController();
  final List<String> _repairLocalImages = [];
  final List<String> _repairRemoteImages = [];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.report.title;
    _descriptionController.text = widget.report.description;
    _buildingSpotController.text = widget.report.buildingSpot;
    _selectedBuilding = widget.report.building;
    _selectedPriority = widget.report.priority;
    _remoteImages.addAll(widget.report.photoUrls);
    _repairDescriptionController.text = widget.report.maintenanceDescription;
    _repairRemoteImages.addAll(widget.report.maintenancePhotoUrls);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _buildingSpotController.dispose(); // Disposizione del controller aggiunto
    _repairDescriptionController.dispose();
    super.dispose();
  }

  void _updateReport(bool isReporter) async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final buildingSpot = _buildingSpotController.text;
    final maintenanceDescription = _repairDescriptionController.text;

    if (isReporter) {
      if (title.isEmpty || description.isEmpty || buildingSpot.isEmpty) {
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
          report: widget.report,
          building: _selectedBuilding,
          buildingSpot: buildingSpot,
          priority: _selectedPriority,
          title: title,
          description: description,
          photosUrls: _remoteImages,
          newPhotos: _localImages,
          maintenanceDescription: maintenanceDescription,
          maintenancePhotoUrls: _repairRemoteImages,
          newMaintenancePhotos: _repairLocalImages,
        );

    ref.read(goRouterProvider).pop();
  }

  Future<bool> _completeReport() async {
    final maintenanceDescription = _repairDescriptionController.text;
    if (maintenanceDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.provideRepairDetails.capitalizeFirst())),
      );
      return Future.value(false);
    }

    await ref.read(editReportScreenControllerProvider.notifier).completeReport(
          report: widget.report,
          maintenanceDescription: maintenanceDescription,
          maintenancePhotoUrls: _repairRemoteImages,
        );

    ref.read(goRouterProvider).pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(authRepositoryProvider).currentUser!;
    final isReporter = userProfile.role == UserRole.reporter;
    final isOperator = userProfile.role == UserRole.operator;
    final reportEditable = widget.report.status == ReportStatus.opened;
    final isLoading = ref.watch(editReportScreenControllerProvider).isLoading;
    final isAssignedToMe = widget.report.assignedTo == userProfile.appUser.uid &&
        widget.report.status == ReportStatus.assigned;

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(context.loc.editReport.capitalizeFirst()),
            actions: <Widget>[
              if ((isReporter && reportEditable) || isAssignedToMe)
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () => _updateReport(isReporter),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: ListView(
              children: <Widget>[
                // Titolo
                if (isReporter && reportEditable)
                  CustomTextField(
                    controller: _titleController,
                    labelText: context.loc.title.capitalizeFirst(),
                  )
                else
                  Text("${context.loc.title.capitalizeFirst()}: ${widget.report.title}"),
                gapH16,

                // Data
                DateDisplay(date: widget.report.createdAt),
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
                      "${context.loc.description.capitalizeFirst()}: ${widget.report.description}"),
                gapH16,

                if (isReporter && reportEditable)
                  BuildingSelectionDropdown(
                    buildings: userProfile.assignedBuildings,
                    selectedBuilding: _selectedBuilding,
                    onBuildingSelected: (newBuilding) {
                      if (newBuilding != null) {
                        setState(() => _selectedBuilding = newBuilding);
                      }
                    },
                  )
                else
                  Text(
                      "${context.loc.building.capitalizeFirst()}: ${widget.report.building.name}"),
                gapH16,

                // Building Spot (solo per reporter e se modificabile)
                if (isReporter && reportEditable)
                  CustomTextField(
                    controller: _buildingSpotController,
                    labelText: context.loc.buildingSpot.capitalizeFirst(),
                  )
                else
                  Text(
                      "${context.loc.buildingSpot.capitalizeFirst()}: ${widget.report.buildingSpot}"),
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
                      "${context.loc.priority.capitalizeFirst()}: ${widget.report.priority.name}"),
                gapH16,

                // Galleria combinata (locali e remote)
                CombinedImageGallery(
                  isOperator: false,
                  localImages: _localImages,
                  remoteImages: _remoteImages,
                  canEdit: isReporter && reportEditable,
                  onRemoveLocal: (file) => setState(() => _localImages.remove(file)),
                  onRemoveRemote: (url) => setState(() => _remoteImages.remove(url)),
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
                        "${context.loc.repairDescription.capitalizeFirst()}: ${widget.report.maintenanceDescription}"),
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
                  gapH16,
                  if (isAssignedToMe)
                    CompleteReportTile(
                      onComplete: _completeReport,
                      isAssignedToMe: isAssignedToMe,
                    ),
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
}
