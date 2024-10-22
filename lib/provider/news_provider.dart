import 'package:news_app/model/news.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class NewsNotifier extends StateNotifier<List<News>> {
  NewsNotifier() : super([]);

  void getNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=1c94e87de30c489da32ac2f12a9b1450'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List tempData = data['articles'];
      List<News> newsData = tempData
          .map((value) => News(
              title: value['title'] ?? '',
              image: value['urlToImage'] ??
                  'https://static.vecteezy.com/system/resources/thumbnails/004/141/669/small/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg',
              author: value['author'] ?? '',
              publishAt: value['publishedAt'] ?? '',
              id: value['source'] != null ? value['source']['name'] : '',
              content: value['content'] ?? ''))
          .toList();
      state = [...newsData];
    }
  }

  List<News> getNewsFilter(String value) {
    List<News> filterData;

    if (value == 'Feeds') {
      filterData = state.sublist(4, 9);
    } else if (value == 'Popular') {
      filterData = state.sublist(7, 10);
    } else {
      filterData = state.sublist(13, 16);
    }
    return filterData;
  }

  List<News> getNewsExplore() {
    List<News> filterData;
    Random random = Random();
    int firstNumber = random.nextInt(17) + 1;

    int secondNumber = firstNumber + 3;

    if (secondNumber > 20) {
      secondNumber = firstNumber - 3;
    }
    filterData = state.sublist(firstNumber, secondNumber);
    return filterData;
  }
}

final NewsProvider = StateNotifierProvider<NewsNotifier, List<News>>((ref) {
  return NewsNotifier();
});
