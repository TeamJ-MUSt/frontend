import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleTranslateService {
  final String apiKey;

  GoogleTranslateService(this.apiKey);

  Future<String> translate(String text) async {
    var _baseUrl = 'https://translation.googleapis.com/language/translate/v2';

    try {
      // 영어로 1차 번역
      var toEnglishResponse = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': text,
          'target': 'en'
        }),
      );

      if (toEnglishResponse.statusCode == 200) {
        var englishDataJson = jsonDecode(toEnglishResponse.body);
        String englishText = englishDataJson['data']['translations'][0]['translatedText'];

        // 한국어로 최종 번역
        var toKoreanResponse = await http.post(
          Uri.parse('$_baseUrl?key=$apiKey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'q': englishText,
            'target': 'ko'
          }),
        );

        if (toKoreanResponse.statusCode == 200) {
          var koreanDataJson = jsonDecode(toKoreanResponse.body);
          String resultKorean = koreanDataJson['data']['translations'][0]['translatedText'];
          return resultKorean;
        } else {
          print('Error translating to Korean: ${toKoreanResponse.statusCode}');
          return 'Fail';
        }
      } else {
        print('Error translating to English: ${toEnglishResponse.statusCode}');
        return 'Fail';
      }
    } catch (e) {
      print('Error: $e');
      return 'Fail';
    }
  }
}
