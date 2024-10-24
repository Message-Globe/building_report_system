import 'package:building_report_system/src/features/reporting/presentation/controllers/create_report_screen_controller.dart';

import '../../../authentication/domain/user_profile.dart';
import '../../../../utils/context_extensions.dart';

import '../../domain/report.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/date_display.dart';
import '../widgets/priority_selection_dropdown.dart';
import '../widgets/local_image_gallery.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../../routing/app_router.dart';
import '../../../../utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../../constants/app_sizes.dart';
import '../widgets/building_selection_dropdown.dart';

class CreateReportScreen extends ConsumerStatefulWidget {
  const CreateReportScreen({super.key});

  @override
  ConsumerState<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends ConsumerState<CreateReportScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _buildingSpotController = TextEditingController();
  String? _selectedBuilding;
  PriorityLevel _selectedPriority = PriorityLevel.normal;
  final List<File> _images = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _buildingSpotController.dispose();
    super.dispose();
  }

  void _submitReport(UserProfile userProfile) async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final buildingSpot = _buildingSpotController.text;
    final buildingId = userProfile.assignedBuildings.entries
        .firstWhere((element) => element.value == _selectedBuilding)
        .key;

    if (title.isEmpty ||
        description.isEmpty ||
        _selectedBuilding == null ||
        buildingSpot.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.completeAllFields),
        ),
      );
      return;
    }

    final imagesUrls = _images.map((image) => image.path).toList();

    // Chiama il metodo addReport
    await ref.read(createReportScreenControllerProvider.notifier).createReport(
          buildingId: buildingId,
          buildingSpot: buildingSpot,
          priority: _selectedPriority,
          title: title,
          description: description,
          photoUrls: imagesUrls,
        );

    // Ritorna alla schermata precedente dopo la creazione del report
    ref.read(goRouterProvider).pop();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      createReportScreenControllerProvider,
      (_, state) {
        state.showAlertDialogOnError(context);
      },
    );

    final isLoading = ref.watch(createReportScreenControllerProvider).isLoading;
    final userProfile = ref.watch(authRepositoryProvider).currentUser!;

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(context.loc.addReport),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () => _submitReport(userProfile),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: ListView(
              children: <Widget>[
                CustomTextField(
                  controller: _titleController,
                  labelText: context.loc.title,
                ),
                gapH16,

                // Data (mostrata, non modificabile)
                DateDisplay(date: DateTime.now()),
                gapH16,

                // Campo per la descrizione
                CustomTextField(
                  controller: _descriptionController,
                  labelText: context.loc.description,
                  maxLines: 3,
                ),
                gapH16,

                // Dropdown per selezionare l'edificio
                BuildingSelectionDropdown(
                  buildings: userProfile.assignedBuildings.values.toList(),
                  selectedBuilding: _selectedBuilding,
                  onBuildingSelected: (newBuilding) => setState(
                    () => _selectedBuilding = newBuilding,
                  ),
                  showAllBuildings: false,
                ),
                gapH16,

                // Campo di testo per buildingSpot
                CustomTextField(
                  controller: _buildingSpotController,
                  labelText: context.loc.buildingSpot,
                ),
                gapH16,

                // Dropdown per la priorità
                PrioritySelectionDropdown(
                  selectedPriority: _selectedPriority,
                  onPrioritySelected: (newPriority) => setState(
                    () => _selectedPriority = newPriority ?? PriorityLevel.normal,
                  ),
                ),
                gapH16,

                // Galleria di immagini locali
                LocalImageGallery(
                  isOperator: false,
                  imageFiles: _images,
                  canRemove: true,
                  onRemove: (file) => setState(() => _images.remove(file)),
                ),
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
