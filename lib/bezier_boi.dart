import 'package:bezier/bezier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math.dart' as v;

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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        BezierDemo(),
      ],
    );
  }
}

class PointController with ChangeNotifier {
  PointController(this._x, this._y);

  double _x;
  double _y;

  double get x => _x;

  set x(double newValue) {
    _x = newValue;
    notifyListeners();
  }

  double get y => _y;

  set y(double newValue) {
    _y = newValue;
    notifyListeners();
  }

  Alignment toAlignment() => Alignment(2 * x - 1, 2 * y - 1);

  double left(Size size, double radius) => x * size.width - (radius / 2);

  double top(Size size, double radius) =>
      y * size.height - PointView.kSize + (radius / 2);

  v.Vector2 toVector2(Size size) => v.Vector2(x * size.width, y * size.height);
}

class PointView extends StatelessWidget {
  const PointView({
    super.key,
    this.isDonut = false,
    required this.controller,
  });

  final bool isDonut;

  final PointController controller;

  static const double kSize = 10;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      child: GestureDetector(
        onPanUpdate: (details) {
          final Size size = MediaQuery.sizeOf(context);
          controller.x = (controller.x + details.delta.dx / size.width)
              .clamp(0, size.width);
          controller.y = (controller.y + details.delta.dy / size.height)
              .clamp(0, size.height);
        },
        child: Container(
          height: PointView.kSize,
          width: PointView.kSize,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
          child: isDonut
              ? Container(
                  margin: const EdgeInsets.all(PointView.kSize * .25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                )
              : Container(),
        ),
      ),
      builder: (context, child) {
        final Size size = MediaQuery.sizeOf(context);
        return Container(
          padding: EdgeInsets.only(
            left: controller.left(size, kSize),
            top: controller.top(size, kSize),
          ),
          child: child!,
        );
      },
    );
  }
}

class BezierDemo extends StatefulWidget {
  const BezierDemo({
    super.key,
  });

  @override
  State<BezierDemo> createState() => _BezierDemoState();
}

class _BezierDemoState extends State<BezierDemo> {
  late final PointController a = PointController(.1, .5)
    ..addListener(() {
      setState(() {});
    });
  late final PointController b = PointController(.3, .5)
    ..addListener(() {
      setState(() {});
    });
  late final PointController c = PointController(.7, .5)
    ..addListener(() {
      setState(() {});
    });
  late final PointController d = PointController(.9, .5)
    ..addListener(() {
      setState(() {});
    });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Container(color: Colors.white),
        BezierBoi(
          curve: CubicBezier(
            [
              a.toVector2(size),
              b.toVector2(size),
              c.toVector2(size),
              d.toVector2(size),
            ],
          ),
        ),
        PointView(controller: a),
        PointView(controller: b, isDonut: true),
        PointView(controller: c, isDonut: true),
        PointView(controller: d),
      ],
    );
  }
}

class BezierBoi extends StatelessWidget {
  const BezierBoi({
    super.key,
    required this.curve,
  });

  final CubicBezier curve;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: BezierPainter(curve: curve),
    );
  }
}

class BezierPainter extends CustomPainter {
  const BezierPainter({required this.curve});

  final CubicBezier curve;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 2
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final List<v.Vector2> points = curve.points;
    final Path bezierPath = Path()..moveTo(points[0].x, points[0].y);
    bezierPath.cubicTo(
      points[1].x,
      points[1].y,
      points[2].x,
      points[2].y,
      points[3].x,
      points[3].y,
    );
    canvas.drawPath(bezierPath, paint);

    paint..strokeWidth = 1.5..color = Colors.grey.shade700;
    final Path controlPaths = Path()..moveTo(points[0].x, points[0].y);
    controlPaths.lineTo(points[1].x, points[1].y);
    controlPaths.moveTo(points[2].x, points[2].y);
    controlPaths.lineTo(points[3].x, points[3].y);
    canvas.drawPath(controlPaths, paint);
  }

  @override
  bool shouldRepaint(covariant BezierPainter oldDelegate) {
    return oldDelegate.curve != curve;
  }
}
