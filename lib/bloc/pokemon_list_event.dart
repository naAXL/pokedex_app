part of 'pokemon_list_bloc.dart';

abstract class PokemonListEvent extends Equatable {
  const PokemonListEvent();

  @override
  List<Object?> get props => [];
}

class LoadPokemons extends PokemonListEvent {
  const LoadPokemons();
}

class LoadMorePokemons extends PokemonListEvent {
  const LoadMorePokemons();
}

class RefreshPokemons extends PokemonListEvent {
  const RefreshPokemons();
}
