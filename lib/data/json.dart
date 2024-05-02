
import 'dart:io';
import 'dart:convert';

void main() async {
  try {
    final file = File('lib/data/04081426_lyrics.json');
    String fileContents = await file.readAsString();
    // 파일에서 읽은 내용에서 줄바꿈을 적절하게 이스케이프 처리

    String escapedJsonString = fileContents
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '') // 캐리지 리턴 제거
        .replaceAll('"', '\\"'); // 따옴표 이스케이프 처리
    // final jsonData = jsonDecode(escapedJsonString);
    Map<String, dynamic> jsonData = jsonDecode(escapedJsonString);
    print(jsonData);
  } catch (e) {
    print('An error occurred: $e');
  }
}

// Map<String, dynamic> jsonData = jsonDecode(jsonString);

class Song {
  final String title;
  final String artist;
  final String lyrics;
  final String thumbnail;

  Song({required this.title, required this.artist,required this.lyrics,required this.thumbnail});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      
      title: json['title'],
      artist: json['artist'],
      lyrics: json['lyrics'],
      thumbnail: json['thumbnail'] ?? 'https://st.depositphotos.com/1766887/1279/i/450/depositphotos_12798148-stock-photo-grunge-musical-background.jpg',
    );
  }
  static List<Song> parseUserList(String jsonString) {

    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Song>((json) => Song.fromJson(json)).toList();
  }
  }

