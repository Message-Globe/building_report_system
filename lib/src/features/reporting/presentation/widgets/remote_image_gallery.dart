import '../screens/photo_view_gallery_screen.dart';
import '../../../../routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/app_sizes.dart';

class RemoteImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  final bool canRemove;
  final void Function(String) onRemove;

  const RemoteImageGallery({
    required this.imageUrls,
    required this.canRemove,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Remote photos:"),
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
                          ref.read(goRouterProvider).pushNamed(
                                AppRoute.photoGallery.name,
                                extra: PhotoViewGalleryArgs(
                                  imageUrls: imageUrls,
                                  initialIndex: imageUrls.indexOf(url),
                                ),
                              );
                        },
                        child: Image.network(
                          url,
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
                        onPressed: () => onRemove(url), // Rimuove l'immagine dal server
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
