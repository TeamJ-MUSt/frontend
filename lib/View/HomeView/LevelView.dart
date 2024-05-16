import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:must/View/Widget/SongListSmall.dart';
import 'package:must/View/Widget/SongListWidget.dart';
import 'package:must/View/Widget/noImageSongList.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/api_service.dart';
import '../../data/musicjson.dart';
import '../../data/searchJson.dart';

class LevelView extends StatefulWidget {
  const LevelView({super.key});

  @override
  State<LevelView> createState() => _LevelViewState();
}

class _LevelViewState extends State<LevelView> {
  List<SearchSong> songs = [];
  Map<int, Uint8List> thumbnails = {};

  @override
  void initState() {
    super.initState();
    fetchSongsAndThumbnails();
  }

  Future<void> fetchSongsAndThumbnails() async {
    try {
      songs = await fetchSongData();
      print('fetch end');
      for (var song in songs) {
        if (song.songId != null) { //노래 데이터를 찾으면 썸네일을 가져옵니다
          Uint8List? thumbnail = await fetchSongThumbnail(song.songId);
          if (thumbnail != null) {
            thumbnails[song.songId] = thumbnail; // Correct key to songId
            print('Thumbnail for song ID ${song.songId} fetched');
          }
        } else {
          print('no song id!');
        }
      }
      setState(() {}); // Refresh UI with fetched data
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
        child:
        ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              SearchSong song = songs[index]; // Retrieve the thumbnail using songId
              return SongListWidget(song: song,thumbnail: thumbnails[song.songId],);
              // return NoImageSongList(song: song,);
            }));
  }}
