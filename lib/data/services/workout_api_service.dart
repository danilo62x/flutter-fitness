import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fitness/data/models/workout_api_model.dart';

/// Stateless service wrapping the workout HTTP endpoints.
class WorkoutApiService {
  WorkoutApiService({
    http.Client? client,
    this.baseUrl = 'https://api.example.com',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  /// Demo GET request. Returns the parsed list of workouts for "today".
  Future<List<WorkoutApiModel>> fetchWorkouts() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/workouts/today'),
      headers: const {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load workouts (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => WorkoutApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
