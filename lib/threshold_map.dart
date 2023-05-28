import 'dart:async';
import 'dart:typed_data';

import 'dart:ui' as ui;

sealed class ThresholdMap {
  ThresholdMap(this.matrix)
      : assert(matrix.every((row) => row.length == matrix.length)),
        dimension = matrix.length,
        maxValue = matrix.length * matrix.length;

  List<List<int>> matrix;
  int dimension;
  int maxValue;

  List<List<int>> normalizedTo([int normalize = 255]) {
    return matrix
        .map(
          (row) => row
              .map(
                (value) => (value * normalize / maxValue.toDouble()).round(),
              )
              .toList(),
        )
        .toList();
  }

  Uint8List toUint8List() {
    return Uint8List.fromList(
      normalizedTo().expand((row) {
        return row.expand((value) {
          return List.filled(4, 0)..setAll(0, List.filled(3, value));
        }).toList();
      }).toList(),
    );
  }



  Future<ui.Image> toImage() async {
    final Completer<ui.Image> completer = Completer();
    final Uint8List pixels = toUint8List();
    ui.decodeImageFromPixels(
      pixels,
      dimension,
      dimension,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );
    return completer.future;
  }

  static ThresholdMap twoByTwo = _TwoByTwoThresholdMap._();

  static ThresholdMap fourByFour = _FourByFourThresholdMap._();

  static ThresholdMap identity = _Identity._();
}

class _TwoByTwoThresholdMap extends ThresholdMap {
  _TwoByTwoThresholdMap._()
      : super(
          [
            [0, 2],
            [3, 1],
          ],
        );
}

class _FourByFourThresholdMap extends ThresholdMap {
  _FourByFourThresholdMap._()
      : super(
          [
            [0, 8, 2, 10],
            [12, 4, 14, 6],
            [3, 11, 1, 9],
            [15, 7, 13, 5],
          ],
        );
}

class _Identity extends ThresholdMap {
  _Identity._()
      : super(
    [
      [16, 0, 0, 0],
      [0, 16, 0, 0],
      [0, 0, 16, 0],
      [0, 0, 0, 16],
    ],
  );
}
