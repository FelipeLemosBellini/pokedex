import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex/core/analytics/analytics_bridge.dart';
import 'package:pokedex/core/theme/app_colors.dart';
import 'package:pokedex/features/pokemons/domain/models/enum/type_of_pokemon.dart';
import 'package:pokedex/features/pokemons/domain/models/pokemon.dart';
import 'package:pokedex/features/pokemons/presentation/bloc/pokemon_bloc.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/app_bar/red_app_bar_pokeball.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/box_pokemon_widget.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/filter/filter_pokemon_widget.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/input_text_widget.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/modal/pokemon_details_modal.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/refresh_indicator_widget.dart';
import 'package:pokedex/features/pokemons/presentation/widgets/snack_bar/custom_snack_bar.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  late PokemonBloc bloc;

  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    bloc = Modular.get<PokemonBloc>();
    bloc.add(LoadPokemonsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: AppColors.red, toolbarHeight: 0),
      body: BlocListener<PokemonBloc, PokemonState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is PokemonMessage) {
            CustomSnackBar.openSnackBar(
              context: context,
              message: state.message,
            );
          }
        },
        child: BlocBuilder<PokemonBloc, PokemonState>(
          bloc: bloc,
          builder: (context, state) {
            if (state is PokemonLoaded) {
              return RefreshIndicatorWidget(
                onRefresh: () {
                  bloc.add(LoadPokemonsEvent(refresh: true));
                },
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    RedAppBarPokeball(),
                    SizedBox(height: 40),
                    InputTextWidget(
                      controller: searchController,
                      focusNode: focusNode,
                      clearInput: () {
                        searchController.clear();
                        bloc.add(SearchPokemonsEvent(value: ""));
                      },
                      onChanged: (String value) {
                        bloc.add(SearchPokemonsEvent(value: value));
                      },
                    ),
                    FilterPokemonWidget(
                      showExpandedFilter: state.showExpandedFilter,
                      alphabeticalSelected: state.isAlphabetical,
                      numericSelected: state.isAscending,
                      clearFilter: () {
                        bloc.add(ClearFiltersEvent());
                      },
                      onTapFilter: () {
                        bloc.add(ToggleFilterEvent());
                      },
                      onTapAlphabetical: () {
                        bloc.add(ToggleAlphabeticalFilterEvent());
                      },
                      onTapNumeric: () {
                        bloc.add(ToggleNumericFilterEvent());
                      },
                      filterByTypeOfPokemon: (TypeOfPokemon? type) {
                        bloc.add(FilterByTypeEvent(type: type));
                      },
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(16),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.pokemons.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (_, index) {
                        return BoxPokemonWidget(
                          pokemon: state.pokemons[index],
                          onTap: (Pokemon pokemon) {
                            AnalyticsBridge.logEvent(
                              name: AnalyticsLogEvents.pokemonMostSelected,
                              params: {"pokemon": pokemon.toJson()},
                            );
                            PokemonDetailsModal.open(
                              context: context,
                              pokemon: pokemon,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (state is PokemonLoading)
              return Center(
                child: CircularProgressIndicator(color: Colors.red),
              );
            else
              return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
