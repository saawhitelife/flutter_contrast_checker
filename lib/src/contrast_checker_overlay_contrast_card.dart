part of 'contrast_checker_overlay.dart';

class _ContrastCard extends StatelessWidget {
  const _ContrastCard({
    required this.foreground,
    required this.background,
    required this.isDark,
    required this.onThemeToggle,
    required this.onClose,
  });

  final Color foreground;
  final Color background;
  final bool isDark;
  final ValueChanged<bool> onThemeToggle;
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
                    Row(
                      children: <Widget>[
                        Icon(
                          switch (isDark) {
                            true => Icons.dark_mode,
                            false => Icons.light_mode,
                          },
                          size: 16,
                          color: theme.muted,
                        ),
                        Switch(
                          value: isDark,
                          onChanged: onThemeToggle,
                          activeThumbColor: Theme.of(context).colorScheme.primary,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
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
                    _ColorChip(label: 'Foreground', color: foreground),
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
