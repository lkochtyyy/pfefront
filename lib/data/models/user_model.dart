class UserModel {
  final String nom;
  final String prenom;
  final String email;
  final String tel;
  final String password;
  final String role;

  UserModel({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.tel,
    required this.password,
    this.role = "user",
  });

  Map<String, dynamic> toJson() {
    return {
      "nom": nom,
      "prenom": prenom,
      "email": email,
      "numTel": tel,
      "password": password,
      "role": role,
    };
  }
}
