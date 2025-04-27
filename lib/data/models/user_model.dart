class UserModel {
  final String? id;
  final String nom;
  final String prenom;
  final String email;
  final String tel;
  final String password;
  final String role;
  

  UserModel({
    this.id,
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
  factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id']?.toString(),
    nom: json['nom'],
    prenom: json['prenom'],
    email: json['email'],
    tel: json['tel'].toString(), 
    password: '', // vide ou à part, car on ne le renvoie jamais
    role: json['role'] ?? "user",
  );
}

}
