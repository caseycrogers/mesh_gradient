import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemStatusBarContrastEnforced: true,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).removeViewPadding(),
      child: const Scaffold(
        body: MeshGradient(),
      ),
    );
  }
}

class MeshGradient extends StatefulWidget {
  const MeshGradient({super.key});

  @override
  State<MeshGradient> createState() => _MeshGradientState();
}

class _MeshGradientState extends State<MeshGradient> {
  final Future<FragmentProgram> futureFragment =
      FragmentProgram.fromAsset('assets/shaders/mesh_gradient.frag');

  @override
  Widget build(BuildContext context) {
    //return FutureBuilder(
    //  future: futureFragment,
    //  builder: (context, snap) {
    //    if (snap.hasError) {
    //      return Text('${snap.error}:\n${snap.stackTrace}');
    //    }
    //    if (!snap.hasData) {
    //      return Container();
    //    }
    //    return CustomPaint(
    //      painter: MeshGradientPainter(
    //        shader: snap.requireData.fragmentShader(),
    //      ),
    //    );
    //  },
    //);
    return ShaderBuilder(
      assetKey: 'assets/shaders/mesh_gradient.frag',
      (context, shader, child) {
        return CustomPaint(
          size: MediaQuery.sizeOf(context),
          painter: MeshGradientPainter(shader: shader),
        );
      },
    );
  }
}

class MeshGradientPainter extends CustomPainter {
  MeshGradientPainter({
    required this.shader,
  });

  FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    final List<Color> colors = [
      Colors.pink,
      Colors.blue,
      Colors.orange,
      Colors.green,
    ];
    shader.setFloat(0, size.height);
    shader.setFloat(1, size.width);
    int i = 2;
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
    return false;
  }
}
