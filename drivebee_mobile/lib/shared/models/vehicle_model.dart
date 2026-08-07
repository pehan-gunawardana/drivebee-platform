class Vehicle {
  final int id;
  final String brand;
  final String model;
  final String licensePlate;
  final int year;
  final double pricePerDay;
  final String status;
  final String? imageUrl;

  Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.licensePlate,
    required this.year,
    required this.pricePerDay,
    required this.status,
    this.imageUrl,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      brand: json['brand'] as String,
      model: json['model'] as String,
      licensePlate: json['licensePlate'] as String,
      year: json['year'] as int,
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
      status: json['status'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'licensePlate': licensePlate,
      'year': year,
      'pricePerDay': pricePerDay,
      'status': status,
      'imageUrl': imageUrl,
    };
  }

  /// Returns the absolute image URL by prepending the backend host if necessary.
  String? get fullImageUrl {
    if (imageUrl == null || imageUrl!.trim().isEmpty) return null;
    if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
      return imageUrl;
    }
    return 'http://localhost:8081$imageUrl';
  }
}
