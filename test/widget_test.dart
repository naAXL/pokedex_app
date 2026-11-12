import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/bloc/pokemon_list_bloc.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/services/pokemon_api.dart';

class FakeApi extends PokemonApi {
  @override
  Future<List<Pokemon>> getPokemons(int offset, int limit) async {
    return [
      const Pokemon(id: 1, name: 'bulbasaur'),
      const Pokemon(id: 2, name: 'ivysaur'),
    ];
  }
}

void main() {
  test('pokemon gets its id from the url', () {
    final p = Pokemon.fromJson({
      'name': 'pikachu',
      'url': 'https://pokeapi.co/api/v2/pokemon/25/',
    });
    expect(p.id, 25);
    expect(p.name, 'pikachu');
  });

  test('list bloc loads pokemons', () async {
    final bloc = PokemonListBloc(FakeApi());
    bloc.add(const LoadPokemons());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<PokemonListState>()
            .having((s) => s.status, 'status', ListStatus.loading),
        isA<PokemonListState>()
            .having((s) => s.status, 'status', ListStatus.success),
      ]),
    );

    expect(bloc.state.pokemons.length, 2);
    await bloc.close();
  });
}
