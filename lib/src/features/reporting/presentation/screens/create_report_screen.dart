import 'package:building_report_system/src/features/authentication/data/auth_repository.dart';
import 'package:building_report_system/src/features/reporting/presentation/controllers/create_report_screen_controller.dart';
import 'package:building_report_system/src/routing/app_router.dart';
import 'package:building_report_system/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:building_report_system/src/utils/date_formatter.dart';

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
  final List<File> _images = [];
  String? _selectedBuilding;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _submitReport() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty || _selectedBuilding == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final imagesUrls = _images.map((image) => image.path).toList();

    // Chiama il metodo addReport
    await ref.read(createReportScreenControllerProvider.notifier).addReport(
          userProfile: ref.read(authStateProvider).asData!.value!,
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

    final userProfile = ref.watch(authStateProvider).asData!.value!;
    final dateFormatter = ref.read(dateFormatterProvider);
    final state = ref.watch(createReportScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitReport,
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

                // Bottone per aggiungere la foto
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Add Photo'),
                  onPressed: _pickImage,
                ),
                const SizedBox(height: Sizes.p16),

                // Mostra le immagini selezionate
                if (_images.isNotEmpty)
                  Wrap(
                    spacing: Sizes.p12,
                    runSpacing: Sizes.p12,
                    children: _images.map(
                      (image) {
                        return Stack(
                          children: [
                            Image.file(
                              image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _images.remove(image);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
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
