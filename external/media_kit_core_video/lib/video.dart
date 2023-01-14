/// This file is a part of media_kit (https://github.com/alexmercerind/media_kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:media_kit_core_video/media_kit_core_video.dart';

/// {@template video}
///
/// Video
/// -----
/// [Video] widget is used to display video output inside Flutter widget tree.
///
/// Use [VideoController] to initialize & handle the video rendering.
///
/// **Example:**
///
/// ```dart
/// /// Create a [Player] from `package:media_kit`.
/// final player = Player();
/// /// Create a [VideoController] from `package:media_kit_core_video`.
/// VideoController? controller;
///
/// @override
/// void initState() {
///   super.initState();
///   WidgetsBinding.instance.addPostFrameCallback((_) async {
///     final controller = await VideoController.create(player.handle);
///     setState(() {});
///   });
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: Center(
///       /// Use [Video] widget to display video output.
///       child: Video(
///         controller: controller,
///         /// Optionally, height & width may be passed.
///         height: 1920.0,
///         width: 1080.0,
///       ),
///     ),
///   );
/// }
///
/// @override
/// void dispose() {
///   player.dispose();
///   controller?.dispose();
///   super.dispose();
/// }
/// ```
///
/// {@endtemplate}
class Video extends StatefulWidget {
  /// The [VideoController] reference to control this [Video] output & connect with [Player] from `package:media_kit`.
  final VideoController? controller;

  /// Height of this viewport.
  final double? width;

  /// Width of this viewport.
  final double? height;

  /// Alignment of the viewport.
  final Alignment alignment;

  /// Fit of the viewport.
  final BoxFit fit;

  /// Background color to fill the video background.
  final Color fill;

  /// Filter quality of the [Texture] widget displaying the video output.
  final FilterQuality filterQuality;

  /// {@macro video}
  const Video({
    Key? key,
    required this.controller,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
    this.fill = const Color(0xFF000000),
    this.filterQuality = FilterQuality.low,
  }) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      color: widget.fill,
      child: ClipRect(
        child: FittedBox(
          alignment: widget.alignment,
          fit: widget.fit,
          child: widget.controller == null
              ? const SizedBox.shrink()
              : ValueListenableBuilder<int?>(
                  valueListenable: widget.controller!.id,
                  builder: (context, id, _) {
                    return ValueListenableBuilder<Rect?>(
                      valueListenable: widget.controller!.rect,
                      builder: (context, rect, _) {
                        if (id != null && rect != null) {
                          return SizedBox(
                            width: rect.width,
                            height: rect.height,
                            child: Texture(
                              textureId: id,
                              filterQuality: widget.filterQuality,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
