import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inscription/models/recetteprovider.dart';
import 'package:inscription/recette_model.dart';
import 'package:provider/provider.dart';

import 'recettes_screen.dart';

class AjoutRecetteScreen extends StatefulWidget {
  @override
  _AjoutRecetteScreenState createState() => _AjoutRecetteScreenState();
}

class _AjoutRecetteScreenState extends State<AjoutRecetteScreen> {
  final TextEditingController titreController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isPickingImage = false;

  Future<void> _pickImageFromGallery() async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);

    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la sélection de l\'image.')));
    } finally {
      setState(() => _isPickingImage = false);
    }
  }

  Future<void> _takePhoto() async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);

    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la prise de photo.')));
    } finally {
      setState(() => _isPickingImage = false);
    }
  }

  void _ajouterRecette() async {
    if (titreController.text.isNotEmpty && ingredientsController.text.isNotEmpty) {
      String imagePath = _selectedImage?.path ?? '';
      Recette recette = Recette(
        titre: titreController.text,
        ingredients: ingredientsController.text,
        imagePath: imagePath,
      );

      // Utilisation du provider
      final recettesProvider = Provider.of<RecettesProvider>(context, listen: false);
      recettesProvider.ajouterRecette(recette);
      recettesProvider.notifyListeners();  // Notify listeners to update UI

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recette ajoutée avec succès.')));
      
      // Retour à la liste des recettes après ajout
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RecetteScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tous les champs sont obligatoires.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Recette'),
        backgroundColor: const Color.fromARGB(255, 82, 138, 236),
      ),
      body: Container(
        color: Colors.lightBlue[50],
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nouvelle Recette',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(height: 16),
              TextField(
                controller: titreController,
                decoration: InputDecoration(
                  labelText: 'Nom de la recette',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: ingredientsController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Ingrédients',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isPickingImage ? null : _pickImageFromGallery,
                    icon: Icon(Icons.photo, color: Colors.white),
                    label: Text('Galerie'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 179, 201, 238),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isPickingImage ? null : _takePhoto,
                    icon: Icon(Icons.camera_alt, color: Colors.white),
                    label: Text('Appareil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 179, 201, 238),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (_selectedImage != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _ajouterRecette,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 179, 201, 238),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 36),
                ),
                child: Text('Ajouter', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
