import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemStatusBarContrastEnforced: true,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  late final Animation<double> curved =
      CurvedAnimation(parent: controller, curve: Curves.easeInOut);

  AnimationStatus statusAtPause = AnimationStatus.forward;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.reverse();
        } else if (controller.isDismissed) {
          controller.forward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          if (controller.isAnimating) {
            statusAtPause = controller.status;
            return controller.stop(canceled: false);
          }
          if (statusAtPause == AnimationStatus.forward) {
            controller.forward();
          } else {
            controller.reverse();
          }
        },
        child: MediaQuery(
          data: MediaQuery.of(context).removeViewPadding(),
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return ColorBandingMask(
                colorPower: (curved.value * 32).round(),
                child: child!,
              );
            },
            child: const MeshGradient(
              colors: [
                Colors.cyan,
                Colors.pink,
                Colors.yellow,
                Colors.black,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColorBandingMask extends StatelessWidget {
  const ColorBandingMask({
    super.key,
    required this.colorPower,
    required this.child,
  });

  final int colorPower;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'assets/shaders/color_band.frag',
      child: child,
      (context, shader, child) {
        return AnimatedSampler(
          child: child!,
          (image, size, canvas) {
            int i = 0;
            shader.setFloat(i++, size.width);
            shader.setFloat(i++, size.height);
            shader.setFloat(i++, colorPower.toDouble());
            shader.setImageSampler(0, image);
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
