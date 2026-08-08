import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../../shared/models/booking_model.dart';

class BookingService {
  final http.Client _client;

  BookingService({http.Client? client}) : _client = client ?? http.Client();

  /// Submits a booking request to the backend.
  /// Attaches the user's saved JWT Bearer token to the Authorization headers.
  /// Returns [true] if successfully created (status 200 or 201).
  Future<bool> createBooking(Map<String, dynamic> data) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/bookings');

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
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Create booking failed with status code: ${response.statusCode}');
        print('Backend response body: ${response.body}');
        // Retrieve error message from response body if present
        String errorMessage = 'Booking failed';
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          }
        } catch (_) {}
        throw Exception('$errorMessage (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to connect to backend: $e');
    }
  }

  /// Fetches all bookings of the currently logged-in user under my-trips.
  /// Attaches the user's saved JWT Bearer token to the Authorization headers.
  Future<List<Booking>> fetchMyTrips() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/bookings/my-trips');

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
        return jsonList.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to connect to backend: $e');
    }
  }

  /// Deprecated helper calling fetchMyTrips for compatibility.
  Future<List<Booking>> fetchMyBookings() => fetchMyTrips();
}
