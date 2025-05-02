class Favori {
  final int userId;
  final int carId;

  Favori({required this.userId, required this.carId});

  factory Favori.fromJson(Map<String, dynamic> json) {
    return Favori(
      userId: json['user_id'],
      carId: json['car_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'car_id': carId,
    };
  }
}
