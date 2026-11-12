# Pokedex App

Small Flutter app I made to practice Bloc. It gets data from the free [PokeAPI](https://pokeapi.co) (no key needed).

## What it does

- shows a list of pokemons, loads more when you scroll down
- pull down to refresh
- tap a pokemon to see its types, height, weight, abilities and stats
- shows loading spinners and error messages with a try again button

## Structure

```
lib/
  main.dart
  utils.dart
  models/      pokemon.dart, pokemon_detail.dart
  services/    pokemon_api.dart
  bloc/        pokemon_list_*  and  pokemon_detail_*
  screens/     home_screen.dart, detail_screen.dart
test/
  widget_test.dart
```

State management is done with `flutter_bloc`. There are two blocs:

- `PokemonListBloc` for the main list (first load, load more, refresh)
- `PokemonDetailBloc` for the detail screen

## How to run


```
flutter pub get
flutter run
```

Keep the project name `pokedex_app`, the test imports use it.

## Android release build

Debug builds can use internet already. For a release apk open `android/app/src/main/AndroidManifest.xml` and add this line above `<application`:

```
<uses-permission android:name="android.permission.INTERNET"/>
```

iOS doesn't need anything extra.
