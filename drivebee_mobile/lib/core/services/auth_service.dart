import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  /// Logs in the user with email and password.
  /// Persists the returned JWT token to SharedPreferences on success.
  /// Throws an [Exception] if the request fails or returns an error.
  Future<bool> login(String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/auth/login');

    try {
      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String? token = responseData['token'];

        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          return true;
        } else {
          throw Exception('Token not found in response');
        }
      } else {
        // Retrieve error message from response body if present
        String errorMessage = 'Login failed';
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

  /// Clears the saved JWT token from SharedPreferences.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
