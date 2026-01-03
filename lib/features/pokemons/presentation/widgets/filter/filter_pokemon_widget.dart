import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemons/data/models/enum/type_of_pokemon.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/filter/expanded_filter_widget.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/filter/simple_filter_widget.dart';

class FilterPokemonWidget extends StatelessWidget {
  final Function() onTapFilter;
  final Function() onTapAlphabetical;
  final Function() onTapNumeric;
  final Function() clearFilter;
  final bool alphabeticalSelected;
  final bool numericSelected;
  final Function(TypeOfPokemon) filterByTypeOfPokemon;
  final bool showExpandedFilter;

  const FilterPokemonWidget({
    super.key,
    required this.onTapFilter,
    required this.onTapAlphabetical,
    required this.onTapNumeric,
    required this.clearFilter,
    required this.alphabeticalSelected,
    required this.numericSelected,
    required this.filterByTypeOfPokemon,
    required this.showExpandedFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 28, bottom: 24, right: 16),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child:
            showExpandedFilter
                ? ExpandedFilterWidget(
                  onTapAlphabetical: onTapAlphabetical,
                  onTapNumeric: onTapNumeric,
                  clearFilter: clearFilter,
                  alphabeticalSelected: alphabeticalSelected,
                  numericSelected: numericSelected,
                  filterByTypeOfPokemon: filterByTypeOfPokemon,
                )
                : SimpleFilterWidget(
                  onTapFilter: onTapFilter,
                  onTapAlphabetical: onTapAlphabetical,
                  onTapNumeric: onTapNumeric,
                  alphabeticalSelected: alphabeticalSelected,
                  numericSelected: numericSelected,
                ),
      ),
    );
  }
}
