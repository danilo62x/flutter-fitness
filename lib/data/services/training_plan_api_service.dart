import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fitness/data/models/training_plan_api_model.dart';

/// Stateless service wrapping the training-plan HTTP endpoints.
class TrainingPlanApiService {
  TrainingPlanApiService({
    http.Client? client,
    this.baseUrl = 'https://api.example.com',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  /// Demo GET request. Returns the parsed list of available plans.
  Future<List<TrainingPlanApiModel>> fetchPlans() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/plans'),
      headers: const {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load plans (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => TrainingPlanApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
