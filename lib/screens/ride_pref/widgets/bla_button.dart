import 'package:flutter/material.dart';

class BlaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final IconData? icon;
  final bool isEnabled;

  const BlaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isPrimary ? Colors.blue : Colors.white;

    final textColor = isPrimary ? Colors.white : Colors.blue;

    final border = isPrimary ? null : BorderSide(color: Colors.blue, width: 1);

    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: border,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle( color: textColor),
          ),
        ],
      ),
    );
  }
}
