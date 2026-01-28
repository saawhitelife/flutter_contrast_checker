import 'dart:math' as math;
import 'dart:ui';

import 'package:eye_dropper/eye_dropper.dart';
import 'package:flutter/material.dart';

import 'contrast_checker_theme.dart';
import 'contrast_utils.dart';

class ContrastCheckerOverlay extends StatefulWidget {
  const ContrastCheckerOverlay({
    super.key,
    required this.child,
    this.enabled = true,
    this.initialForeground,
    this.initialBackground,
  });

  final Widget child;
  final bool enabled;
  final Color? initialForeground;
  final Color? initialBackground;

  @override
  State<ContrastCheckerOverlay> createState() => _ContrastCheckerOverlayState();
}

class _ContrastCheckerOverlayState extends State<ContrastCheckerOverlay> {
  static const double _buttonSize = 56.0;
  static const double _overlayPadding = 12.0;

  late Color _foreground = widget.initialForeground ?? context.contrastCheckerTheme.body;
  late Color _background = widget.initialBackground ?? context.contrastCheckerTheme.surface;

  Offset _buttonOffset = const Offset(20, 120);
  Offset? _dragOrigin;
  Offset? _buttonOffsetAtDragStart;

  bool _showPickers = false;

  void _openPickers() {
    setState(() => _showPickers = true);
  }

  void _closePickers() {
    setState(() => _showPickers = false);
  }

  void _startDrag(LongPressStartDetails details) {
    _dragOrigin = details.globalPosition;
    _buttonOffsetAtDragStart = _buttonOffset;
  }

  void _updateDrag(LongPressMoveUpdateDetails details, Size size) {
    if (_dragOrigin == null || _buttonOffsetAtDragStart == null) {
      return;
    }
    final Offset delta = details.globalPosition - _dragOrigin!;
    final Offset next = _buttonOffsetAtDragStart! + delta;
    _setButtonOffset(next, size);
  }

  void _setButtonOffset(Offset offset, Size size) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    final double minX = _overlayPadding + padding.left;
    final double minY = _overlayPadding + padding.top;
    final double maxX = math.max(minX, size.width - _buttonSize - _overlayPadding - padding.right);
    final double maxY = math.max(minY, size.height - _buttonSize - _overlayPadding - padding.bottom);
    final double clampedX = offset.dx.clamp(minX, maxX);
    final double clampedY = offset.dy.clamp(minY, maxY);
    setState(() => _buttonOffset = Offset(clampedX, clampedY));
  }

  Future<void> _pickColor(BuildContext eyeDropperContext, bool isForeground) async {
    EyeDropper.enableEyeDropper(eyeDropperContext, (Color? color) {
      if (!mounted || color == null) {
        return;
      }
      setState(() {
        if (isForeground) {
          _foreground = color;
        } else {
          _background = color;
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ContrastCheckerTheme theme = context.contrastCheckerTheme;
    _foreground = widget.initialForeground ?? theme.body;
    _background = widget.initialBackground ?? theme.surface;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return EyeDropper(
      child: Builder(
        builder: (BuildContext eyeDropperContext) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Size size = constraints.biggest;
              return Stack(
                children: <Widget>[
                  widget.child,
                  if (!_showPickers)
                    Positioned(
                      left: _buttonOffset.dx,
                      top: _buttonOffset.dy,
                      child: _FloatingContrastButton(
                        size: _buttonSize,
                        onTap: _openPickers,
                        onLongPressStart: _startDrag,
                        onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) => _updateDrag(details, size),
                      ),
                    ),
                  if (_showPickers)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SafeArea(
                        minimum: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _LensRow(
                              foreground: _foreground,
                              background: _background,
                              onPickForeground: () => _pickColor(eyeDropperContext, true),
                              onPickBackground: () => _pickColor(eyeDropperContext, false),
                            ),
                            const SizedBox(height: 14),
                            _ContrastCard(foreground: _foreground, background: _background, onClose: _closePickers),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ContrastCheckerOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialForeground != oldWidget.initialForeground ||
        widget.initialBackground != oldWidget.initialBackground) {
      final ContrastCheckerTheme theme = context.contrastCheckerTheme;
      _foreground = widget.initialForeground ?? theme.body;
      _background = widget.initialBackground ?? theme.surface;
    }
  }
}

class _FloatingContrastButton extends StatelessWidget {
  const _FloatingContrastButton({
    required this.size,
    required this.onTap,
    required this.onLongPressStart,
    required this.onLongPressMoveUpdate,
  });

  final double size;
  final VoidCallback onTap;
  final GestureLongPressStartCallback onLongPressStart;
  final GestureLongPressMoveUpdateCallback onLongPressMoveUpdate;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final ContrastCheckerTheme theme = context.contrastCheckerTheme;
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: onLongPressStart,
      onLongPressMoveUpdate: onLongPressMoveUpdate,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: <Color>[scheme.primary, scheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(color: theme.shadow.withAlpha(51), blurRadius: 18, offset: const Offset(0, 8)),
            ],
          ),
          child: Icon(Icons.center_focus_strong, color: theme.surface, size: 26),
        ),
      ),
    );
  }
}

class _LensRow extends StatelessWidget {
  const _LensRow({
    required this.foreground,
    required this.background,
    required this.onPickForeground,
    required this.onPickBackground,
  });

  final Color foreground;
  final Color background;
  final VoidCallback onPickForeground;
  final VoidCallback onPickBackground;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _ColorLensButton(label: 'Text', color: foreground, onPressed: onPickForeground),
        const SizedBox(width: 12),
        _ColorLensButton(label: 'Background', color: background, onPressed: onPickBackground),
      ],
    );
  }
}

class _ColorLensButton extends StatelessWidget {
  const _ColorLensButton({required this.label, required this.color, required this.onPressed});

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final ContrastCheckerTheme theme = context.contrastCheckerTheme;
    final BorderRadius borderRadius = BorderRadius.circular(24);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: theme.lensBackground,
        border: Border.all(color: theme.lensBorder),
        boxShadow: <BoxShadow>[
          BoxShadow(color: theme.shadow.withAlpha(26), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Material(
        borderRadius: borderRadius,
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(color: theme.surface, width: 2),
                    boxShadow: <BoxShadow>[
                      BoxShadow(color: theme.shadow.withAlpha(51), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(color: theme.body, fontWeight: FontWeight.w600, letterSpacing: 0.2),
                ),
                const SizedBox(width: 6),
                Icon(Icons.colorize, size: 16, color: scheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContrastCard extends StatelessWidget {
  const _ContrastCard({required this.foreground, required this.background, required this.onClose});

  final Color foreground;
  final Color background;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final ContrastCheckerTheme theme = context.contrastCheckerTheme;
    final ContrastResult result = wcagContrastResult(foreground, background);
    final String ratioText = result.ratio.toStringAsFixed(2);

    return Material(
      type: MaterialType.transparency,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: <Color>[theme.cardGradientStart, theme.cardGradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: theme.border),
              boxShadow: <BoxShadow>[
                BoxShadow(color: theme.shadow.withAlpha(38), blurRadius: 20, offset: const Offset(0, 12)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Contrast Check',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: theme.title),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close, size: 18),
                      splashRadius: 18,
                      color: theme.muted,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '$ratioText:1',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: theme.title),
                ),
                const SizedBox(height: 4),
                Text('WCAG 2.1 contrast ratio', style: TextStyle(color: theme.muted, fontSize: 13)),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    _ColorChip(label: 'Text', color: foreground),
                    const SizedBox(width: 10),
                    _ColorChip(label: 'Background', color: background),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _ContrastBadge(label: 'AA (normal)', pass: result.aaNormal),
                    _ContrastBadge(label: 'AAA (normal)', pass: result.aaaNormal),
                    _ContrastBadge(label: 'AA (large)', pass: result.aaLarge),
                    _ContrastBadge(label: 'AAA (large)', pass: result.aaaLarge),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContrastBadge extends StatelessWidget {
  const _ContrastBadge({required this.label, required this.pass});

  final String label;
  final bool pass;

  @override
  Widget build(BuildContext context) {
    final ContrastCheckerTheme theme = context.contrastCheckerTheme;
    final Color background = switch (pass) {
      true => theme.successBg,
      false => theme.errorBg,
    };
    final Color text = switch (pass) {
      true => theme.successText,
      false => theme.errorText,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(999)),
      child: Text(
        label,
        style: TextStyle(color: text, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ContrastCheckerTheme theme = context.contrastCheckerTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.border),
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: theme.surface, width: 2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: TextStyle(fontSize: 11, color: theme.muted, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    colorToHex(color),
                    style: TextStyle(fontSize: 13, color: theme.body, fontWeight: FontWeight.w700, letterSpacing: 0.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
