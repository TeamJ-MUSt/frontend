import 'dart:convert';
import 'dart:typed_data';

SearchSong searchSongFromJson(String str) =>
    SearchSong.fromJson(json.decode(str));

String searchSongToJson(SearchSong data) => json.encode(data.toJson());

List<SearchSong> searchSongsFromJson(String str) {
  final jsonData = json.decode(str);
  final songsJson =
      jsonData['songs']; // Access the 'songs' key which contains the list
  return List<SearchSong>.from(songsJson.map((x) => SearchSong.fromJson(x)));
}

String searchSongsToJson(List<SearchSong> data) {
  return json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}

class SearchSong {
  int songId;
  String title;
  String artist;
  String? lyrics;
  int? level; // 수정: level을 nullable로 변경
  String? bugsId;
  bool? hasSong;
  Uint8List? thumbnail;

  SearchSong({
    required this.songId,
    required this.title,
    required this.artist,
    this.lyrics,
    this.level,
    this.bugsId,
    this.hasSong,
    this.thumbnail,
  });

  factory SearchSong.fromJson(Map<String, dynamic> json) {
    // if (json["songId"] == null) throw ArgumentError("songId is required");
    // if (json["title"] == null) throw ArgumentError("title is required");
    // if (json["artist"] == null) throw ArgumentError("artist is required");
    // if (json["thumbnail"] == null) throw ArgumentError("thumbnail is required");
    if (json["level"] == null) print("level");
    return SearchSong(
      songId: json["songId"],
      title: json["title"],
      artist: json["artist"],
      lyrics: json["lyrics"],
      level: json["level"],
      bugsId: json["bugsId"],
      hasSong: json["hasSong"],
      thumbnail: json["thumbnail"] != null ? Uint8List.fromList(List<int>.from(json["thumbnail"])) : null, // nullable로 설정
    );
  }

  Map<String, dynamic> toJson() => {
        "songId": songId,
        "title": title,
        "artist": artist,
        "lyrics": lyrics,
        "level": level,
        "bugsId": bugsId,
        "hasSong": hasSong,
        "thumbnail": thumbnail,
      };
}
