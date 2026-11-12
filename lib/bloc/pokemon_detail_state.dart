part of 'pokemon_detail_bloc.dart';

enum DetailStatus { loading, success, failure }

class PokemonDetailState extends Equatable {
  final DetailStatus status;
  final PokemonDetail? detail;
  final String error;

  const PokemonDetailState({
    this.status = DetailStatus.loading,
    this.detail,
    this.error = '',
  });

  @override
  List<Object?> get props => [status, detail, error];
}
