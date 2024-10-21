import 'dart:io';
import 'package:go_router/go_router.dart';
import '../screens/photo_view_gallery_screen.dart';
import '../../../../routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/app_sizes.dart';

class RemoteImageGallery extends StatelessWidget {
  final bool isOperator;
  final List<String> imageUrls;
  final bool canRemove;
  final void Function(String) onRemove;

  const RemoteImageGallery({
    required this.isOperator,
    required this.imageUrls,
    required this.canRemove,
    required this.onRemove,
    super.key,
  });

  bool _isLocalImage(String url) {
    // Verifica se l'URL è un percorso di file locale
    return url.startsWith('file://') || File(url).existsSync();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${isOperator ? 'Repair ' : ''}Photos:"),
        gapH4,
        Wrap(
          spacing: Sizes.p12,
          runSpacing: Sizes.p12,
          children: imageUrls.map(
            (url) {
              return Stack(
                children: <Widget>[
                  Consumer(
                    builder: (_, ref, __) {
                      return GestureDetector(
                        onTap: () {
                          context.goNamed(
                            AppRoute.photoGallery.name,
                            extra: PhotoViewGalleryArgs(
                              imageUrls: imageUrls,
                              initialIndex: imageUrls.indexOf(url),
                            ),
                          );
                        },
                        child: _isLocalImage(url)
                            ? Image.file(
                                File(url), // Usa Image.file per immagini locali
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                url, // Usa Image.network per immagini remote
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      );
                    },
                  ),
                  if (canRemove)
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => onRemove(url), // Rimuove l'immagine
                      ),
                    ),
                ],
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
