import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';

class BoxPokemonWidget extends StatelessWidget {
  final Pokemon pokemon;

  const BoxPokemonWidget({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLowest.withOpacity(0.15)),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Align(
              alignment: Alignment.center,
              child: Image.network(pokemon.img, height: 86),
            ),
          ),
          SizedBox(height: 8),
          Text(
            pokemon.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: 1.333,
              letterSpacing: 0.36,
              color: AppColors.textHighlight,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "#${pokemon.number}",
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              letterSpacing: 0.28,
              color: AppColors.textHighlight.withOpacity(0.35),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.add_circle, size: 16),
          ),
        ],
      ),
    );
  }
}
