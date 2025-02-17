import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

Uint8List preprocessImage(Uint8List imageData) {
  img.Image image = img.decodeImage(imageData)!;

  image = img.grayscale(image);

  image = img.copyResize(image, width: 28, height: 28);

  final Float32List input = Float32List(28 * 28);
  for (int i = 0; i < 784; i++) {
    int x = i % 28;
    int y = i ~/ 28;
    int pixel = image.getPixel(x, y);
    // Calculate normalized luminance.
    input[i] = img.getLuminance(pixel) / 255.0;
  }

  return input.buffer.asUint8List();
}
