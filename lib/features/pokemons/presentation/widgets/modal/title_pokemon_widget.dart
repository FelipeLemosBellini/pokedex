import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex/core/theme/app_colors.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'dart:math' as math;

class TitlePokemonWidget extends StatelessWidget {
  final Pokemon pokemon;

  const TitlePokemonWidget({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.circular(24),
          ),
          width: MediaQuery.sizeOf(context).width,
          height: 173,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pokemon.name,
                        style: TextStyle(
                          fontSize: 24,
                          height: 1.333,
                          letterSpacing: 0.48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "#${pokemon.number}",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          letterSpacing: 0.32,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Modular.to.pop();
                    },
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: Icon(
                        Icons.add_circle,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(
            top: 48,
            left: (width - (width - 68) * 0.8) / 2,
          ),
          width: (width - 68) * 0.8,
          child: Image.network(pokemon.img, fit: BoxFit.fill),
        ),
      ],
    );
  }
}
