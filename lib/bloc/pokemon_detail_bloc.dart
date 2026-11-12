import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/pokemon_detail.dart';
import '../services/pokemon_api.dart';

part 'pokemon_detail_event.dart';
part 'pokemon_detail_state.dart';

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final PokemonApi api;

  PokemonDetailBloc(this.api) : super(const PokemonDetailState()) {
    on<LoadPokemonDetail>(_onLoad);
  }

  Future<void> _onLoad(
    LoadPokemonDetail event,
    Emitter<PokemonDetailState> emit,
  ) async {
    emit(const PokemonDetailState(status: DetailStatus.loading));

    try {
      final detail = await api.getPokemonDetail(event.id);
      emit(PokemonDetailState(status: DetailStatus.success, detail: detail));
    } catch (e) {
      emit(const PokemonDetailState(
        status: DetailStatus.failure,
        error: 'Could not load details',
      ));
    }
  }
}
