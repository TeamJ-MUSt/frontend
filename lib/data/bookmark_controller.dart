import 'package:get/get.dart';

class BookmarkController extends GetxController {
  var bookmarkedSongs = <int>[].obs; // 북마크된 songId 리스트

  void toggleBookmark(int songId) {
    if (bookmarkedSongs.contains(songId)) {
      bookmarkedSongs.remove(songId);
    } else {
      bookmarkedSongs.add(songId);
    }
    print(bookmarkedSongs);
  }

  bool isBookmarked(int songId) {
    return bookmarkedSongs.contains(songId);
  }
}
