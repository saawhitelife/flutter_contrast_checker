part of 'contrast_checker_overlay.dart';

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
