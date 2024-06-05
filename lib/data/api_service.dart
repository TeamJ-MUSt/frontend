import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:must/data/MeaningQuizParsing.dart';
import 'package:must/data/searchJson.dart';
import 'package:must/data/simWordJson.dart';
import 'package:must/data/wordJson.dart';
import 'dart:convert';
import 'ReadingQuizParsing.dart';
import 'SeqQuizJson.dart';
import 'SeqQuizJson2.dart';
import 'musicWordJson.dart';

// String ip ='222.108.102.12:9090';
String ip ='192.168.1.79:8080';
Uint8List decodeBase64(String base64String) {
  return base64.decode(base64String);
}

class quizSet {
  final bool success;
  final int setNum;

  quizSet(this.success, this.setNum);
}


// 크롤링

Future<void> enrollSongData(int songId,String bugsId) async {
  var url = Uri.parse('http://${ip}/songs/new?memberId=1&songId=${songId}&bugsId=${bugsId}');
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
Future<Uint8List?>fetchSongThumbnail(int songID) async {
  Uint8List? imageBytes;
  var url = Uri.parse('http://${ip}/image/small/${songID}');
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

// 노래를 가져옵니다
//
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

//내가 가진 노래를 조회하기
Future<List<int>> getHadList() async {
  var url = Uri.parse('http://${ip}/main/songs/1?pageNum=1');
  try {
    var response = await http.get(url);
    // var response2 = await http.post(url2);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> data = json.decode(decodedBody);

      // songId의 리스트를 추출
      List<int> songIds = [];
      for (var song in data['songs']) {
        songIds.add(song['songId']);
      }
      return songIds;
    } else {
      print(response.statusCode);
      return [];
    }
  } catch (e, s) {
    print('Failed to make request for quiz: $e\n');
    print('Stack Trace: $s\n');
    return [];
  }

}
// 내 DB에서 노래를 검색합니다
//DB+내꺼
// /song/searchV2?title=노래제목&artist=가수&memberId=멤버아이디

class ApiResponse {
  final bool success;
  final List<SearchSong> songs;

  ApiResponse({required this.success, required this.songs});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'],
      songs: json['songs'] != null
          ? (json['songs'] as List).map((i) => SearchSong.fromJson(i)).toList()
          : [],
    );
  }
}

// 전체 DB에서 노래 검색
Future<ApiResponse> searchSongData2(String query) async {
  final response = await http.get(Uri.parse('http://${ip}/song/search?artist=${query}&memberId=1'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return ApiResponse.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load data');
  }
}


//DB밖에서 검색
Future<List<SearchSong>> CrawlingSongData(String query) async {
  var url = Uri.parse('http://${ip}/song/remote?title=${query}');
  try {
    var response = await http.post(url);
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

//퀴즈 생성 유무 확인
Future<bool> isCreateQuiz(String quizType, int songId) async {
  var url = Uri.parse('http://${ip}/quiz/info?songId=${songId}&type=READING');
  try{
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      var jsonData = json.decode(decodedBody);
      bool isCreated = jsonData['success'];
      print(response);
      return isCreated;
    }
  }catch(e,s){
    print('Failed to check is created for quiz : $e\n');
  }
  return false;
}

//퀴즈를 가져옵니다/quiz/MEANING/set/1?songId=1
Future<List<MeanQuiz>> getMeanQuizSet(int setNum, int songId) async {
  var url = Uri.parse('http://${ip}/quiz/MEANING/set/${setNum}?songId=${songId}');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      print("get mean quiz");
      return meanQuizFromJson(decodedBody);  // Ensure this function is defined correctly
    } else {
      throw Exception('Failed to load quiz data with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to fetch data: $e');
    throw Exception('Failed to fetch data: $e');
  }
}

Future<List<SeqQuiz>> getSeqQuizSet(int setNum, int songId) async {
  var url = Uri.parse('http://$ip/quiz/SENTENCE/set/$setNum?songId=$songId');
  print('Fetching data from: $url'); // Logging the URL
  try {
    var response = await http.get(url);
    print('Response status: ${response.statusCode}'); // Logging the response status
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      print('Response body: $decodedBody'); // Logging the response body for debugging
      return SeqQuizFromJson(decodedBody);  // Ensure this function is defined correctly
    } else {
      print('Failed to load quiz data with status code: ${response.statusCode}');
      throw Exception('Failed to load quiz data with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to fetch data: $e');
    throw Exception('Failed to fetch data: $e');
  }
}


Future<List<MeanQuiz>> createMeanQuizSet(int setNum, int songId) async {
  var url = Uri.parse('http://${ip}/quiz/MEANING/set/${setNum}?songId=${songId}');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      print("create MeanQuizset");
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

Future<quizSet> fetchQuizData(int songId, String quizType) async {
  var url = Uri.parse('http://${ip}/quiz/info?songId=${songId}&type=${quizType}');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var checkBody = jsonDecode(utf8.decode(response.bodyBytes));
      bool success = checkBody['success'];
      int setNum = checkBody['setNum'];
      print("setNum:$setNum");
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
  var url = Uri.parse('http://${ip}/quiz/READING/set/${setNum}?songId=${songId}');
  try {
    print(url);
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
//퀴즈를 생성합니다

Future<void> createQuiz(String quizType, int songId) async {
  var url = Uri.parse('http://${ip}/quiz/new?songId=${songId}&type=${quizType}');
  try {
    var response = await http.post(url);
    if (response.statusCode == 200) {
      print("Creating quiz");
      var decodedBody = utf8.decode(response.bodyBytes);
      print(response.statusCode);
      print(decodedBody);
    }
  } catch (e, s) {
    print('Failed to make request for quiz: $e\n');
  }
}


//퀴즈를 조회합니다 -
Future<quizSet> fetchReadQuizData(int songId) async {
  var url = Uri.parse('http://${ip}/quiz/info?songId=${songId}&type=READING');
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


//순서퀴즈 조회
Future<List<SeqQuiz2>> loadQuizData() async {
  try {
    String jsonString = await rootBundle.loadString('assets/seqQuizData.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((item) {
      final quiz = SeqQuiz2.fromJson(item);
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
  var url = Uri.parse('http://${ip}/word-book/${memberId}');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      return Word.parseApiWordList(decodedBody);  // Parse the JSON correctly
    } else {
      throw Exception('Failed to load word data with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to fetch data: $e');
    throw Exception('Failed to fetch data: $e');
  }
}



Future<List<SongWord>> getSongWordbook(int songId) async {
  var url = Uri.parse('http://$ip/song/words?songId=$songId');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      return WordParser.parseMusicWordList(decodedBody);  // Parse the JSON correctly
    } else {
      throw Exception('Failed to load word data with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to fetch data: $e');
    throw Exception('Failed to fetch data: $e');
  }
}


//퀴즈 풀고 단어장으로 보내기
Future<bool> quiz2Word(int songId) async{
  var url = Uri.parse('http://${ip}/word-book/new?memberId=1&songId=${songId}');
  try {
    var response = await http.post(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      var decoded = jsonDecode(decodedBody);
      // print(decoded['success']);
      return decoded['success'];  // Ensure this function is defined correctly
    } else {
      throw Exception('Failed to load quiz data with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to fetch data: $e');
    throw Exception('Failed to fetch data: $e');
  }
}
//유사단어 조회

Future<List<SimWord>> simWordget(int wordId) async {
  var url = Uri.parse('http://${ip}/word-book/word/${wordId}/similar?num=3');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedBody = utf8.decode(response.bodyBytes);
      return SimWord.parseSimWordList(decodedBody);  // Parse the JSON correctly
    } else {
      throw Exception('Failed to load word data with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to fetch data: $e');
    throw Exception('Failed to fetch data: $e');
  }
}

//유사단어 추가