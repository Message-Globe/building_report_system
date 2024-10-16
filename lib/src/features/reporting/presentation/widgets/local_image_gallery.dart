import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // Importa ImagePicker per scattare foto
import '../../../../constants/app_sizes.dart';
import '../../../../routing/app_router.dart';
import '../screens/photo_view_gallery_screen.dart';

class LocalImageGallery extends StatefulWidget {
  final List<File> imageFiles;
  final bool canRemove;
  final void Function(File) onRemove; // Funzione per rimuovere l'immagine locale

  const LocalImageGallery({
    required this.imageFiles,
    required this.canRemove,
    required this.onRemove,
    super.key,
  });

  @override
  State<LocalImageGallery> createState() => _LocalImageGalleryState();
}

class _LocalImageGalleryState extends State<LocalImageGallery> {
  final ImagePicker _picker = ImagePicker();

  // Funzione per scattare una foto e aggiungerla alla lista
  Future<void> _addPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        widget.imageFiles.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Galleria di immagini locali in un wrap
        if (widget.imageFiles.isNotEmpty) ...[
          const Text("Local photos:"),
          gapH4,
          Wrap(
            spacing: Sizes.p12,
            runSpacing: Sizes.p12,
            children: widget.imageFiles.map(
              (file) {
                return Stack(
                  children: <Widget>[
                    Consumer(
                      builder: (_, ref, __) {
                        return GestureDetector(
                          onTap: () {
                            debugPrint(widget.imageFiles.length.toString());
                            ref.read(goRouterProvider).pushNamed(
                                  AppRoute.photoGallery.name,
                                  extra: PhotoViewGalleryArgs(
                                    imageFiles: widget.imageFiles,
                                    initialIndex: widget.imageFiles.indexOf(file),
                                  ),
                                );
                          },
                          child: Image.file(
                            file,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                    if (widget.canRemove)
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () =>
                              widget.onRemove(file), // Rimuove l'immagine locale
                        ),
                      ),
                  ],
                );
              },
            ).toList(),
          ),
          gapH16,
        ],

        // Pulsante per aggiungere foto
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Add Photo'),
            onPressed: _addPhoto,
          ),
        ),
      ],
    );
  }
}
