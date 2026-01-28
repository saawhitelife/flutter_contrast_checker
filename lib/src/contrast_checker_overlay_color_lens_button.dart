part of 'contrast_checker_overlay.dart';

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
