import 'package:flutter/material.dart';
import 'package:pokedex/features/pokemons/data/models/enum/type_of_pokemon.dart';

class PillSkillWidget extends StatelessWidget {
  final TypeOfPokemon weaknesses;

  const PillSkillWidget({super.key, required this.weaknesses});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: weaknesses.color(),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        weaknesses.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1.4,
          letterSpacing: 0.28,
        ),
      ),
    );
  }
}
