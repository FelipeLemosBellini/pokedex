import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/core/assets/app_assets.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class TextSkillWidget extends StatelessWidget {
  final String skill;

  const TextSkillWidget({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AppAssets.fire, width: 24, height: 24),
        SizedBox(width: 4),
        Text(skill, style: TextStyle(color: AppColors.orange)),
      ],
    );
  }
}
