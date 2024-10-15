import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewGalleryArgs {
  final List<String>? imageUrls; // Lista di URL
  final List<File>? imageFiles; // Lista di file locali
  final int initialIndex;

  PhotoViewGalleryArgs({
    this.imageUrls,
    this.imageFiles,
    required this.initialIndex,
  }) : assert(imageUrls != null || imageFiles != null,
            'One of imageUrls or imageFiles must be provided');
}

class PhotoViewGalleryScreen extends StatelessWidget {
  final List<String>? imageUrls;
  final List<File>? imageFiles;
  final int initialIndex;

  const PhotoViewGalleryScreen({
    super.key,
    this.imageUrls,
    this.imageFiles,
    required this.initialIndex,
  }) : assert(imageUrls != null || imageFiles != null,
            'One of imageUrls or imageFiles must be provided');

  @override
  Widget build(BuildContext context) {
    final isShowingUrls = imageUrls != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
      ),
      body: PhotoViewGallery.builder(
        itemCount: isShowingUrls ? imageUrls!.length : imageFiles!.length,
        pageController: PageController(initialPage: initialIndex),
        builder: (context, index) {
          final imageProvider = isShowingUrls
              ? NetworkImage(imageUrls![index])
              : FileImage(imageFiles![index]) as ImageProvider;

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
