class Vehicle {
  final int id;
  final String brand;
  final String model;
  final String licensePlate;
  final int year;
  final double pricePerDay;
  final String status;

  Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.licensePlate,
    required this.year,
    required this.pricePerDay,
    required this.status,
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
    };
  }
}
