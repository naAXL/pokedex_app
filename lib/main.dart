import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/pokemon_list_bloc.dart';
import 'screens/home_screen.dart';
import 'services/pokemon_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PokemonApi(),
      child: BlocProvider(
        create: (context) =>
            PokemonListBloc(context.read<PokemonApi>())..add(const LoadPokemons()),
        child: MaterialApp(
          title: 'My Pokedex',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.red,
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
