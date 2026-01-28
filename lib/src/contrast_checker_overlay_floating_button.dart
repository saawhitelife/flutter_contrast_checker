part of 'contrast_checker_overlay.dart';

/// Floating trigger button that opens the overlay.
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
