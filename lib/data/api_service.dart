import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:must/data/MeaningQuizParsing.dart';
import 'package:must/data/searchJson.dart';
import 'package:must/data/wordJson.dart';
import 'dart:convert';
import 'ReadingQuizParsing.dart';
import 'SeqQuizJson.dart';
import 'musicjson.dart';

String ip ='222.108.102.12:9090';
Uint8List decodeBase64(String base64String) {
  return base64.decode(base64String);
}

class quizSet {
  final bool success;
  final int setNum;

  quizSet(this.success, this.setNum);
}

// 노래를 등록합니다
Future enrollSongData(int songId) async {
  var url = Uri.parse('http://${ip}/songs/new?memberId=1&songId=${songId}');
  String result;
  try {
    var response = await http.post(url);
    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      var decodedBody = utf8.decode(response.bodyBytes);
      print('Response body: $decodedBody');
      result="등록이 완료되었습니다";
    } else {
      print('Failed to load song details: Server responded ${response.statusCode}');
      result = "통신오류";
    }
  } catch (e) {
    print('Failed to make request for song details: $e');
    result = e.toString();
  }
  print(result);
}

// 노래에 맞는 썸네일을 가져옵니다
Future<Uint8List?> fetchSongThumbnail(int songID) async {
  Uint8List? imageBytes;
  var url = Uri.parse('http://${ip}/image/${songID}');
  try {
    var response2 = await http.get(url);
    if (response2.statusCode == 200 &&
        response2.headers['content-type']!.startsWith('image/') ?? false) {
      print('Image response status: ${response2.statusCode}');
      imageBytes = response2.bodyBytes;
      return imageBytes;
    } else {
      'Failed to load image: Server responded ${response2.statusCode}';
      imageBytes = null;
      return imageBytes;
    }
  } catch (e) {
    print('Failed to make request for image: $e');
  }
}

// 모든 노래를 가져옵니다
Future<List<SearchSong>> fetchSongData() async {
  var url = Uri.parse('http://${ip}/main/songs/1?pageNum=0');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      print('Response body: $decodedBody');
      List<SearchSong> song = searchSongsFromJson(decodedBody);
      return song;// Return the list of songs directly
    } else {
      throw Exception('Failed to load song data');
    }
  } catch (e) {
    print('Failed to make request: $e');
    return []; // Return an empty list in case of failure
  }
}

// 내 DB에서 노래를 검색합니다
Future<List<SearchSong>> searchSongData(String? query) async {
  var url = Uri.parse('http://${ip}/1/search?artist=$query');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      print('Response body: $decodedBody');
      // SearchSong searchSong = searchSongFromJson(decodedBody);
      List<SearchSong> song = searchSongsFromJson(decodedBody);
      return song;
    } else {
      print('One or both responses failed');
      throw Exception('Failed to load song data due to server response: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to make request: $e');
    throw Exception('Failed to process request: $e'); // Ensure you throw an exception here
  }
}

//전체 DB에서 노래를 검색합니다
Future<List<SearchSong>> totalSearchSongData(String? query) async {
  var url = Uri.parse('http://${ip}/search?artist=$query');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      print('Response body: $decodedBody');
      print('Response end');
      List<SearchSong> song = searchSongsFromJson(decodedBody);
      print("list end");
      return song;
    } else {
      print('One or both responses failed');
      throw Exception('Failed to load song data due to server response: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to make request: $e');
    throw Exception('Failed to process request: $e'); // Ensure you throw an exception here
  }
}
//뜻퀴즈
// 퀴즈 로직 :: 세트 조회 , 몇개 세트
//http://222.108.102.12:9090/quiz/MEANING/set/1?songId=1
// 퀴즈 조회
//세트 개수 조회  http://222.108.102.12:9090/quiz/info?songId=1&type=MEANING

//퀴즈를 가져옵니다/quiz/MEANING/set/1?songId=1
Future<List<MeanQuiz>> getMeanQuizSet(int setNum, int songId) async {
  var url = Uri.parse('http://${ip}/quiz/MEANING/set/${setNum}?songId=${songId}');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      return meanQuizFromJson(decodedBody);  // Ensure this function is defined correctly
    } else {
      throw Exception('Failed to load quiz data with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to fetch data: $e');
    throw Exception('Failed to fetch data: $e');
  }
}

//퀴즈를 조회합니다 - 조회 가능한지 여부, 리스트 개수
Future<quizSet> fetchMeanQuizData(int songId) async {
  var url = Uri.parse('http://${ip}/quiz/info?songId=${songId}&type=MEANING');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var checkBody = jsonDecode(utf8.decode(response.bodyBytes));
      // quizSet = ;
      bool success = checkBody['success'];
      int setNum = checkBody['setNum'];
      return quizSet(success, setNum);
    } else {
      print('Failed with status code: ${response.statusCode}');
      return quizSet(false, -1);
    }
  } catch (e, s) {
    print('Failed to make request for quiz: $e');
    print('Stack Trace: $s');
    return quizSet(false, -2);
  }
}
// 퀴즈 이후 단어장 보내기
Future saveWord(int memberId, int songId) async {
  var url = Uri.parse('http://${ip}/word-book/new?memberId=${memberId}?songId=${songId}');
  try {
    var response = await http.post(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      return meanQuizFromJson(decodedBody);  // Ensure this function is defined correctly
    } else {
      throw Exception('Failed to load quiz data with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to fetch data: $e');
    throw Exception('Failed to fetch data: $e');
  }
}
//-------------------------

//퀴즈를 가져옵니다/quiz/MEANING/set/1?songId=1
Future<List<ReadQuiz>> getReadQuizSet(int setNum, int songId) async {
  var url = Uri.parse('http://${ip}/quiz/READ/set/${setNum}?songId=${songId}');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      return readQuizFromJson(decodedBody);  // Ensure this function is defined correctly
    } else {
      throw Exception('Failed to load quiz data with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to fetch data: $e');
    throw Exception('Failed to fetch data: $e');
  }
}

//퀴즈를 조회합니다 -
Future<quizSet> fetchReadQuizData(int songId) async {
  var url = Uri.parse('http://${ip}/quiz/info?songId=${songId}&type=READ');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var checkBody = jsonDecode(utf8.decode(response.bodyBytes));
      // quizSet = ;
      bool success = checkBody['success'];
      int setNum = checkBody['setNum'];
      return quizSet(success, setNum);
    } else {
      print('Failed with status code: ${response.statusCode}');
      return quizSet(false, -1);
    }
  } catch (e, s) {
    print('Failed to make request for quiz: $e');
    print('Stack Trace: $s');
    return quizSet(false, -2);
  }
}


Future<List<Word>> notAPIWordData() async {
  try {
    // assets 폴더에 저장된 quizData.json 파일에서 JSON 문자열 읽기
    String jsonString = await rootBundle.loadString('assets/wordData.json');
    // JSON 문자열을 Dart 객체로 파싱
    return Word.parseUserList(jsonString);
  } catch (e) {
    print('Error loading quiz data: $e');
    throw Exception('Failed to load quiz data');
  }
}

//순서퀴즈 조회
Future<List<SeqQuiz>> loadQuizData() async {
  try {
    String jsonString = await rootBundle.loadString('assets/seqQuizData.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((item) {
      final quiz = SeqQuiz.fromJson(item);
      quiz.options.shuffle(Random());
      return quiz;
    }).toList();
  } catch (e) {
    print('Error loading quiz data: $e');
    throw Exception('Failed to load quiz data');
  }
}
// 단어장 조회
Future<List<Word>> getWordbook(int memberId) async {
  var url = Uri.parse('http://${ip}/wordbook/${memberId}');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      return Word.parseUserList(decodedBody);  // Ensure this function is defined correctly
    } else {
      throw Exception('Failed to load quiz data with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to fetch data: $e');
    throw Exception('Failed to fetch data: $e');
  }
}

//유사단어 조회

