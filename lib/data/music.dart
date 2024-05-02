
import 'dart:convert';

List<Music> musicFromJson(String str) => List<Music>.from(json.decode(str).map((x) => Music.fromJson(x)));

String musicToJson(List<Music> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Music {
  String musicId;
  String title;
  String artist;
  String lyrics;
  String thumbnail;

  Music({
    required this.musicId,
    required this.title,
    required this.artist,
    required this.lyrics,
    required this.thumbnail,
  });

  factory Music.fromJson(Map<String, dynamic> json) => Music(
    musicId: json["music_id"],
    title: json["title"],
    artist: json["artist"],
    lyrics: json["lyrics"],
    thumbnail: json["thumbnail"] ?? 'https://st.depositphotos.com/1766887/1279/i/450/depositphotos_12798148-stock-photo-grunge-musical-background.jpg',
  );

  Map<String, dynamic> toJson() => {
    "music_id": musicId,
    "title": title,
    "artist": artist,
    "lyrics": lyrics,
    "thumbnail": thumbnail,
  };
}
