import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/core/assets/app_assets.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/filter_selectable_widget.dart';

class FilterPokemonWidget extends StatelessWidget {
  final Function() onTapFilter;
  final Function() onTapAlphabetical;
  final Function() onTapNumeric;
  final bool alphabeticalSelected;
  final bool numericSelected;

  const FilterPokemonWidget({
    super.key,
    required this.onTapFilter,
    required this.onTapAlphabetical,
    required this.onTapNumeric,
    required this.alphabeticalSelected,
    required this.numericSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 28, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onTapFilter,
            child: Container(
              width: 48,
              height: 48,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(AppAssets.settingsFilter),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  FilterSelectableWidget(
                    onTap: onTapAlphabetical,
                    isSelected: alphabeticalSelected,
                    label: "alfabética (A-Z)",
                  ),
                  SizedBox(width: 12),
                  FilterSelectableWidget(
                    onTap: onTapNumeric,
                    isSelected: numericSelected,
                    label: "código (crescente)",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
