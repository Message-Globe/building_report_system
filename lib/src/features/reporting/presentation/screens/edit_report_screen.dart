import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../../constants/app_sizes.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../../routing/app_router.dart';
import '../../../../utils/date_formatter.dart';
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
  final List<File> _localImages = [];
  final List<String> _remoteImages = [];
  final _repairDescriptionController = TextEditingController();
  final List<File> _repairLocalImages = [];
  final List<String> _repairRemoteImages = [];

  late ReportStatus _reportStatus;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.report.title;
    _descriptionController.text = widget.report.description;
    _remoteImages.addAll(widget.report.photoUrls);
    _repairDescriptionController.text = widget.report.repairDescription;
    _repairRemoteImages.addAll(widget.report.repairPhotosUrls);
    _reportStatus = widget.report.status; // Imposta lo stato iniziale del report
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _repairDescriptionController.dispose();
    super.dispose();
  }

  // Invio del report modificato (converti nuovamente i file in URL)
  void _submitReport() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields'),
        ),
      );
      return;
    }

    // TODO: Logica per caricare le immagini su un server e ottenere gli URL

    ref.read(goRouterProvider).pop();
  }

  void _completeReport() {
    final repairDescription = _repairDescriptionController.text;
    if (repairDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide repair details'),
        ),
      );
      return;
    }
    // TODO: Logica per completare il report e inviare le nuove immagini
    ref.read(goRouterProvider).pop();
  }

  void _updateReportStatus(ReportStatus newStatus) {
    setState(() {
      _reportStatus = newStatus;
    });
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
          if (isOperator)
            IconButton(icon: const Icon(Icons.check), onPressed: _completeReport),
          if (isReporter && reportEditable)
            IconButton(icon: const Icon(Icons.save), onPressed: _submitReport),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: ListView(
          children: [
            // Titolo
            if (isReporter && reportEditable)
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Report Title',
                  border: OutlineInputBorder(),
                ),
              )
            else
              Text('Title: ${widget.report.title}'),
            const SizedBox(height: Sizes.p16),

            // Data
            Text(
              'Date: ${dateFormatter.format(widget.report.date)}',
              style: const TextStyle(fontSize: Sizes.p16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Sizes.p16),

            // Descrizione
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
              Text('Description: ${widget.report.description}'),
            const SizedBox(height: Sizes.p16),

            // Galleria combinata (locali e remote)
            CombinedImageGallery(
              localImages: _localImages,
              remoteImages: _remoteImages,
              canEdit: isReporter,
              onRemoveLocal: (file) {
                setState(() {
                  _localImages.remove(file); // Rimuovi immagine locale
                });
              },
              onRemoveRemote: (url) {
                setState(() {
                  _remoteImages.remove(url); // Rimuovi immagine remota
                });
              },
            ),

            if (isOperator) ...[
              const SizedBox(height: Sizes.p8),
              const Divider(),
              const SizedBox(height: Sizes.p8),
            ],

            // Descrizione dei lavori (solo per operator)
            if (isOperator) ...[
              TextField(
                controller: _repairDescriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Repair Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: Sizes.p16),
              CombinedImageGallery(
                localImages: _repairLocalImages,
                remoteImages: _repairRemoteImages,
                canEdit: isOperator,
                onRemoveLocal: (file) {
                  setState(() {
                    _repairLocalImages.remove(file);
                  });
                },
                onRemoveRemote: (url) {
                  setState(() {
                    _repairRemoteImages.remove(url);
                  });
                },
              ),
            ],

            const SizedBox(height: Sizes.p16),

            // Dismissible widget to change the report status from assigned to completed
            if (isOperator && _reportStatus == ReportStatus.assigned) ...[
              const SizedBox(height: Sizes.p8),
              const Text('Swipe to complete report:'),
              const SizedBox(height: Sizes.p8),
              Dismissible(
                key: const Key('reportStatusDismissible'),
                direction: DismissDirection.startToEnd,
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.check, color: Colors.white),
                ),
                onDismissed: (direction) {
                  // Cambia lo stato del report a completed
                  _updateReportStatus(ReportStatus.completed);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report status updated to Completed'),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(Sizes.p16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(Sizes.p8),
                  ),
                  child: const Text(
                    'Swipe right to mark as Completed',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
