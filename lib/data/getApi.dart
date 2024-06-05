import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:must/data/specialData.dart';

Future<String> getTranslation_papago(String text) async {
  // String _client_id = "client_id";
  String _client_id = "zu36cpwv04";

  String _client_secret = "lZAiglUdQ6Qqbtarxz9ZEIwHWpSZy7RYxX8oCNh6";
  String _content_type = "application/x-www-form-urlencoded; charset=UTF-8";
  final String encodedText = Uri.encodeComponent(text);
  final String data = "source=ko&target=en&text=$encodedText";

  String _url = "https://naveropenapi.apigw.ntruss.com/nmt/v1/translation";


  http.Response trans = await http.post(
    Uri.parse(_url),
    headers: {
      'Content-Type': _content_type,
      'X-Naver-Client-Id': _client_id,
      'X-Naver-Client-Secret': _client_secret
    },
    body: data,
  );
  if (trans.statusCode == 200) {
    var dataJson = jsonDecode(trans.body);
    var resultPapago = dataJson['message']['result']['translatedText'];
    return resultPapago;
  } else {
    print(trans.statusCode);
    return "ERROR";
  }
}


Future<SpecialData> loadSpecialData() async {
  try {
    String jsonString = await rootBundle.loadString('assets/specialData.json');
    print('JSON String: $jsonString');
    final List<dynamic> jsonData = json.decode(jsonString);
    print('JSON Data: $jsonData');
    final List<SpecialData> specialDataList = jsonData.map((item) {
      return SpecialData.fromJson(item);
    }).toList();
    print('SpecialData List: $specialDataList');
    final Random random = Random();
    int randomIndex = random.nextInt(specialDataList.length);
    print('Selected SpecialData: ${specialDataList[randomIndex].word}');
    return specialDataList[randomIndex];
  } catch (e) {
    print('Error loading special data: $e');
    throw Exception('Failed to load special data');
  }
}


Future<List<dynamic>> loadSpecialData2() async {
  try {
    String jsonString = await rootBundle.loadString('assets/specialData.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((item) {
      final specialDataList = SpecialData.fromJson(item);
      return specialDataList;
    }).toList();
  } catch (e) {
    print('Error loading quiz data: $e');
    throw Exception('Failed to load quiz data');
  }
}