import 'dart:io';

import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AniImage extends StatelessWidget {
  final String image;

  const AniImage({required this.image, super.key});

  @override
  Widget build(context) {
    final height = (400 * MediaQuery.of(context).devicePixelRatio).toInt();
    return AspectRatio(
      aspectRatio: 10 / 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: FadeInImage(
          key: UniqueKey(),
          fadeInDuration: const Duration(milliseconds: 300),
          placeholder: MemoryImage(kTransparentImage),
          fit: BoxFit.cover,
          image: image.startsWith("https://")
              ? CachedNetworkImageProvider(
                  maxHeight: height,
                  image,
                ) as ImageProvider
              : ResizeImage(
                  height: height,
                  FileImage(
                    File(image),
                  ),
                ),
        ),
      ),
    );
  }
}

Uint8List kTransparentImage = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x06,
  0x62,
  0x4B,
  0x47,
  0x44,
  0x00,
  0xFF,
  0x00,
  0xFF,
  0x00,
  0xFF,
  0xA0,
  0xBD,
  0xA7,
  0x93,
  0x00,
  0x00,
  0x00,
  0x09,
  0x70,
  0x48,
  0x59,
  0x73,
  0x00,
  0x00,
  0x0B,
  0x13,
  0x00,
  0x00,
  0x0B,
  0x13,
  0x01,
  0x00,
  0x9A,
  0x9C,
  0x18,
  0x00,
  0x00,
  0x00,
  0x07,
  0x74,
  0x49,
  0x4D,
  0x45,
  0x07,
  0xE6,
  0x03,
  0x10,
  0x17,
  0x07,
  0x1D,
  0x2E,
  0x5E,
  0x30,
  0x9B,
  0x00,
  0x00,
  0x00,
  0x0B,
  0x49,
  0x44,
  0x41,
  0x54,
  0x08,
  0xD7,
  0x63,
  0x60,
  0x00,
  0x02,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0xE2,
  0x26,
  0x05,
  0x9B,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);
