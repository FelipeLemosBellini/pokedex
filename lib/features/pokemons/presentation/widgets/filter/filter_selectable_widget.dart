import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class FilterSelectableWidget extends StatelessWidget {
  final bool isSelected;
  final Function() onTap;
  final String label;

  const FilterSelectableWidget({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.label,
  });

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: isSelected ? Colors.black : Colors.white,
      border:
          isSelected
              ? null
              : Border.all(
                color: AppColors.textHighlight.withOpacity(0.5),
                width: 1,
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        decoration: boxDecoration(),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: isSelected,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.rotate(
                    angle: pi / 4,
                    child: Icon(Icons.add_circle, color: Colors.white),
                  ),
                  SizedBox(width: 4),
                ],
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
