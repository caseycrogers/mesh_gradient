import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class MeshGradient extends StatelessWidget {
  const MeshGradient({
    super.key,
    required this.colors,
  });

  factory MeshGradient.cmyk() {
    return const MeshGradient(
      colors: [
        Colors.cyan,
        Colors.pink,
        Colors.yellow,
        Colors.black,
      ],
    );
  }

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'packages/mesh_gradient/shaders/mesh_gradient.frag',
      (context, shader, child) {
        return CustomPaint(
          size: MediaQuery.sizeOf(context),
          painter: MeshGradientPainter(
            shader: shader,
            colors: colors,
          ),
        );
      },
    );
  }
}

class MeshGradientPainter extends CustomPainter {
  MeshGradientPainter({
    required this.shader,
    required this.colors,
  });

  FragmentShader shader;

  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    int i = 0;
    shader.setFloat(i++, size.width);
    shader.setFloat(i++, size.height);
    for (final Color color in colors) {
      shader.setFloat(i++, color.red.toDouble() / 255 * color.opacity);
      shader.setFloat(i++, color.green.toDouble() / 255 * color.opacity);
      shader.setFloat(i++, color.blue.toDouble() / 255 * color.opacity);
      shader.setFloat(i++, color.opacity);
    }

    final paint = Paint()..shader = shader;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant MeshGradientPainter oldDelegate) {
    // TODO: repaint on input changes.
    return true;
  }
}
