import 'package:equatable/equatable.dart';

class PokemonDetail extends Equatable {
  final int id;
  final String name;
  final double height;
  final double weight;
  final List<String> types;
  final List<String> abilities;
  final Map<String, int> stats;

  const PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.stats,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final types = (json['types'] as List)
        .map((t) => t['type']['name'] as String)
        .toList();

    final abilities = (json['abilities'] as List)
        .map((a) => a['ability']['name'] as String)
        .toList();

    final stats = <String, int>{};
    for (final s in json['stats'] as List) {
      stats[s['stat']['name'] as String] = s['base_stat'] as int;
    }

    return PokemonDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      height: (json['height'] as int) / 10,
      weight: (json['weight'] as int) / 10,
      types: types,
      abilities: abilities,
      stats: stats,
    );
  }

  @override
  List<Object?> get props => [id, name, height, weight, types, abilities, stats];
}
