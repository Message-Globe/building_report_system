import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/local_image_gallery.dart';
import '../widgets/remote_image_gallery.dart';
import '../../../../constants/app_sizes.dart';

class CombinedImageGallery extends StatelessWidget {
  final List<File> localImages;
  final List<String> remoteImages;
  final bool canEdit;
  final void Function(File) onRemoveLocal;
  final void Function(String) onRemoveRemote;

  const CombinedImageGallery({
    required this.localImages,
    required this.remoteImages,
    required this.canEdit,
    required this.onRemoveLocal,
    required this.onRemoveRemote,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (remoteImages.isNotEmpty)
          RemoteImageGallery(
            imageUrls: remoteImages,
            canRemove: canEdit,
            onRemove: onRemoveRemote, // Passa il callback per rimuovere l'immagine remota
          ),
        if (remoteImages.isNotEmpty && canEdit) gapH16,
        if (canEdit)
          LocalImageGallery(
            imageFiles: localImages,
            canRemove: canEdit,
            onRemove: onRemoveLocal, // Passa il callback per rimuovere l'immagine locale
          ),
      ],
    );
  }
}
