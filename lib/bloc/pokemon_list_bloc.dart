import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/pokemon.dart';
import '../services/pokemon_api.dart';

part 'pokemon_list_event.dart';
part 'pokemon_list_state.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final PokemonApi api;
  final int pageSize = 20;

  PokemonListBloc(this.api) : super(const PokemonListState()) {
    on<LoadPokemons>(_loadFirstPage);
    on<RefreshPokemons>(_loadFirstPage);
    on<LoadMorePokemons>(_loadMore);
  }

  Future<void> _loadFirstPage(
    PokemonListEvent event,
    Emitter<PokemonListState> emit,
  ) async {
    emit(state.copyWith(status: ListStatus.loading, error: ''));

    try {
      final list = await api.getPokemons(0, pageSize);
      emit(PokemonListState(
        status: ListStatus.success,
        pokemons: list,
        hasReachedMax: list.length < pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: state.pokemons.isEmpty ? ListStatus.failure : ListStatus.success,
        error: 'Could not load pokemons, check your internet',
      ));
    }
  }

  Future<void> _loadMore(
    LoadMorePokemons event,
    Emitter<PokemonListState> emit,
  ) async {
    if (state.hasReachedMax || state.loadingMore) return;
    if (state.pokemons.isEmpty || state.status == ListStatus.loading) return;

    emit(state.copyWith(loadingMore: true, error: ''));

    try {
      final list = await api.getPokemons(state.pokemons.length, pageSize);
      emit(state.copyWith(
        pokemons: [...state.pokemons, ...list],
        hasReachedMax: list.length < pageSize,
        loadingMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingMore: false,
        error: 'Could not load more pokemons',
      ));
    }
  }
}
