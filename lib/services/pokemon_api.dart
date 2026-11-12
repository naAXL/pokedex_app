import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';

class PokemonApi {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> getPokemons(int offset, int limit) async {
    final url = Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset');
    final response = await http.get(url).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('server said ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List;
    return results.map((item) => Pokemon.fromJson(item)).toList();
  }

  Future<PokemonDetail> getPokemonDetail(int id) async {
    final url = Uri.parse('$baseUrl/pokemon/$id');
    final response = await http.get(url).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('server said ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return PokemonDetail.fromJson(data);
  }
}
