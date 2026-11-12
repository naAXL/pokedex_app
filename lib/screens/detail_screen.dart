import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pokemon_detail_bloc.dart';
import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';
import '../services/pokemon_api.dart';
import '../utils.dart';

class DetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const DetailScreen({super.key, required this.pokemon});

  Widget statRow(String name, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 130, child: Text(name)),
          SizedBox(width: 40, child: Text('$value')),
          Expanded(
            child: LinearProgressIndicator(value: value / 255),
          ),
        ],
      ),
    );
  }

  Widget buildDetails(PokemonDetail detail) {
    const titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: detail.types
              .map((type) => Chip(label: Text(niceName(type))))
              .toList(),
        ),
        const SizedBox(height: 12),
        Text('Height: ${detail.height} m'),
        Text('Weight: ${detail.weight} kg'),
        const SizedBox(height: 16),
        const Text('Abilities', style: titleStyle),
        const SizedBox(height: 4),
        ...detail.abilities.map((a) => Text('• ${niceName(a)}')),
        const SizedBox(height: 16),
        const Text('Base stats', style: titleStyle),
        const SizedBox(height: 4),
        ...detail.stats.entries.map((e) => statRow(niceName(e.key), e.value)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonDetailBloc(context.read<PokemonApi>())
        ..add(LoadPokemonDetail(pokemon.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(niceName(pokemon.name)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Image.network(
                pokemon.artworkUrl,
                height: 220,
                errorBuilder: (context, error, stack) =>
                    const Icon(Icons.catching_pokemon, size: 120),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '#${pokemon.id}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
              builder: (context, state) {
                if (state.status == DetailStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == DetailStatus.failure) {
                  return Column(
                    children: [
                      Text(state.error),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<PokemonDetailBloc>()
                              .add(LoadPokemonDetail(pokemon.id));
                        },
                        child: const Text('Try again'),
                      ),
                    ],
                  );
                }

                return buildDetails(state.detail!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
