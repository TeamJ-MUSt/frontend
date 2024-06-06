import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:must/style.dart' as myStyle;
import '../../data/api_service.dart';
import '../../data/searchJson.dart';
import '../EnrollView/EnrollSearchView.dart';
import '../Widget/findDataViewSongWidget.dart';

class SearchView extends StatefulWidget {
  final String query;
  final String filter;
  const SearchView({required this.query, required this.filter, Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState(query: query);
}

class _SearchViewState extends State<SearchView> {
  _SearchViewState({required this.query});
  final String query;
  List<SearchSong> songs = [];
  Map<int, Uint8List> thumbnails = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchSongsAndThumbnails();
  }

  Future<void> fetchSongsAndThumbnails() async {
    try {
      var response = await searchSongData2(widget.query, widget.filter);
      if (response.success && response.songs != null) {
        songs = response.songs!;
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
      } else {
        errorMessage = '원하는 노래가 없나요?';
        print(errorMessage);
      }
    } catch (e) {
      errorMessage = 'Error fetching data: $e';
      print(errorMessage);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : songs.isNotEmpty
          ? Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "등록된 데이터 중에서 ${query}에 대한 검색 결과입니다",
              style: myStyle.textTheme.bodyMedium,
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  SearchSong song = songs[index];
                  print(song.level);
                  return findDataViewSongWidget(
                    song: song,
                    thumbnail: thumbnails[song.songId],
                  );
                },
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => EnrollSearchView(query: query));
              },
              child: Text(
                '원하는 노래가 없나요?',
                style: myStyle.textTheme.displayMedium,
              ),
            ),
          ],
        ),
      )
          : Center(
        child: InkWell(
          onTap: () {
            Get.to(() => EnrollSearchView(query: query));
          },
          child: Text(
            errorMessage ?? '원하는 노래가 없나요?',
            style: myStyle.textTheme.displayMedium,
          ),
        ),
      ),
    );
  }
}
