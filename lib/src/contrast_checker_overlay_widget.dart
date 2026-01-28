part of 'contrast_checker_overlay.dart';

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
  static const double _overlayPadding = 0.0;

  late Color _foreground;
  late Color _background;
  Offset _buttonOffset = const Offset(20, 120);
  Offset? _dragOrigin;
  Offset? _buttonOffsetAtDragStart;

  bool _showPickers = false;
  bool _useDarkTheme = false;

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
    final double minX = _overlayPadding;
    final double minY = MediaQuery.of(context).padding.top + _overlayPadding;
    final double maxX = math.max(minX, size.width - _buttonSize - _overlayPadding);
    final double maxY = math.max(minY, size.height - _buttonSize - _overlayPadding);
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

    final ThemeData baseTheme = Theme.of(context);

    final ContrastCheckerTheme lightTheme = baseTheme.extension<ContrastCheckerTheme>() ?? ContrastCheckerTheme.light;
    final ContrastCheckerTheme contrastTheme = switch (_useDarkTheme) {
      true => ContrastCheckerTheme.dark,
      _ => lightTheme,
    };

    final Map<Object, ThemeExtension<dynamic>> mergedExtensions = Map<Object, ThemeExtension<dynamic>>.from(
      baseTheme.extensions,
    );
    mergedExtensions[ContrastCheckerTheme] = contrastTheme;

    return Theme(
      data: baseTheme.copyWith(extensions: mergedExtensions.values.toList()),
      child: EyeDropper(
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
                              _ContrastCard(
                                foreground: _foreground,
                                background: _background,
                                isDark: _useDarkTheme,
                                onThemeToggle: (bool value) {
                                  setState(() => _useDarkTheme = value);
                                },
                                onClose: _closePickers,
                              ),
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
