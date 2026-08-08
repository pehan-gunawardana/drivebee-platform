import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../../shared/models/review_model.dart';

class ReviewService {
  final http.Client _client;

  ReviewService({http.Client? client}) : _client = client ?? http.Client();

  Future<Review> createReview({
    required int vehicleId,
    required int rating,
    required String comment,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/reviews');

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _client.post(
        url,
        headers: headers,
        body: jsonEncode({
          'vehicleId': vehicleId,
          'rating': rating,
          'comment': comment,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Review.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to submit review (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error submitting review: $e');
    }
  }

  Future<List<Review>> fetchReviewsForVehicle(int vehicleId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/reviews/vehicle/$vehicleId');

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _client.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reviews (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching reviews: $e');
    }
  }
}
