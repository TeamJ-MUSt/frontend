import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:must/data/MeaningQuizParsing.dart';
import 'package:must/data/searchJson.dart';
import 'package:must/data/wordJson.dart';
import 'dart:convert';
import 'ReadingQuizParsing.dart';
import 'musicjson.dart';

String ip ='222.108.102.12:9090';
Uint8List decodeBase64(String base64String) {
  return base64.decode(base64String);
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

//퀴즈를 생성합니다
Future<bool> creatingMeanQuiz(int songId) async {
  String preurl = 'http://${ip}/quiz/create?songId=${songId}&type=MEANING';
  var url = Uri.parse(preurl);
  try {
    var response = await http.post(url);
    if (response.statusCode == 200) {
      var checkBody = jsonDecode(utf8.decode(response.bodyBytes));
      // Potentially do something with the decoded body
      print('Quiz initialized: ${utf8.decode(response.bodyBytes)}');
      return checkBody['success'];
    } else {
      print('Failed with status code: ${response.statusCode}');
    }
  } catch (e, s) {
    print('Failed to make request for quiz: $e');
    print('Stack Trace: $s');
  }
  return false;
}

//퀴즈를 조회합니다
Future<List<MeanQuiz>> fetchMeanQuizData2(int songId) async {
  var url = Uri.parse('http://${ip}/quiz?songId=${songId}&type=MEANING');
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
//퀴즈를 조회합니다 :: 조회가..아예 안되면 어떡하지
Future<int> fetchMeanQuizData(int songId) async {
  var url = Uri.parse('http://${ip}/quiz?songId=${songId}&type=MEANING');
  print(url);
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var checkBody = jsonDecode(utf8.decode(response.bodyBytes));
      print('Quiz initialized: ${utf8.decode(response.bodyBytes)}');
      print(checkBody['success']);
      return checkBody['success'] ? 1 : 0;
    } else {
      print('Failed with status code: ${response.statusCode}');
      return -1;
    }
  } catch (e, s) {
    print('Failed to make request for quiz: $e');
    print('Stack Trace: $s');
    return 100;
  }
}


Future<List<ReadQuiz>> fetchReadQuizData() async {
  var url = Uri.parse('http://${ip}/quiz?songId=1&type=READING');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      return readQuizFromJson(decodedBody);
    } else {
      throw Exception('Failed to load quiz data');
    }
  } catch (e) {
    print('Failed to fetch data: $e');
    throw Exception('Failed to fetch data: $e');
  }
}

// Future<List<MeanQuiz>> notAPIMeanQuizData() async {
//   try {
//     // assets 폴더에 저장된 quizData.json 파일에서 JSON 문자열 읽기
//     String jsonString = await rootBundle.loadString('assets/quizData.json');
//     // JSON 문자열을 Dart 객체로 파싱
//     return MeanQuiz.meanQuizFromJson(jsonString);
//   } catch (e) {
//     print('Error loading quiz data: $e');
//     throw Exception('Failed to load quiz data');
//   }
// }

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