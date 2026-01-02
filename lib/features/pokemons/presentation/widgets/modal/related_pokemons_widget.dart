import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/box_pokemon_widget.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/modal/pokemon_details_modal.dart';
import 'dart:math' as math;

class RelatedPokemonsWidget extends StatelessWidget {
  final List<Pokemon> related;

  const RelatedPokemonsWidget({super.key, required this.related});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 24),
          child: Text(
            "Relacionados",
            style: TextStyle(fontSize: 16, height: 1.5, letterSpacing: 0.32),
          ),
        ),
        SizedBox(
          height: 182,
          child: ListView.builder(
            itemCount: related.length,
            controller: PageController(viewportFraction: 0.9),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 16),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 48) / 2,
                  child: BoxPokemonWidget(
                    pokemon: related[index],
                    onTap: (Pokemon pokemon) {
                      Modular.to.pop();
                      PokemonDetailsModal.open(
                        context: context,
                        pokemon: pokemon,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        // SizedBox(
        //   height: 182,
        //   child: PageView.builder(
        //     itemCount: related.length,
        //     controller: PageController(viewportFraction: 0.45),
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (context, index) {
        //       return Padding(
        //         padding: const EdgeInsets.only(right: 16),
        //         child: BoxPokemonWidget(
        //           pokemon: related[index],
        //           onTap: (Pokemon pokemon) {
        //             Modular.to.pop();
        //             PokemonDetailsModal.open(
        //               context: context,
        //               pokemon: pokemon,
        //             );
        //           },
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
