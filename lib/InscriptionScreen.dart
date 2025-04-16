import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'user_model.dart';

class InscriptionScreen extends StatelessWidget {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _register(BuildContext context) async {
final DatabaseHelper dbHelper = DatabaseHelper.instance;
    final user = User(
      nom: nomController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    await dbHelper.insertUser(user, context); // Passez le contexte ici

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Compte créé avec succès')),
    );

    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
        backgroundColor: Colors.lightBlue, // Couleur bleue ciel
      ),
      body: Container(
        color: Colors.lightBlue[50], // Couleur de fond bleue ciel
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nomController,
              decoration: InputDecoration(
                labelText: 'Nom',
                labelStyle: TextStyle(color: Colors.blue),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
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
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _register(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Texte blanc pour une meilleure visibilité
              ),
              child: Text("S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }
}
