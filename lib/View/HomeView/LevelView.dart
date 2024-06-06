import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:must/View/Widget/basicSongListWidget.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/api_service.dart';
import '../../data/searchJson.dart';

class LevelView extends StatefulWidget {
  const LevelView({super.key});

  @override
  State<LevelView> createState() => _LevelViewState();
}

class _LevelViewState extends State<LevelView> {
  List<SearchSong> songs = [];
  Map<int, Uint8List> thumbnails = {};
  int? selectedLevel; // Variable to hold the selected level

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
        if (song.songId != null) {
          Uint8List? thumbnail = await fetchSongThumbnail(song.songId);
          if (thumbnail != null) {
            thumbnails[song.songId] = thumbnail;
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
    // Filter the songs based on the selected level
    List<SearchSong> filteredSongs = selectedLevel != null
        ? songs.where((song) => song.level == selectedLevel).toList()
        : songs;
    return Scaffold(
      body: Column(
        children: [
          // Dropdown menu for selecting levels
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedLevel = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(10.w, 20.h),
                    backgroundColor: selectedLevel == null ? myStyle.mainColor : Colors.grey, // Specify the height
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Text('전체', style: TextStyle(fontSize: 12.sp,fontFamily: 'NotoSansCJK',color: Colors.white)),
                ),
                SizedBox(width: 7.w,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedLevel = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(10.w, 20.h), // Specify the height
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    backgroundColor: selectedLevel == 1 ? myStyle.mainColor : Colors.grey,
                  ),
                  child: Text('쉬움',style: TextStyle(fontSize: 12.sp,fontFamily: 'NotoSansCJK',color: Colors.white)),
                ),
                SizedBox(width: 7.w,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedLevel = 2;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(10.w, 20.h), // Specify the height
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    backgroundColor: selectedLevel == 2 ? myStyle.mainColor : Colors.grey,
                  ),
                  child: Text('보통', style: TextStyle(fontSize: 12.sp,fontFamily: 'NotoSansCJK',color: Colors.white)),
                ),
                SizedBox(width: 7.w,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedLevel = 3;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(10.w, 20.h), backgroundColor: selectedLevel == 3 ? myStyle.mainColor : Colors.grey, // Specify the height
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Text('어려움',style: TextStyle(fontSize: 12.sp,fontFamily: 'NotoSansCJK',color: Colors.white)),
                ),

              ],
            ),
          ),
          // List of songs filtered by selected level
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 15.w),
              child: ListView.builder(
                itemCount: filteredSongs.length,
                itemBuilder: (context, index) {
                  SearchSong song = filteredSongs[index];
                  return basicSongListWidget(
                    song: song,
                    thumbnail: thumbnails[song.songId],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
