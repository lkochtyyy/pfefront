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
  final String options;
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
    // Handle price as num or String
    final rawPrice = json['price'];
    double parsedPrice;
    if (rawPrice is num) {
      parsedPrice = rawPrice.toDouble();
    } else if (rawPrice is String) {
      parsedPrice = double.tryParse(rawPrice) ?? 0.0;
    } else {
      parsedPrice = 0.0;
    }

    return CarAnnouncement(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      carCondition: json['car_condition'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      fuelType: json['fuel_type'] as String? ?? '',
      mileage: json['mileage'] as int? ?? 0,
      options: json['options'] as String? ?? '',
      location: json['location'] as String? ?? '',
      price: parsedPrice,
      description: json['description'] as String? ?? '',
      imageFile: json['image_file'] != null ? File(json['image_file'] as String) : null,
      imageUrl: json['image_url'] as String? ?? '',
      vendorId: json['vendor_id'] as int? ?? 0,
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
        'image_file': imageFile?.path,
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
    String? options,
    String? location,
    double? price,
    String? description,
    File? imageFile,
    String? imageUrl,
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
