import 'package:pokedex/features/pokemons/data/models/enum/type_of_pokemon.dart';
import 'package:pokedex/features/pokemons/data/models/pokemon.dart';

final Pokemon bulbasaur = Pokemon(
  id: 1,
  name: 'Bulbasaur',
  type: [TypeOfPokemon.grass],
  height: "1",
  avgSpawns: 1,
  candy: "Candy",
  egg: "Egg",
  img: "link",
  number: "1",
  spawnChance: 1,
  spawnTime: "1:00",
  weaknesses: [TypeOfPokemon.fire],
  weight: "3",
);

final Pokemon charmander = Pokemon(
  id: 4,
  name: 'Charmander',
  type: [TypeOfPokemon.fire],
  height: "1",
  avgSpawns: 1,
  candy: "Candy",
  egg: "Egg",
  img: "link",
  number: "4",
  spawnChance: 1,
  spawnTime: "1:00",
  weaknesses: [TypeOfPokemon.water],
  weight: "3",
);

final Pokemon squirtle = Pokemon(
  id: 7,
  name: 'Squirtle',
  type: [TypeOfPokemon.water],
  height: "1",
  avgSpawns: 1,
  candy: "Candy",
  egg: "Egg",
  img: "link",
  number: "7",
  spawnChance: 1,
  spawnTime: "1:00",
  weaknesses: [TypeOfPokemon.fire],
  weight: "3",
);

final allPokemons = <Pokemon>[
  charmander, // id 4
  squirtle, // id 7
  bulbasaur, // id 1
];
