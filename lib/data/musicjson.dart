import 'dart:convert';

Song songFromJson(String str) => Song.fromJson(json.decode(str));

String songToJson(Song data) => json.encode(data.toJson());



class Song {
  int songId;
  String title;
  String artist;
  String lyrics;
  String level = "쉬움";
  var thumbnail;

  Song({
    required this.title,
    required this.artist,
    required this.lyrics,
    required this.songId,
    required this.level,
    required this.thumbnail,
  });

  factory Song.fromJson(Map<String, dynamic> json) => Song(
    songId: json["songId"],
    title: json["title"],
    artist: json["artist"],
    lyrics: json["lyrics"],
    level: json["level"],
    thumbnail: json["thumbnail"],
  );


  Map<String, dynamic> toJson() => {
    "songId": songId,
    "title": title,
    "artist": artist,
    "lyrics": lyrics,
    "level": level,
    "thumbnail": thumbnail,
  };
}