// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';

const double _kRgbChannelMax = 255.0;
const int _kHexPadLength = 2;
const int _kHexRadix = 16;
const double _kContrastOffset = 0.05;
const double _kAaNormalThreshold = 4.5;
const double _kAaaNormalThreshold = 7.0;
const double _kAaLargeThreshold = 3.0;
const double _kAaaLargeThreshold = 4.5;
const double _kLinearizeThreshold = 0.03928;
const double _kLinearizeDivisor = 12.92;
const double _kLinearizeOffset = 0.055;
const double _kLinearizeScale = 1.055;
const double _kLinearizeGamma = 2.4;
const double _kLuminanceRed = 0.2126;
const double _kLuminanceGreen = 0.7152;
const double _kLuminanceBlue = 0.0722;

/// Aggregated WCAG contrast results for a color pair.
class ContrastResult {
  const ContrastResult({
    required this.ratio,
    required this.aaNormal,
    required this.aaaNormal,
    required this.aaLarge,
    required this.aaaLarge,
  });

  final double ratio;
  final bool aaNormal;
  final bool aaaNormal;
  final bool aaLarge;
  final bool aaaLarge;
}

/// Computes WCAG 2.x contrast ratio for two colors.
///
/// Uses relative luminance per WCAG and returns a ratio in [1, 21].
double wcagContrastRatio(Color a, Color b) {
  final double l1 = _relativeLuminance(a);
  final double l2 = _relativeLuminance(b);
  final double lighter = math.max(l1, l2);
  final double darker = math.min(l1, l2);
  return (lighter + _kContrastOffset) / (darker + _kContrastOffset);
}

/// Computes WCAG AA/AAA pass/fail results for normal and large text.
ContrastResult wcagContrastResult(Color a, Color b) {
  final double ratio = wcagContrastRatio(a, b);
  return ContrastResult(
    ratio: ratio,
    aaNormal: ratio >= _kAaNormalThreshold,
    aaaNormal: ratio >= _kAaaNormalThreshold,
    aaLarge: ratio >= _kAaLargeThreshold,
    aaaLarge: ratio >= _kAaaLargeThreshold,
  );
}

/// Formats a color as uppercase RGB hex (e.g., #12AB34).
String colorToHex(Color color) {
  final int r = _channelToInt(color.red.toDouble());
  final int g = _channelToInt(color.green.toDouble());
  final int b = _channelToInt(color.blue.toDouble());
  return '#'
          '${r.toRadixString(_kHexRadix).padLeft(_kHexPadLength, '0')}'
          '${g.toRadixString(_kHexRadix).padLeft(_kHexPadLength, '0')}'
          '${b.toRadixString(_kHexRadix).padLeft(_kHexPadLength, '0')}'
      .toUpperCase();
}

/// Relative luminance per WCAG definition.
double _relativeLuminance(Color color) {
  final double r = _linearize(_channelToUnit(color.red.toDouble()));
  final double g = _linearize(_channelToUnit(color.green.toDouble()));
  final double b = _linearize(_channelToUnit(color.blue.toDouble()));
  return _kLuminanceRed * r + _kLuminanceGreen * g + _kLuminanceBlue * b;
}

/// Converts an sRGB channel to linear light.
double _linearize(double channel) {
  return switch (channel) {
    final double channel when channel <= _kLinearizeThreshold => channel / _kLinearizeDivisor,
    _ => math.pow((channel + _kLinearizeOffset) / _kLinearizeScale, _kLinearizeGamma).toDouble(),
  };
}

/// Normalizes a channel to 0..1 if needed.
double _channelToUnit(double channel) {
  return switch (channel) {
    final double channel when channel <= 1.0 => channel,
    _ => channel / _kRgbChannelMax,
  };
}

/// Converts a channel to an 8-bit integer.
int _channelToInt(double channel) {
  return switch (channel) {
    final double channel when channel <= 1.0 => (channel * _kRgbChannelMax).round(),
    _ => channel.round(),
  };
}
