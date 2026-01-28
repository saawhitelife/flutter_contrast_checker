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

double wcagContrastRatio(Color a, Color b) {
  final double l1 = _relativeLuminance(a);
  final double l2 = _relativeLuminance(b);
  final double lighter = math.max(l1, l2);
  final double darker = math.min(l1, l2);
  return (lighter + _kContrastOffset) / (darker + _kContrastOffset);
}

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

String colorToHex(Color color) {
  final int r = _channelToInt(color.r);
  final int g = _channelToInt(color.g);
  final int b = _channelToInt(color.b);
  return '#'
          '${r.toRadixString(_kHexRadix).padLeft(_kHexPadLength, '0')}'
          '${g.toRadixString(_kHexRadix).padLeft(_kHexPadLength, '0')}'
          '${b.toRadixString(_kHexRadix).padLeft(_kHexPadLength, '0')}'
      .toUpperCase();
}

double _relativeLuminance(Color color) {
  final double r = _linearize(_channelToUnit(color.r));
  final double g = _linearize(_channelToUnit(color.g));
  final double b = _linearize(_channelToUnit(color.b));
  return _kLuminanceRed * r + _kLuminanceGreen * g + _kLuminanceBlue * b;
}

double _linearize(double channel) {
  return switch (channel) {
    final double channel when channel <= _kLinearizeThreshold => channel / _kLinearizeDivisor,
    _ => math.pow((channel + _kLinearizeOffset) / _kLinearizeScale, _kLinearizeGamma).toDouble(),
  };
}

double _channelToUnit(double channel) {
  return switch (channel) {
    final double channel when channel <= 1.0 => channel,
    _ => channel / _kRgbChannelMax,
  };
}

int _channelToInt(double channel) {
  return switch (channel) {
    final double channel when channel <= 1.0 => (channel * _kRgbChannelMax).round(),
    _ => channel.round(),
  };
}
