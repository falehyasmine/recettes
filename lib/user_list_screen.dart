import 'package:flutter/material.dart';
import 'package:inscription/database_helper.dart';
import 'package:inscription/user_model.dart';
import 'package:inscription/recettes_screen.dart';
class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final fetchedUsers = await dbHelper.getAllUsers();
      setState(() {
        users = fetchedUsers.cast<User>();
      });
    } catch (e) {
      print("Erreur lors du chargement des utilisateurs : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des utilisateurs'),
        backgroundColor: Colors.blue,  // Changement du fond à bleu
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/recettes');
            },
          ),
        ],
      ),
      body: users.isEmpty
          ? Center(
              child: Text(
                'Aucun utilisateur enregistré.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(user.nom),  // Correction ici
                    subtitle: Text(user.email),
                    leading: Icon(Icons.person, color: Colors.blueAccent),
                  ),
                );
              },
            ),
    );
  }
}
