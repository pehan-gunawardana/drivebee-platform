class Review {
  final int id;
  final int vehicleId;
  final int userId;
  final String userFirstName;
  final String userLastName;
  final int rating;
  final String comment;
  final String createdAt;

  Review({
    required this.id,
    required this.vehicleId,
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      vehicleId: json['vehicleId'] as int,
      userId: json['userId'] as int,
      userFirstName: json['userFirstName'] as String? ?? 'User',
      userLastName: json['userLastName'] as String? ?? '',
      rating: json['rating'] as int,
      comment: json['comment'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'userId': userId,
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }
}
