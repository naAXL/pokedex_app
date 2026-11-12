import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pokemon_list_bloc.dart';
import '../utils.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onScroll() {
    final bloc = context.read<PokemonListBloc>();
    if (bloc.state.error.isNotEmpty) return;

    final pos = scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      bloc.add(const LoadMorePokemons());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pokedex'),
      ),
      body: BlocConsumer<PokemonListBloc, PokemonListState>(
        listenWhen: (prev, curr) =>
            curr.error.isNotEmpty &&
            prev.error != curr.error &&
            curr.pokemons.isNotEmpty,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        },
        builder: (context, state) {
          if (state.pokemons.isEmpty) {
            if (state.status == ListStatus.failure) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.error),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PokemonListBloc>().add(const LoadPokemons());
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              final bloc = context.read<PokemonListBloc>();
              bloc.add(const RefreshPokemons());
              await bloc.stream.firstWhere((s) => s.status != ListStatus.loading);
            },
            child: ListView.builder(
              controller: scrollController,
              itemCount: state.pokemons.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= state.pokemons.length) {
                  if (state.loadingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return TextButton(
                    onPressed: () {
                      context.read<PokemonListBloc>().add(const LoadMorePokemons());
                    },
                    child: const Text('Load more'),
                  );
                }

                final pokemon = state.pokemons[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: Image.network(
                      pokemon.spriteUrl,
                      width: 56,
                      height: 56,
                      errorBuilder: (context, error, stack) =>
                          const Icon(Icons.catching_pokemon, size: 40),
                    ),
                    title: Text(niceName(pokemon.name)),
                    subtitle: Text('#${pokemon.id}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(pokemon: pokemon),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
