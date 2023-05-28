import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mesh_gradient/counter.dart';
import 'package:mesh_gradient/dithering_mask.dart';
import 'package:mesh_gradient/threshold_map.dart';

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
          controller.reverse();
        } else if (controller.isDismissed) {
          controller.forward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //if (controller.isAnimating) {
        //  statusAtPause = controller.status;
        //  return controller.stop(canceled: false);
        //}
        //if (statusAtPause == AnimationStatus.forward) {
        //  controller.forward();
        //} else {
        //  controller.reverse();
        //}
      },
      child: MediaQuery(
        data: MediaQuery.of(context).removeViewPadding(),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return DitheringMask(
              thresholdMap: ThresholdMap.twoByTwo,
              colorPower: 64,
              child: child!,
            );
          },
          child: const Counter(title: 'counter'),
        ),
      ),
    );
  }
}
