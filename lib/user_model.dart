class User {
  final int? id;
  final String nom;
  final String email;
  final String password;

  User({this.id, required this.nom, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'password': password,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nom: map['nom'],
      email: map['email'],
      password: map['password'],
    );
  }
}
