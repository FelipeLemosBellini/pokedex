import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex/features/pokemons/presentation/bloc/pokemon_bloc.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  late PokemonBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = Modular.get<PokemonBloc>();
    bloc.add(LoadPokemonsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("start", style: TextStyle(color: Colors.black)),
      ),
      body: BlocBuilder(
        bloc: bloc,
        builder: <PokemonBloc, PokemonState>(context, state) {
          if (state is PokemonLoaded)
            return ListView.builder(
              itemCount: state.pokemons.length,
              itemBuilder: (_, index) {
                return Text(state.pokemons[index].name);
              },
            );
          else if (state is PokemonLoading)
            return Center(child: Text("Error"));
          else if (state is PokemonError)
            return Center(child: Text("Error"));
          else
            return SizedBox.shrink();
        },
      ),
    );
  }
}
