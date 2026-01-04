import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class RefreshIndicatorWidget extends StatelessWidget {
  final Function() onRefresh;
  final Widget child;

  const RefreshIndicatorWidget({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.red,
      child: child,
      onRefresh: () async {
        onRefresh.call();
      },
    );
  }
}
