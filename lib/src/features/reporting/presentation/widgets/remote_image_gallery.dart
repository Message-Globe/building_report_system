import 'dart:typed_data';
import '../../../authentication/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';
import '../../../../l10n/string_extensions.dart';
import '../../../../utils/context_extensions.dart';
import 'package:go_router/go_router.dart';
import '../screens/photo_view_gallery_screen.dart';
import '../../../../routing/app_router.dart';
import '../../../../constants/app_sizes.dart';

class RemoteImageGallery extends ConsumerWidget {
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
    print('IM HERE 1');
    print(url);
    // TODO: check here with phone
    // final response = url.startsWith('file://') || File(url).existsSync();
    final response = url.startsWith('file://');
    // final response = url.startsWith('file://') || File(url).existsSync();
    print('IM HERE 2');
    return response;
  }

  Future<Uint8List> _fetchImageWithToken(String url, String token) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.read(authRepositoryProvider).userToken;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isOperator
            ? Text(context.loc.remoteRepairPhotos.capitalizeFirst())
            : Text(context.loc.remoteReportPhotos.capitalizeFirst()),
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
                          context.pushNamed(
                            AppRoute.photoGallery.name,
                            extra: PhotoViewGalleryArgs(
                              imageUrls: imageUrls,
                              initialIndex: imageUrls.indexOf(url),
                            ),
                          );
                        },
                        child: FutureBuilder<Uint8List>(
                          future: _isLocalImage(url)
                              ? Future.value(File(url).readAsBytesSync())
                              : _fetchImageWithToken(url, token),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Icon(
                                Icons.error,
                                color: Colors.grey,
                                size: 100,
                              );
                            } else {
                              return Image.memory(
                                snapshot.data!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                  if (canRemove)
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => onRemove(url),
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
