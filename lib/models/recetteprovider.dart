import 'package:flutter/material.dart';
import 'package:inscription/recette_model.dart';

class RecettesProvider with ChangeNotifier {
  Map<String, Recette> _recettes = {};

  Map<String, Recette> get recettes {
    return {..._recettes};
  }

  void ajouterRecette(Recette recette) {
    final id = DateTime.now().toString();
    _recettes[id] = recette;
    notifyListeners(); // Notify listeners to update the UI
  }

  fetchRecettes() {}
}
