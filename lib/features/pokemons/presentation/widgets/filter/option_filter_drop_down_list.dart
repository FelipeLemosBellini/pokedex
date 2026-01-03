import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';
import 'package:pokedex/features/pokemons/data/models/enum/type_of_pokemon.dart';

class OptionFilterDropDownList extends StatefulWidget {
  final Function(TypeOfPokemon) filterByTypeOfPokemon;

  const OptionFilterDropDownList({
    super.key,
    required this.filterByTypeOfPokemon,
  });

  @override
  State<OptionFilterDropDownList> createState() =>
      _OptionFilterDropDownListState();
}

class _OptionFilterDropDownListState extends State<OptionFilterDropDownList> {
  TypeOfPokemon? selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tipo"),
        SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textHighlight.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          alignment: Alignment.center,
          child: DropdownButton<TypeOfPokemon>(
            hint: const Text('Selecione uma opção'),
            isExpanded: true,
            value: selected,
            underline: SizedBox.shrink(),
            icon: Icon(Icons.keyboard_arrow_down),
            items:
                TypeOfPokemon.values.map((TypeOfPokemon item) {
                  return DropdownMenuItem<TypeOfPokemon>(
                    value: item,
                    child: Text(
                      item.namePtBr(),
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        letterSpacing: 0.32,
                        color: AppColors.textHighlight.withOpacity(0.6),
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (TypeOfPokemon? newValue) {
              if (newValue != null) {
                widget.filterByTypeOfPokemon(newValue);
                setState(() {
                  selected = newValue;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
