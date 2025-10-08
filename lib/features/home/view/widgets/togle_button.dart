import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:praying_app/app/helpers/colors.dart';

class CustomToggle extends StatefulWidget {
  final bool isDark;
  final bool isNawaflOn;
  final Function(bool) onChanged;

  const CustomToggle({
    Key? key,
    required this.isDark,
    required this.isNawaflOn,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomToggleState createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  @override
  Widget build(BuildContext context) {
    bool isDark = widget.isDark;
    bool isNawaflOn = widget.isNawaflOn;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: 0.8.sw,
        height: 35,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2F41) : AppColors.mainColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),

        ),
        child: Row(
          children: [
            _buildToggleButton(
              text: 'farida'.tr(),
              isSelected: !isNawaflOn,
              isDark: isDark,
              onTap: () {
                widget.onChanged(false);
              },
            ),
            _buildToggleButton(
              text: 'nawafel'.tr(),
              isSelected: isNawaflOn,
              isDark: isDark,
              onTap: () {
                widget.onChanged(true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF3D4659) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xFF2E6DE3))
                  : (isDark ? Colors.white : const Color(0xFF2C2F41)),
            ),
          ),
        ),
      ),
    );
  }
}
