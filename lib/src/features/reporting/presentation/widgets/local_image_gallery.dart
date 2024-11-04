import 'dart:convert';
import '../../../../l10n/string_extensions.dart';

import '../../../../utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart'; // Importa ImagePicker per scattare foto
import '../../../../constants/app_sizes.dart';
import '../../../../routing/app_router.dart';
import '../screens/photo_view_gallery_screen.dart';

class LocalImageGallery extends StatefulWidget {
  final bool isOperator;
  final List<String> imageUris;
  final bool canRemove;
  final void Function(String) onRemove; // Funzione per rimuovere l'immagine locale

  const LocalImageGallery({
    required this.isOperator,
    required this.imageUris,
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
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final dataUri = 'data:image/png;base64,$base64Image';

      setState(() {
        widget.imageUris.add(dataUri);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Galleria di immagini locali in un wrap
        if (widget.imageUris.isNotEmpty) ...[
          widget.isOperator
              ? Text(context.loc.localRepairPhotos.capitalizeFirst())
              : Text(context.loc.localReportPhotos.capitalizeFirst()),
          gapH4,
          Wrap(
            spacing: Sizes.p12,
            runSpacing: Sizes.p12,
            children: widget.imageUris.map(
              (uri) {
                return Stack(
                  children: <Widget>[
                    Consumer(
                      builder: (_, ref, __) {
                        return GestureDetector(
                          onTap: () => context.goNamed(
                            AppRoute.photoGallery.name,
                            extra: PhotoViewGalleryArgs(
                              imageUris: widget.imageUris,
                              initialIndex: widget.imageUris.indexOf(uri),
                            ),
                          ),
                          child: Image.network(
                            uri,
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
                              widget.onRemove(uri), // Rimuove l'immagine locale
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
            label: Text(context.loc.addPhoto.capitalizeFirst()),
            onPressed: _addPhoto,
          ),
        ),
      ],
    );
  }
}
