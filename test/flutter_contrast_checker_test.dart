import 'package:flutter/material.dart';
import 'package:flutter_contrast_checker/flutter_contrast_checker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('wcag contrast ratio matches black/white baseline', () {
    final double ratio = wcagContrastRatio(Colors.black, Colors.white);
    expect(ratio, closeTo(21.0, 0.01));
  });

  test('wcag contrast result flags AA/AAA correctly', () {
    final ContrastResult result = wcagContrastResult(const Color(0xFF1E293B), Colors.white);
    expect(result.aaNormal, isTrue);
    expect(result.aaaNormal, isFalse);
  });
}
