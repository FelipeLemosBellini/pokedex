import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/core/assets/app_assets.dart';
import 'package:pokedex/core/theme/app_colors.dart';
import 'package:pokedex/features/pokemons/data/models/enum/type_of_pokemon.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/filter/filter_selectable_widget.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/filter/option_filter_drop_down_list.dart';

class ExpandedFilterWidget extends StatelessWidget {
  final Function() onTapAlphabetical;
  final Function() onTapNumeric;
  final Function() clearFilter;
  final bool alphabeticalSelected;
  final bool numericSelected;
  final Function(TypeOfPokemon) filterByTypeOfPokemon;

  const ExpandedFilterWidget({
    super.key,
    required this.onTapAlphabetical,
    required this.onTapNumeric,
    required this.clearFilter,
    required this.alphabeticalSelected,
    required this.numericSelected,
    required this.filterByTypeOfPokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 56,
          padding: EdgeInsets.only(top: 16, left: 16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(AppAssets.settingsFilter),
              SizedBox(width: 8),
              Text(
                "Filtros avançados",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.5,
                  letterSpacing: 0.32,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.textHighlight.withOpacity(0.15),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 72),
            children: [
              GestureDetector(
                onTap: clearFilter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.red),
                  ),
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(
                    "Limpar",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AppColors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilterSelectableWidget(
                    onTap: onTapAlphabetical,
                    isSelected: alphabeticalSelected,
                    label: "alfabética (A-Z)",
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: FilterSelectableWidget(
                      onTap: onTapNumeric,
                      isSelected: numericSelected,
                      label: "código (crescente)",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              OptionFilterDropDownList(
                filterByTypeOfPokemon: filterByTypeOfPokemon,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
