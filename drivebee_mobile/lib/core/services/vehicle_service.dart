import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../../shared/models/vehicle_model.dart';

class VehicleService {
  final http.Client _client;

  VehicleService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the list of vehicles from the backend database.
  /// Attaches the user's saved JWT Bearer token to the Authorization headers.
  Future<List<Vehicle>> fetchVehicles({String? searchQuery}) async {
    String urlString = '${ApiConstants.baseUrl}/vehicles';
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      urlString += '?search=${Uri.encodeComponent(searchQuery.trim())}';
    }
    final url = Uri.parse(urlString);
    
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
  /// Returns the created [Vehicle] object.
  Future<Vehicle> createVehicle(Map<String, dynamic> vehicleData) async {
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
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Vehicle.fromJson(responseData);
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

  /// Uploads a vehicle image to the backend server using bytes.
  /// Attaches the user's saved JWT Bearer token to the Authorization headers.
  /// Returns the uploaded image URL string on success, or null on failure.
  Future<String?> uploadVehicleImage(int vehicleId, Uint8List imageBytes, String filename) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/vehicles/$vehicleId/image');

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      final request = http.MultipartRequest('POST', url);

      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: filename,
        ),
      );

      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
