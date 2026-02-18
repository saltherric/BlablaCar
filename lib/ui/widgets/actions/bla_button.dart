import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class BlaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final IconData? icon;

  const BlaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isPrimary ? BlaColors.primary : BlaColors.white;

    final textColor = isPrimary ? BlaColors.white : BlaColors.primary;

    final borderSide = isPrimary
        ? BorderSide.none
        : BorderSide(color: BlaColors.primary);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(BlaSpacings.radius),
            side: borderSide,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon, 
                color: textColor
              ),
              SizedBox(width: BlaSpacings.s),
            ],
            Text(
              label,
              style: BlaTextStyles.button.copyWith(
                color: textColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
