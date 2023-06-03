import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mesh_gradient/counter.dart';
import 'package:mesh_gradient/polar_mask.dart';

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
    )..addListener(() {
        if (controller.isCompleted) {
          //controller.reverse();
        } else if (controller.isDismissed) {
          controller.forward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
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
          child: SizedBox.expand(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return PolarMask(
                  progress: controller.value,
                  child: child!,
                );
              },
              child: Container(
                color: Colors.white,
                child: const Counter(title: 'Counter'),
                //child: ShaderMask(
                //  shaderCallback: (rect) {
                //    return const LinearGradient(
                //      begin: Alignment.bottomCenter,
                //      end: Alignment.topCenter,
                //      colors: [Colors.black, Colors.transparent],
                //    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                //  },
                //  blendMode: BlendMode.dstIn,
                //  child: const DecoratedBox(
                //    decoration: BoxDecoration(
                //      gradient: LinearGradient(
                //        begin: Alignment.centerLeft,
                //        end: Alignment.centerRight,
                //        colors: [
                //          Colors.blue,
                //          Colors.purple,
                //          Colors.red,
                //          Colors.orange,
                //          Colors.yellow,
                //          Colors.green,
                //          Colors.teal,
                //          Colors.blue,
                //        ],
                //      ),
                //    ),
                //  ),
                //),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
