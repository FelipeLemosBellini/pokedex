import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemons/data/models/enum/type_of_pokemon.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/modal/pill_skill_widget.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/modal/text_skill_widget.dart';

class PokemonSkillsWidget extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonSkillsWidget({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: [
            ...pokemon.type.map(
              (TypeOfPokemon value) => PillSkillWidget(weaknesses: value),
            ),
          ],
        ),
        SizedBox(height: 32),
        Wrap(
          spacing: 24,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: [
            TextSkillWidget(skill: "Fire spin"),
            TextSkillWidget(skill: "Overheat"),
            TextSkillWidget(skill: "Fire blast"),
          ],
        ),
      ],
    );
  }
}
