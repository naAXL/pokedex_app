part of 'pokemon_detail_bloc.dart';

abstract class PokemonDetailEvent extends Equatable {
  const PokemonDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadPokemonDetail extends PokemonDetailEvent {
  final int id;

  const LoadPokemonDetail(this.id);

  @override
  List<Object?> get props => [id];
}
