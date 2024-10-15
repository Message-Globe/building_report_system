import '../widgets/local_image_gallery.dart';

import '../../../authentication/data/auth_repository.dart';
import '../controllers/create_report_screen_controller.dart';
import '../../../../routing/app_router.dart';
import '../../../../utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../../utils/date_formatter.dart';

import '../../../../constants/app_sizes.dart';
import '../widgets/building_filter_dropdown.dart';

class CreateReportScreen extends ConsumerStatefulWidget {
  const CreateReportScreen({super.key});

  @override
  ConsumerState<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends ConsumerState<CreateReportScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedBuilding;
  final List<File> _images = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty || _selectedBuilding == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields'),
        ),
      );
      return;
    }

    final imagesUrls = _images.map((image) => image.path).toList();

    // Chiama il metodo addReport
    await ref.read(createReportScreenControllerProvider.notifier).addReport(
          buildingId: _selectedBuilding!,
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

    final state = ref.watch(createReportScreenControllerProvider);
    final userProfile = ref.watch(authStateProvider).asData!.value!;
    final dateFormatter = ref.read(dateFormatterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: state.isLoading ? null : _submitReport,
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: ListView(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Report Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: Sizes.p16),

                // Data (mostrata, non modificabile)
                Text(
                  'Date: ${dateFormatter.format(DateTime.now())}',
                  style:
                      const TextStyle(fontSize: Sizes.p16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: Sizes.p16),

                // Campo per la descrizione
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: Sizes.p16),

                // Dropdown per selezionare l'edificio
                BuildingFilterDropdown(
                  buildingIds: userProfile.buildingsIds,
                  selectedBuilding: _selectedBuilding,
                  onBuildingSelected: (newBuilding) {
                    setState(() {
                      _selectedBuilding = newBuilding;
                    });
                  },
                  showAllBuildings: false,
                ),
                const SizedBox(height: Sizes.p16),

                LocalImageGallery(
                  imageFiles: _images,
                  canRemove: true,
                  onRemove: (file) {
                    setState(
                      () {
                        _images.remove(file);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          if (state.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
