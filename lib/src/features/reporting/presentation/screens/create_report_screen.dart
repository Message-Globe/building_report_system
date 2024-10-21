import '../../domain/report.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/date_display.dart';
import '../widgets/priority_selection_dropdown.dart';
import '../../../../localization/string_hardcoded.dart';
import '../widgets/local_image_gallery.dart';
import '../../../authentication/data/auth_repository.dart';
import '../controllers/create_report_screen_controller.dart';
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

  void _submitReport() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final buildingSpot = _buildingSpotController.text;

    if (title.isEmpty ||
        description.isEmpty ||
        _selectedBuilding == null ||
        buildingSpot.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete all fields'.hardcoded),
        ),
      );
      return;
    }

    final imagesUrls = _images.map((image) => image.path).toList();

    // Chiama il metodo addReport
    await ref.read(createReportScreenControllerProvider.notifier).addReport(
          buildingId: _selectedBuilding!,
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
            title: const Text('Add Report'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _submitReport,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: ListView(
              children: <Widget>[
                CustomTextField(
                  controller: _titleController,
                  labelText: 'Report Title',
                ),
                gapH16,

                // Data (mostrata, non modificabile)
                DateDisplay(date: DateTime.now()),
                gapH16,

                // Campo per la descrizione
                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  maxLines: 3,
                ),
                gapH16,

                // Dropdown per selezionare l'edificio
                BuildingSelectionDropdown(
                  buildingIds: userProfile.buildingsIds,
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
                  labelText: 'Building Spot',
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
