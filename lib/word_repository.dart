import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';

class WordRepository {
  Future<String> getWord() async {
    final url = Uri.parse("https://api.datamuse.com/words?sp=?????&max=500");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        int randomIndex = Random().nextInt(500);
        return data[randomIndex]['word'].toString();
      } else {
        return "No word found";
      }
    } else {
      throw Exception('Failed to load word');
    }
  }
}
