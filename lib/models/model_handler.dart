import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ModelHandler {
  late Interpreter _interpreter;
  final double _confidenceThreshold = 0.8;

  Future<void> initialize() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/nepali_char.tflite');
    } catch (e) {
      throw Exception('Failed to load model: $e');
    }
  }

  String predict(Uint8List preprocessedImage) {
    final input = preprocessedImage.buffer.asFloat32List();
    final output = List<double>.filled(46, 0).reshape([1, 46]); // 46 classes

    _interpreter.run(input, output);

    final maxIndex = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));

    if (output[0][maxIndex] < _confidenceThreshold) {
      return 'Unknown';
    }

    return _getCharacterLabel(maxIndex);
  }

  String _getCharacterLabel(int index) {
    const labels = [
      'क', 'ख', 'ग', 'घ', 'ङ', 'च', 'छ', 'ज', 'झ', 'ञ',
      'ट', 'ठ', 'ड', 'ढ', 'ण', 'त', 'थ', 'द', 'ध', 'न',
      'प', 'फ', 'ब', 'भ', 'म', 'य', 'र', 'ल', 'व', 'श',
      'ष', 'स', 'ह', 'क्ष', 'त्र', 'ज्ञ', 'अ', 'आ', 'इ',
      'ई', 'उ', 'ऊ', 'ऋ', 'ए', 'ऐ', 'ओ', 'औ'
    ];
    return labels[index];
  }
}