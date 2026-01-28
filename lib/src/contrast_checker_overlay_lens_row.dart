part of 'contrast_checker_overlay.dart';

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
        _ColorLensButton(label: 'Foreground', color: foreground, onPressed: onPickForeground),
        const SizedBox(width: 12),
        _ColorLensButton(label: 'Background', color: background, onPressed: onPickBackground),
      ],
    );
  }
}
