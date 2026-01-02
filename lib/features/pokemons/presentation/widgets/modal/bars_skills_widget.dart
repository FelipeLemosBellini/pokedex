import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class BarsSkillsWidget extends StatefulWidget {
  const BarsSkillsWidget({super.key});

  @override
  State<BarsSkillsWidget> createState() => _BarsSkillsWidgetState();
}

class _BarsSkillsWidgetState extends State<BarsSkillsWidget> {
  final List<String> labels = [
    "Hp",
    "Attack",
    "Defense",
    "Sp.Atk.",
    "Sp.Def.",
    "Speed",
    "Total",
  ];

  List<int> values = [];

  void generateValues() {
    int countTotal = 0;
    for (int i = 0; i <= 6; i++) {
      values.add(Random().nextInt(100));
      countTotal += values[i];
    }

    values.last = countTotal;
  }

  @override
  void initState() {
    super.initState();
    generateValues();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, right: 16, left: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 32, bottom: 24),
              child: Text(
                "Estatistica base",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  letterSpacing: 0.32,
                  color: AppColors.textHighlight,
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: labels.length,
            itemBuilder: (context, index) {
              Color bar =
                  labels.length - 1 == index
                      ? AppColors.successGreenInverted
                      : AppColors.greenInverted;
              return Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "${labels[index]}:",
                          style: TextStyle(
                            color: AppColors.textHighlight.withOpacity(0.6),
                            fontSize: 14,
                            height: 1.4,
                            letterSpacing: 0.28,
                          ),
                        ),
                        Text(
                          " ${values[index]}",
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 14,
                            height: 1.4,
                            letterSpacing: 0.28,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: values[index] / 100,
                      minHeight: 8,
                      color: bar,
                      backgroundColor: AppColors.neutralLow,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
