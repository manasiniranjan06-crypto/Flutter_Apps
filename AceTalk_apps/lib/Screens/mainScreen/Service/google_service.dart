

import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = "AIzaSyD41B1OkN57VnL_PWcZ23aHHVNpvVHH2tc";

  Future<String> sendPrompt(String prompt) async {
    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["candidates"][0]["content"]["parts"][0]["text"];
      } else {
        return "Error: ${response.body}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
}