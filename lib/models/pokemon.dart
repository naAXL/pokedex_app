import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  final int id;
  final String name;

  const Pokemon({required this.id, required this.name});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final parts = url.split('/');
    final id = int.parse(parts[parts.length - 2]);
    return Pokemon(id: id, name: json['name'] as String);
  }

  String get spriteUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  String get artworkUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  @override
  List<Object?> get props => [id, name];
}
