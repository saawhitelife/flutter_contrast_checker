part of 'contrast_checker_overlay.dart';

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
