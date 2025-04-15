import 'dart:io';

class CarAnnouncement {
  final int? id;
  final String title;
  final String carCondition;
  final int year;
  final String brand;
  final String model;
  final String fuelType;
  final int mileage;
  final List<String> options;
  final String location;
  final double price;
  final String description;
  final File? imageFile;
  final String imageUrl;
  final int vendorId;

  CarAnnouncement({
    this.id,
    required this.title,
    required this.carCondition,
    required this.year,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.mileage,
    required this.options,
    required this.location,
    required this.price,
    required this.description,
    this.imageFile,
    required this.imageUrl,
    required this.vendorId,
  });

  factory CarAnnouncement.fromJson(Map<String, dynamic> json) {
    return CarAnnouncement(
      id: json['id'],
      title: json['title'],
      carCondition: json['car_condition'],
      year: json['year'],
      brand: json['brand'],
      model: json['model'],
      fuelType: json['fuel_type'],
      mileage: json['mileage'],
      options: List<String>.from(json['options'] ?? []),
      location: json['location'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      imageFile: json['image_file'] != null ? File(json['image_file']) : null,
      imageUrl: json['image_url'],
      vendorId: json['vendor_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title,
        'car_condition': carCondition,
        'year': year,
        'brand': brand,
        'model': model,
        'fuel_type': fuelType,
        'mileage': mileage,
        'options': options,
        'location': location,
        'price': price,
        'description': description,
        'image_file': imageFile?.path, // null-safe
        'image_url': imageUrl,
        'vendor_id': vendorId,
      };

  CarAnnouncement copyWith({
    String? title,
    String? carCondition,
    int? year,
    String? brand,
    String? model,
    String? fuelType,
    int? mileage,
    List<String>? options,
    String? location,
    double? price,
    String? description,
    String? imageUrl,
    File? imageFile,
    int? vendorId,
  }) {
    return CarAnnouncement(
      id: id,
      title: title ?? this.title,
      carCondition: carCondition ?? this.carCondition,
      year: year ?? this.year,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      fuelType: fuelType ?? this.fuelType,
      mileage: mileage ?? this.mileage,
      options: options ?? this.options,
      location: location ?? this.location,
      price: price ?? this.price,
      description: description ?? this.description,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      vendorId: vendorId ?? this.vendorId,
    );
  }
}
