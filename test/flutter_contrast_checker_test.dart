import 'package:flutter/material.dart';
import 'package:flutter_contrast_checker/flutter_contrast_checker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('wcag contrast ratio matches black/white baseline', () {
    final double ratio = wcagContrastRatio(Colors.black, Colors.white);
    expect(ratio, closeTo(21.0, 0.01));
  });

  test('wcag contrast ratio is symmetric and 1.0 for identical colors', () {
    final double same = wcagContrastRatio(const Color(0xFF123456), const Color(0xFF123456));
    expect(same, closeTo(1.0, 0.0001));

    final double ab = wcagContrastRatio(const Color(0xFF112233), const Color(0xFFCCDDEE));
    final double ba = wcagContrastRatio(const Color(0xFFCCDDEE), const Color(0xFF112233));
    expect(ab, closeTo(ba, 0.0001));
  });

  test('wcag contrast ratio for mid-gray on white is around 4.48', () {
    final double ratio = wcagContrastRatio(const Color(0xFF777777), Colors.white);
    expect(ratio, closeTo(4.48, 0.05));
  });

  test('wcag contrast result flags AA/AAA correctly', () {
    final ContrastResult result = wcagContrastResult(const Color(0xFF5A5A5A), Colors.white);
    expect(result.aaNormal, isTrue);
    expect(result.aaaNormal, isFalse);
  });

  test('wcag contrast result thresholds match ratio', () {
    final ContrastResult result = wcagContrastResult(const Color(0xFF5A5A5A), Colors.white);
    expect(result.aaNormal, result.ratio >= 4.5);
    expect(result.aaaNormal, result.ratio >= 7.0);
    expect(result.aaLarge, result.ratio >= 3.0);
    expect(result.aaaLarge, result.ratio >= 4.5);
  });

  test('colorToHex formats as uppercase RGB hex', () {
    expect(colorToHex(const Color(0xFF12AB34)), '#12AB34');
    expect(colorToHex(const Color(0xFF00ffcc)), '#00FFCC');
  });
}
