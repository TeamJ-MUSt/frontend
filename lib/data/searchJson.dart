import 'dart:convert';

SearchSong searchSongFromJson(String str) => SearchSong.fromJson(json.decode(str));

String searchSongToJson(SearchSong data) => json.encode(data.toJson());

List<SearchSong> searchSongsFromJson(String str) {
  final jsonData = json.decode(str);
  final songsJson = jsonData['songs']; // Access the 'songs' key which contains the list
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
  final int? level; // 수정: level을 nullable로 변경
  var bugsId;
  var thumbnail = Null;

  SearchSong({
    required this.songId,
    required this.title,
    required this.artist,
    required this.lyrics,
    required this.level,
    required this.bugsId,
    required thumbnail,
  });

  factory SearchSong.fromJson(Map<String, dynamic> json) => SearchSong(
    songId: json["songId"],
    title: json["title"],
    artist: json["artist"],
    lyrics: json["lyrics"],
    level: json["level"],
    bugsId: json["bugsId"],
    thumbnail: json["thumbnail"],
  );


  Map<String, dynamic> toJson() => {
    "songId": songId,
    "title": title,
    "artist": artist,
    "lyrics": lyrics,
    "level": level,
    "bugsId":bugsId,
  };
}