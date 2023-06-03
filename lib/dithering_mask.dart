import 'dart:async';

import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:mesh_gradient/threshold_map.dart';

class DitheringMask extends StatefulWidget {
  const DitheringMask({
    super.key,
    required this.colorPower,
    required this.thresholdMap,
    required this.child,
  });

  final int colorPower;
  final ThresholdMap thresholdMap;
  final Widget child;

  @override
  State<DitheringMask> createState() => _DitheringMaskState();
}

class _DitheringMaskState extends State<DitheringMask> {
  late Future<ui.Image> asyncThresholdMapImage = widget.thresholdMap.toImage();

  @override
  void didUpdateWidget(covariant DitheringMask oldWidget) {
    if (oldWidget.thresholdMap != widget.thresholdMap) {
      asyncThresholdMapImage = widget.thresholdMap.toImage();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: asyncThresholdMapImage,
      builder: (context, snap) {
        if (snap.hasError) {
          return Text(
            '${snap.error}:\n${snap.stackTrace}',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          );
        }
        if (!snap.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ShaderBuilder(
          assetKey: 'packages/mesh_gradient/shaders/dither.frag',
          child: widget.child,
          (context, shader, child) {
            return AnimatedSampler(
              child: child!,
              (image, size, canvas) {
                int i = 0;
                shader.setFloat(i++, size.width);
                shader.setFloat(i++, size.height);
                shader.setFloat(i++, widget.thresholdMap.dimension.toDouble());
                shader.setFloat(i++, widget.colorPower.toDouble());
                i = 0;
                shader.setImageSampler(i++, image);
                shader.setImageSampler(i++, snap.requireData);
                final Paint paint = Paint()..shader = shader;

                canvas.drawRect(
                  Rect.fromLTWH(0, 0, size.width, size.height),
                  paint,
                );
              },
            );
          },
        );
      },
    );
  }
}

Future<String> foo(int? i) async {
  return switch (i) {
    null => 'No message',
    int i => (await asyncGetRecord(i)).$2,
  };
}

Future<(int, String)> asyncGetRecord(int i) async {
  return (0, 'asdf');
}
