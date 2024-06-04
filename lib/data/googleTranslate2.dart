import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleTranslateService {
  final String apiKey;

  GoogleTranslateService(this.apiKey);

  Future<String> translate(String text, String targetLang) async {
    var _baseUrl = 'https://translation.googleapis.com/language/translate/v2';
    var key = apiKey;
    var to = "ko";//(ex: en, ko, etc..)
    var response = await http.post(
      Uri.parse('$_baseUrl?key=$key&q=$text&target=$to'),
    );

    if (response.statusCode == 200) {
      var dataJson = jsonDecode(response.body);
      String resultCloudGoogle = dataJson['data']['translations'][0]['translatedText'];
      return resultCloudGoogle;
    } else {
      print(response.statusCode);
      return 'Fail';
    }
/*
    final response = await http.post(
      Uri.parse('https://translation.googleapis.com/language/translate/v2'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'q': text,
        'target': targetLang,
        'format': 'text',
        'key': apiKey,
      }),
    );
    print("finish parse");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['data']['translations'][0]['translatedText'];
    } else {
      print('Translation error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to translate text');
    }*/
  }
}
