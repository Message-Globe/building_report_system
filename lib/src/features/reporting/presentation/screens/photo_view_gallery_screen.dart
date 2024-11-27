import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../l10n/string_extensions.dart';
import '../../../../utils/context_extensions.dart';

class PhotoViewGalleryArgs {
  final List<String>? imageUrls; // Lista di URL
  final List<String>? imageUris; // Lista di file locali
  final int initialIndex;

  PhotoViewGalleryArgs({
    this.imageUrls,
    this.imageUris,
    required this.initialIndex,
  }) : assert(imageUrls != null || imageUris != null,
            'One of imageUrls or imageUris must be provided');
}

class PhotoViewGalleryScreen extends StatelessWidget {
  final List<String>? imageUrls;
  final List<String>? imageUris;
  final int initialIndex;

  const PhotoViewGalleryScreen({
    super.key,
    this.imageUrls,
    this.imageUris,
    required this.initialIndex,
  }) : assert(imageUrls != null || imageUris != null,
            'One of imageUrls or imageUris must be provided');

  @override
  Widget build(BuildContext context) {
    final isShowingUrls = imageUrls != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.photoGallery.capitalizeFirst()),
      ),
      body: PhotoViewGallery.builder(
        itemCount: isShowingUrls ? imageUrls!.length : imageUris!.length,
        pageController: PageController(initialPage: initialIndex),
        builder: (context, index) {
          final imageProvider = isShowingUrls
              ? NetworkImage(imageUrls![index])
              : NetworkImage(imageUris![index]);

          return PhotoViewGalleryPageOptions(
            imageProvider: imageProvider,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        enableRotation: true,
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? null
                  : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
            ),
          ),
        ),
      ),
    );
  }
}
