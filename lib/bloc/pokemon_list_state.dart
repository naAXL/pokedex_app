part of 'pokemon_list_bloc.dart';

enum ListStatus { initial, loading, success, failure }

class PokemonListState extends Equatable {
  final ListStatus status;
  final List<Pokemon> pokemons;
  final bool hasReachedMax;
  final bool loadingMore;
  final String error;

  const PokemonListState({
    this.status = ListStatus.initial,
    this.pokemons = const [],
    this.hasReachedMax = false,
    this.loadingMore = false,
    this.error = '',
  });

  PokemonListState copyWith({
    ListStatus? status,
    List<Pokemon>? pokemons,
    bool? hasReachedMax,
    bool? loadingMore,
    String? error,
  }) {
    return PokemonListState(
      status: status ?? this.status,
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      loadingMore: loadingMore ?? this.loadingMore,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [status, pokemons, hasReachedMax, loadingMore, error];
}
