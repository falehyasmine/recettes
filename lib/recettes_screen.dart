import 'package:flutter/material.dart';

class RecetteScreen extends StatefulWidget {
  @override
  _RecetteScreenState createState() => _RecetteScreenState();
}

class _RecetteScreenState extends State<RecetteScreen> {
  List<Map<String, String>> recettes = [
    {'titre': 'Salade de Quinoa', 'ingredients': 'Quinoa, tomates cerises, concombre, menthe'},
    {'titre': 'Salade de Roquette', 'ingredients': 'Roquette, betteraves, fromage de chèvre, noix'},
  ];

  final TextEditingController titreController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();

  void _ajouterRecette() {
    if (titreController.text.isNotEmpty && ingredientsController.text.isNotEmpty) {
      setState(() {
        recettes.add({
          'titre': titreController.text,
          'ingredients': ingredientsController.text,
        });
        titreController.clear();
        ingredientsController.clear();
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tous les champs sont obligatoires.')),
      );
    }
  }

  void _mettreAJourRecette(int index) {
    if (titreController.text.isNotEmpty && ingredientsController.text.isNotEmpty) {
      setState(() {
        recettes[index] = {
          'titre': titreController.text,
          'ingredients': ingredientsController.text,
        };
        titreController.clear();
        ingredientsController.clear();
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tous les champs sont obligatoires.')),
      );
    }
  }

  void _showRecetteDialog({int? index}) {
    final isUpdate = index != null;

    if (isUpdate) {
      titreController.text = recettes[index!]['titre']!;
      ingredientsController.text = recettes[index]['ingredients']!;
    } else {
      titreController.clear();
      ingredientsController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(isUpdate ? 'Modifier la recette' : 'Ajouter une recette'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titreController,
                decoration: InputDecoration(labelText: 'Titre'),
              ),
              TextField(
                controller: ingredientsController,
                decoration: InputDecoration(labelText: 'Ingrédients'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => isUpdate ? _mettreAJourRecette(index!) : _ajouterRecette(),
              child: Text(isUpdate ? 'Mettre à jour' : 'Ajouter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _supprimerRecette(int index) {
    setState(() {
      recettes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recettes de Salades'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        color: Colors.lightBlue[50], // Arrière-plan bleu ciel
        child: recettes.isEmpty
            ? Center(
                child: Text(
                  'Aucune recette ajoutée.',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              )
            : ListView.builder(
                itemCount: recettes.length,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final recette = recettes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.fastfood, color: Colors.blueAccent),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  recette['titre']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            recette['ingredients']!,
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: Icon(Icons.edit, color: Colors.blueAccent),
                                label: Text('Modifier', style: TextStyle(color: Colors.blueAccent)),
                                onPressed: () => _showRecetteDialog(index: index),
                              ),
                              TextButton.icon(
                                icon: Icon(Icons.delete, color: Colors.redAccent),
                                label: Text('Supprimer', style: TextStyle(color: Colors.redAccent)),
                                onPressed: () => _supprimerRecette(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRecetteDialog(),
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
