import 'package:flutter/material.dart';
import 'package:inscription/inscriptionscreen.dart';
import 'package:inscription/database_helper.dart';
import 'package:inscription/user_model.dart';
import 'package:inscription/recettes_screen.dart'; // Ajoutez cette importation

class ConnexionScreen extends StatefulWidget {
  @override
  _ConnexionScreenState createState() => _ConnexionScreenState();
}

class _ConnexionScreenState extends State<ConnexionScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  bool _obscurePassword = true; // Variable pour contrôler la visibilité du mot de passe

  void _loginUser(BuildContext context) async {
    final user = await dbHelper.getUserByEmailAndPassword(
      emailController.text,
      passwordController.text,
    );

    if (user != null) {
      // Si l'utilisateur est déjà enregistré, redirige vers les recettes
      Navigator.pushNamed(context, '/recettes');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email ou mot de passe incorrect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
        backgroundColor: Colors.blue, // Changement du fond à bleu
      ),
      body: Container(
        color: Colors.lightBlue[50], // Couleur de fond bleue ciel
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/food.jpg', // Chemin de l'image
                width: 120, // Largeur souhaitée de l'image
                height: 120, // Hauteur souhaitée de l'image
              ),
            ),
            SizedBox(height: 35), // Espace entre l'image et le formulaire
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.blue),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: TextStyle(color: Colors.blue),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _loginUser(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Texte blanc pour une meilleure visibilité
              ),
              child: Text('Se connecter'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/inscription');
              },
              child: Text('Créer un compte'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Maintenir la couleur bleue pour le texte
              ),
            ),
          ],
        ),
      ),
    );
  }
}
