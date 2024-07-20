import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SCImage extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;

  const SCImage({super.key, this.imageUrl, this.height = double.infinity, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Placeholder(
          color: Colors.white,
          fallbackHeight: height,
          fallbackWidth: width,
        ),
        if (imageUrl != null)
          CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
      ],
    );
  }
}