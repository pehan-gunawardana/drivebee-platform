class Booking {
  final int id;
  final int vehicleId;
  final String? vehicleBrand;
  final String? vehicleModel;
  final String startDate;
  final String endDate;
  final String status;
  final double? totalPrice;

  final String? paymentMethod;
  final String? paymentStatus;

  Booking({
    required this.id,
    required this.vehicleId,
    this.vehicleBrand,
    this.vehicleModel,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.totalPrice,
    this.paymentMethod,
    this.paymentStatus,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    int vId = 0;
    String? brand;
    String? model;

    if (json['vehicle'] != null) {
      final vehicleJson = json['vehicle'] as Map<String, dynamic>;
      vId = vehicleJson['id'] as int;
      brand = vehicleJson['brand'] as String?;
      model = vehicleJson['model'] as String?;
    } else if (json['vehicleId'] != null) {
      vId = json['vehicleId'] as int;
    }

    return Booking(
      id: json['id'] as int,
      vehicleId: vId,
      vehicleBrand: brand,
      vehicleModel: model,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      status: json['status'] as String,
      totalPrice: json['totalPrice'] != null ? (json['totalPrice'] as num).toDouble() : null,
      paymentMethod: json['paymentMethod'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
    };
  }
}
