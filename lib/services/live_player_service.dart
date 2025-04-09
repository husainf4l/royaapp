// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:royaapp/config/app_config.dart'; // Import the configuration

class LivePlayerService {
  Future<List<dynamic>> fetchLivePlayers() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/live-players/active'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load live players');
    }
  }
}
