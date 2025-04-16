import 'package:flutter/material.dart';
import 'package:inscription/ConnexionScreen.dart';
import 'package:inscription/InscriptionScreen.dart';
import 'package:inscription/ajout_recette_screen.dart';
import 'package:inscription/models/recetteprovider.dart';
import 'package:inscription/user_list_screen.dart';
import 'package:inscription/recettes_screen.dart';
import 'package:inscription/database_helper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RecettesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recettes Healthy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.light(
          primary: Colors.blue, // Couleur primaire bleue
          background: Colors.blue[100], // Fond bleu pastel
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ConnexionScreen(),
        '/inscription': (context) => InscriptionScreen(),
        '/userList': (context) => UserListScreen(),
        '/recettes': (context) => RecetteScreen(),
        '/ajoutRecette': (context) => AjoutRecetteScreen(),
      },
    );
  }
}
