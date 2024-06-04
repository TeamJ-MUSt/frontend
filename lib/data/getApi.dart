import 'dart:convert';
import 'package:http/http.dart' as http;





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