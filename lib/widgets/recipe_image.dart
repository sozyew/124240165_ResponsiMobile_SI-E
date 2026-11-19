import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;

  const RecipeImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url.isEmpty
          ? placeholder
          : Image.network(
              url,
              width: width,
              height: height,
              fit: fit,
              loadingBuilder: (c, child, p) => p == null
                  ? child
                  : Container(
                      width: width,
                      height: height,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
              errorBuilder: (c, e, s) => placeholder,
            ),
    );
  }
}