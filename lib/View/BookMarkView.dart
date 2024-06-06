import 'dart:typed_data';
import 'package:must/style.dart' as myStyle;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:must/data/bookmark_controller.dart';

import '../data/api_service.dart';
import '../data/searchJson.dart';
import 'Widget/basicSongListWidget.dart';

class BookMarkView extends StatefulWidget {
  const BookMarkView({super.key});

  @override
  State<BookMarkView> createState() => _BookMarkViewState();
}

class _BookMarkViewState extends State<BookMarkView> {

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
    final BookmarkController bookmarkController =
    Get.find<BookmarkController>();
    // Filter the list of songs to only include bookmarked ones
    final List<SearchSong> bookmarkedSongs = songs
        .where((song) => bookmarkController.isBookmarked(song.songId))
        .toList();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
        child: ListView.builder(
          itemCount: bookmarkedSongs.length,
          itemBuilder: (context, index) {
            SearchSong song = bookmarkedSongs[index];
            return basicSongListWidget(
              song: song,
              thumbnail: thumbnails[song.songId],
            );
          },
        ),
      ),
    );
  }
}
