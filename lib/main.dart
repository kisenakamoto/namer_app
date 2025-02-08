import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 43, 80, 167)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;   
    var favs = appState.favorites;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center( //refactor Column (wrap with center)
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Text('A random idea:'),
            //Text(appState.current.asLowerCase),
            BigCard(pair: pair), //refactor (extract widget to create new class BigCard)
            
            
            SizedBox(height: 10), //add space between BigCard and button
        
        
            Row(
              mainAxisSize: MainAxisSize.min, //center row
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                    print("Added $favs to favorites" );
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),

                SizedBox(width: 10),
                
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); //get app current theme
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary, //text size and color
      );

    return Card( //refactored Padding (wrap with widget)
      color: theme.colorScheme.primary, //card color
      child: Padding( //refactored Text (wrap with padding)
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase, 
        style: style,
        semanticsLabel: "${pair.first} ${pair.second}", //for screenreader to read two words
        ),
      ),
    );
  }
}