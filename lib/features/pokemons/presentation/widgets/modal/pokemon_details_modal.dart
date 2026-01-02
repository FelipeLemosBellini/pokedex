import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';
import 'package:pokedex/features/pokemons/presentation/bloc/pokemon_details_cubit.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/modal/bars_skills_widget.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/modal/pokemon_skills_widget.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/modal/related_pokemons_widget.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/modal/title_pokemon_widget.dart';

class PokemonDetailsModal extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailsModal({super.key, required this.pokemon});

  static Future<void> open({
    required BuildContext context,
    required Pokemon pokemon,
  }) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PokemonDetailsModal(pokemon: pokemon);
      },
    );
  }

  @override
  State<PokemonDetailsModal> createState() => _PokemonDetailsModalState();
}

class _PokemonDetailsModalState extends State<PokemonDetailsModal> {
  late PokemonDetailsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = Modular.get<PokemonDetailsCubit>();
    cubit.getRelatedPokemons(widget.pokemon.type);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: ListView(
        children: [
          TitlePokemonWidget(pokemon: widget.pokemon),
          PokemonSkillsWidget(pokemon: widget.pokemon),
          BarsSkillsWidget(),
          BlocBuilder<PokemonDetailsCubit, PokemonDetailsState>(
            bloc: cubit,
            builder: (context, PokemonDetailsState state) {
              return RelatedPokemonsWidget(related: state.related);
            },
          ),
        ],
      ),
    );
  }
}
