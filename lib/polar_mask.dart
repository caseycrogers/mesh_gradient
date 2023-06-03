import 'package:flutter/material.dart';

import 'package:flutter_shaders/flutter_shaders.dart';

class PolarMask extends StatelessWidget {
  const PolarMask({
    super.key,
    required this.progress,
    required this.child,
  });

  final double progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'packages/mesh_gradient/shaders/polar_mask.frag',
      child: child,
      (context, shader, child) {
        return AnimatedSampler(
          child: child!,
          (image, size, canvas) {
            int i = 0;
            shader.setFloat(i++, size.width);
            shader.setFloat(i++, size.height);
            shader.setFloat(i++, progress);
            i = 0;
            shader.setImageSampler(i++, image);
            final Paint paint = Paint()..shader = shader;

            canvas.drawRect(
              Rect.fromLTWH(0, 0, size.width, size.height),
              paint,
            );
          },
        );
      },
    );
  }
}
