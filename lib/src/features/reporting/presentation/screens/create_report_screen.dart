import '../widgets/category_selection_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../l10n/string_extensions.dart';
import '../../../../routing/app_router.dart';
import '../../../../utils/async_value_ui.dart';
import '../../../../utils/context_extensions.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../authentication/domain/building.dart';
import '../../../authentication/domain/user_profile.dart';
import '../../domain/report.dart';
import '../controllers/create_report_screen_controller.dart';
import '../widgets/building_area_selection_list.dart';
import '../widgets/building_selection_dropdown.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/date_display.dart';
import '../widgets/local_image_gallery.dart';
import '../widgets/priority_selection_dropdown.dart';

class CreateReportScreen extends ConsumerStatefulWidget {
  const CreateReportScreen({super.key});

  @override
  ConsumerState<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends ConsumerState<CreateReportScreen> {
  final _descriptionController = TextEditingController();
  final _resolveByController = TextEditingController();
  String? _selectedCategory;
  Building? _selectedBuilding;
  Map<String, String>? _selectedArea;
  PriorityLevel _selectedPriority = PriorityLevel.medium;
  final List<String> _imageUris = [];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport(UserProfile userProfile) async {
    final description = _descriptionController.text;
    final resolveBy =
        _resolveByController.text.isEmpty ? null : _resolveByController.text;

    if (description.isEmpty ||
        _selectedBuilding == null ||
        _selectedArea == null ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.completeAllFields.capitalizeFirst()),
        ),
      );
      return;
    }

    // Chiama il metodo addReport
    await ref.read(createReportScreenControllerProvider.notifier).createReport(
          category: _selectedCategory!,
          building: _selectedBuilding!,
          buildingAreaId: _selectedArea!['id']!,
          priority: _selectedPriority,
          description: description,
          resolveBy: resolveBy,
          photos: _imageUris,
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
            title: Text(context.loc.addReport.capitalizeFirst()),
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
                CategorySelectionDropdown(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (value) =>
                      setState(() => _selectedCategory = value),
                ),
                gapH16,

                // Data (mostrata, non modificabile)
                DateDisplay(date: DateTime.now()),
                gapH16,

                // Campo per la descrizione
                CustomTextField(
                  controller: _descriptionController,
                  labelText: context.loc.description.capitalizeFirst(),
                  maxLines: 3,
                ),
                gapH16,

                // Da risolvere entro il
                CustomTextField(
                  controller: _resolveByController,
                  labelText: context.loc.resolveBy.capitalizeFirst(),
                ),
                gapH16,

                // Dropdown per selezionare l'edificio
                BuildingSelectionDropdown(
                  buildings: userProfile.assignedBuildings,
                  selectedBuilding: _selectedBuilding,
                  onBuildingSelected: (newBuilding) {
                    setState(
                      () {
                        _selectedBuilding = newBuilding;
                        _selectedArea = null;
                      },
                    );
                    if (newBuilding != null) {
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
                  showAllBuildings: false,
                ),
                gapH16,

                if (_selectedArea != null) ...[
                  Text(
                      '${context.loc.selectedArea.capitalizeFirst()} ${_selectedArea!['name']}'),
                  gapH16,
                ],

                // Dropdown per la priorità
                PrioritySelectionDropdown(
                  selectedPriority: _selectedPriority,
                  onPrioritySelected: (newPriority) => setState(
                    () => _selectedPriority = newPriority ?? PriorityLevel.medium,
                  ),
                ),
                gapH16,

                // Galleria di immagini locali
                LocalImageGallery(
                  isOperator: false,
                  imageUris: _imageUris,
                  canRemove: true,
                  onRemove: (file) => setState(() => _imageUris.remove(file)),
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
