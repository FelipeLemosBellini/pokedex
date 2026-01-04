import 'package:flutter/animation.dart';

enum TypeOfPokemon {
  ground,
  fire,
  rock,
  ice,
  flying,
  psychic,
  poison,
  grass,
  bug,
  electric,
  normal,
  fighting,
  water,
  steel,
  fairy,
  dark,
  dragon,
  ghost;

  Color color() {
    switch (this) {
      case ground:
        return Color(0xFF863A01);
      case fire:
        return Color(0xFFC90328);
      case rock:
        return Color(0xFF354042);
      case ice:
        return Color(0xFF306483);
      case flying:
        return Color(0xFF575757);
      case psychic:
        return Color(0xFF9342FA);
      case poison:
        return Color(0xFF3B00CB);
      case grass:
        return Color(0xFF49B900);
      case bug:
        return Color(0xFF264821);
      case electric:
        return Color(0xFF999D05);
      case normal:
        return Color(0xFF2D2D2D);
      case fighting:
        return Color(0xFFF38C1F);
      case water:
        return Color(0xFF05A9D5);
      case steel:
        return Color(0xFF3D3D3F);
      case ghost:
        return Color(0xFF696969);
      case fairy:
        return Color(0xFF3DAF4A);
      case dark:
        return Color(0xFF061415);
      case dragon:
        return Color(0xFF0536D5);
    }
  }

  String namePtBr() {
    switch (this) {
      case ground:
        return "Terroso";
      case fire:
        return "Fogo";
      case rock:
        return "Rocha";
      case ice:
        return "Gelo";
      case flying:
        return 'Voador';
      case psychic:
        return "Psíquico";
      case poison:
        return "Venenoso";
      case grass:
        return "Grama";
      case bug:
        return "Inseto";
      case electric:
        return "Elétrico";
      case normal:
        return "Comum";
      case fighting:
        return "Voador";
      case water:
        return "Agua";
      case steel:
        return "Aço";
      case ghost:
        return "Fantasma";
      case fairy:
        return "Fada";
      case dark:
        return "Sombrio";
      case dragon:
        return "Dragão";
    }
  }

  static TypeOfPokemon? fromString(String value) {
    try {
      return TypeOfPokemon.values.byName(value.toLowerCase());
    } catch (e) {
      return null;
    }
  }
}

extension WeaknessesExtension on TypeOfPokemon {}
