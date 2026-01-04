import 'package:pokedex/features/pokemons/data/models/enum/type_of_pokemon.dart';
import 'package:pokedex/features/pokemons/data/models/evolution.dart';

class Pokemon {
  final int id;
  final String number;
  final String name;
  final String img;
  final List<TypeOfPokemon> type;
  final String height;
  final String weight;
  final String candy;
  final int? candyCount;
  final String egg;
  final double spawnChance;
  final double avgSpawns;
  final String spawnTime;
  final List<double>? multipliers;
  final List<TypeOfPokemon> weaknesses;
  final List<Evolution>? nextEvolution;
  final List<Evolution>? prevEvolution;

  Pokemon({
    required this.id,
    required this.number,
    required this.name,
    required this.img,
    required this.type,
    required this.height,
    required this.weight,
    required this.candy,
    this.candyCount,
    required this.egg,
    required this.spawnChance,
    required this.avgSpawns,
    required this.spawnTime,
    this.multipliers,
    required this.weaknesses,
    this.nextEvolution,
    this.prevEvolution,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      number: json['num'],
      name: json['name'],
      img: json['img'],
      type: List.from(json['type'].map((x) => TypeOfPokemon.fromString(x))),
      height: json['height'],
      weight: json['weight'],
      candy: json['candy'],
      candyCount: json['candy_count'],
      egg: json['egg'],
      spawnChance: (json['spawn_chance'] as num).toDouble(),
      avgSpawns: (json['avg_spawns'] as num).toDouble(),
      spawnTime: json['spawn_time'],
      multipliers:
          json['multipliers'] != null
              ? List<double>.from(
                json['multipliers'].map((x) => (x as num).toDouble()),
              )
              : null,
      weaknesses: List.from(
        json['weaknesses'].map((x) => TypeOfPokemon.fromString(x)),
      ),
      nextEvolution:
          json['next_evolution'] != null
              ? List<Evolution>.from(
                json['next_evolution'].map((x) => Evolution.fromJson(x)),
              )
              : null,
      prevEvolution:
          json['prev_evolution'] != null
              ? List<Evolution>.from(
                json['prev_evolution'].map((x) => Evolution.fromJson(x)),
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num': number,
      'name': name,
      'img': img,
      'type': type.map((x) => x.name).toList(),
      'height': height,
      'weight': weight,
      'candy': candy,
      'candy_count': candyCount,
      'egg': egg,
      'spawn_chance': spawnChance,
      'avg_spawns': avgSpawns,
      'spawn_time': spawnTime,
      'multipliers': multipliers,
      'weaknesses': weaknesses.map((x) => x.name).toList(),
      'next_evolution': nextEvolution?.map((x) => x.toJson()).toList(),
      'prev_evolution': prevEvolution?.map((x) => x.toJson()).toList(),
    };
  }
}
