import 'package:building_report_system/src/features/authentication/data/auth_repository.dart';
import 'package:building_report_system/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:building_report_system/src/utils/date_formatter.dart';

import '../../../../constants/app_sizes.dart';
import '../../../authentication/domain/user_profile.dart';
import '../widgets/building_filter_dropdown.dart';
import '../../domain/report.dart';
import 'photo_view_gallery_screen.dart';

class EditReportScreen extends ConsumerStatefulWidget {
  final Report report; // Passa il report da modificare

  const EditReportScreen({super.key, required this.report});

  @override
  ConsumerState<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends ConsumerState<EditReportScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repairDescriptionController = TextEditingController(); // Per operator
  final List<File> _newImages = []; // Immagini aggiunte dall'operatore
  String? _selectedBuilding;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Popola i campi con i dati esistenti del report
    _titleController.text = widget.report.title;
    _descriptionController.text = widget.report.description;
    _selectedBuilding = widget.report.buildingId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _repairDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _newImages.add(File(pickedFile.path));
      });
    }
  }

  void _submitReport() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    // TODO: Logica per inviare il report modificato con i dati aggiornati e le nuove foto
    ref.read(goRouterProvider).pop();
  }

  void _completeReport() {
    // Funzionalità specifica per gli operatori per completare il report
    final repairDescription = _repairDescriptionController.text;
    if (repairDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide repair details')),
      );
      return;
    }

    // TODO: Logica per segnare il report come completato e inviare il report con le foto aggiornate
    ref.read(goRouterProvider).pop();
  }

  void _openPhotoViewGallery(List<String> imageUrls, int initialIndex) {
    final args = PhotoViewGalleryArgs(imageUrls: imageUrls, initialIndex: initialIndex);
    ref.read(goRouterProvider).pushNamed(AppRoute.photoGallery.name, extra: args);
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(authStateProvider).asData!.value!;
    final dateFormatter = ref.read(dateFormatterProvider);
    final isReporter = userProfile.role == UserRole.reporter;
    final isOperator = userProfile.role == UserRole.operator;
    final reportEditable = widget.report.status == ReportStatus.open;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Report'),
        actions: [
          if (isOperator) // Se è un operatore, mostra il pulsante "Complete"
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _completeReport,
            ),
          if (isReporter && reportEditable) // Se è un reporter e il report è attivo
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _submitReport,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: ListView(
          children: [
            // Campo per il titolo, modificabile solo per il reporter
            if (isReporter && reportEditable)
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Report Title',
                  border: OutlineInputBorder(),
                ),
              )
            else
              Text('Title: ${widget.report.title}'), // Solo visualizzazione per operatori
            const SizedBox(height: Sizes.p16),

            // Data (mostrata, non modificabile)
            Text(
              'Date: ${dateFormatter.format(widget.report.date)}',
              style: const TextStyle(fontSize: Sizes.p16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Sizes.p16),

            // Campo per la descrizione, modificabile solo per il reporter
            if (isReporter && reportEditable)
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              )
            else
              Text('Description: ${widget.report.description}'), // Solo visualizzazione
            const SizedBox(height: Sizes.p16),

            // Dropdown per selezionare l'edificio, modificabile solo per il reporter
            if (isReporter && reportEditable)
              BuildingFilterDropdown(
                buildingIds: userProfile.buildingsIds,
                selectedBuilding: _selectedBuilding,
                onBuildingSelected: (newBuilding) {
                  setState(() {
                    _selectedBuilding = newBuilding;
                  });
                },
                showAllBuildings: false,
              )
            else
              Text('Building: ${widget.report.buildingId}'), // Solo visualizzazione
            const SizedBox(height: Sizes.p16),

            // Visualizza le immagini già associate al report
            if (widget.report.photoUrls.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Report Photos:',
                    style: TextStyle(fontSize: Sizes.p16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: Sizes.p8),
                  Wrap(
                    spacing: Sizes.p12,
                    runSpacing: Sizes.p12,
                    children: widget.report.photoUrls.map(
                      (url) {
                        final index = widget.report.photoUrls.indexOf(url);
                        return GestureDetector(
                          onTap: () =>
                              _openPhotoViewGallery(widget.report.photoUrls, index),
                          child: Image.network(
                            url,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            const SizedBox(height: Sizes.p16),

            // Se è un operatore, aggiungi il campo per descrivere i lavori svolti
            if (isOperator)
              TextField(
                controller: _repairDescriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Repair Description',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: Sizes.p16),

            // Bottone per aggiungere la foto
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Add Photo'),
              onPressed: _pickImage,
            ),
            const SizedBox(height: Sizes.p16),

            // Mostra le immagini selezionate e aggiunte
            if (_newImages.isNotEmpty)
              Wrap(
                spacing: Sizes.p12,
                runSpacing: Sizes.p12,
                children: _newImages.map(
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
                                _newImages.remove(image);
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
    );
  }
}
