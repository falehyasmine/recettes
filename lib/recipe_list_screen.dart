import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inscription/database_helper.dart';
import 'package:inscription/models/recetteprovider.dart';
import 'package:inscription/recette_model.dart';
import 'package:provider/provider.dart'; // Assurez-vous d'importer Provider

class RecipeListScreen extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Healthy Recipes'),
      ),
      body: Consumer<RecettesProvider>( // Utilise Consumer pour écouter les changements de l'état
        builder: (context, recettesProvider, child) {
          return FutureBuilder<List<Recette>>(
            future: recettesProvider.fetchRecettes(), // Utilise le fournisseur pour la liste des recettes
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Aucune recette ajoutée.'));
              } else {
                List<Recette> recettes = snapshot.data!;
                return ListView.builder(
                  itemCount: recettes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(recettes[index].titre),
                      subtitle: Text(recettes[index].ingredients),
                      leading: recettes[index].imagePath.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: recettes[index].imagePath,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            )
                          : null,
                      onTap: () {
                        // Fonctionality pour afficher les détails de la recette
                      },
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/ajoutRecette');
        },
        child: Icon(Icons.add),
        tooltip: 'Ajouter une recette',
      ),
    );
  }
}
