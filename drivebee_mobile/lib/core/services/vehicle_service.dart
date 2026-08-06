import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../../shared/models/vehicle_model.dart';

class VehicleService {
  final http.Client _client;

  VehicleService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the list of vehicles from the backend database.
  /// Attaches the user's saved JWT Bearer token to the Authorization headers.
  Future<List<Vehicle>> fetchVehicles() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/vehicles');
    
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
        throw Exception('Failed to fetch vehicles (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to load vehicles: $e');
    }
  }

  /// Creates a new vehicle record on the backend server.
  /// Attaches the user's saved JWT Bearer token to the Authorization headers.
  /// Returns [true] if successfully created (status 200 or 201).
  Future<bool> createVehicle(Map<String, dynamic> vehicleData) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/vehicles');

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
        body: jsonEncode(vehicleData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        String errorMessage = 'Failed to list vehicle';
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          }
        } catch (_) {}
        throw Exception('$errorMessage (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to create vehicle: $e');
    }
  }
}
