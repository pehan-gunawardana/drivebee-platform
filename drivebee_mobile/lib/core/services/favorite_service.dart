import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../../shared/models/vehicle_model.dart';

class FavoriteService {
  final http.Client _client;

  FavoriteService({http.Client? client}) : _client = client ?? http.Client();

  Future<bool> toggleFavorite(int vehicleId) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/favorites/$vehicleId');

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _client.post(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as bool;
      } else {
        throw Exception('Failed to toggle favorite (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error toggling favorite: $e');
    }
  }

  Future<List<Vehicle>> fetchFavorites() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/favorites');

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
        return jsonList.map((json) => Vehicle.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch favorites (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching favorites: $e');
    }
  }
}
