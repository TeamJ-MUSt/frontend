import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:must/View/Widget/SongListSmall.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/api_service.dart';
import '../../data/searchJson.dart';

class EnrollSearchView extends StatefulWidget {
  EnrollSearchView({required this.query, super.key});
  final String query;

  @override
  State<EnrollSearchView> createState() => _EnrollSearchViewState();
}

class _EnrollSearchViewState extends State<EnrollSearchView> {
  late Future<List<SearchSong>> _futureSongs;
  Map<int, Uint8List> thumbnails = {};

  @override
  void initState() {
    super.initState();
    _futureSongs = fetchSongsAndThumbnails();
  }

  Future<List<SearchSong>> fetchSongsAndThumbnails() async {
    try {
      List<SearchSong> songs = await CrawlingSongData(widget.query);
      for (var song in songs) {
        if (song.songId != null) {
          Uint8List? thumbnail = await fetchSongThumbnail(song.songId);
          if (thumbnail != null) {
            thumbnails[song.songId] = thumbnail;
          }
        }
      }
      return songs;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: FutureBuilder<List<SearchSong>>(
        future: _futureSongs,
        builder: (BuildContext context, AsyncSnapshot<List<SearchSong>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Container(
                color: Colors.blue,
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<SearchSong> songs = snapshot.data!;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.query}에 대한 검색 결과입니다",
                    style: myStyle.textTheme.bodyMedium,
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        SearchSong song = songs[index];
                        return SongListSmall(
                          song: song,
                          thumbnail: thumbnails[song.songId],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text("NO DATA"));
          }
        },
      ),
    );
  }
}
