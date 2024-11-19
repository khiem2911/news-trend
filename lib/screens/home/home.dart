import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/provider/news_provider.dart';
import 'package:news_app/provider/user_provider.dart';
import 'package:news_app/screens/news/news_detail.dart';
import 'package:news_app/widgets/filter_news_item.dart';
import 'package:news_app/widgets/news_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _currentIndex = 0;
  var _currentCategories = 'Feeds';

  @override
  void initState() {
    super.initState();
    ref.read(NewsProvider.notifier).getNews();
  }

  @override
  Widget build(BuildContext context) {
    final newsData = ref.watch(NewsProvider);
    final user = ref.read(UserProvider);
    List<News> breakingNews = [];
    List<News> filterNews = [];
    Widget? content;

    void _onFilterCategories(String category) {
      List<News> filterCategories =
          ref.read(NewsProvider.notifier).getNewsFilter(category);
      setState(() {
        _currentCategories = category;
        filterNews = filterCategories;
      });
    }

    void _onNavigateDetailScreen(News value) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => NewsDetail(news: value)));
    }

    if (newsData.isEmpty) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      breakingNews = newsData.sublist(0, 3);
      filterNews =
          ref.read(NewsProvider.notifier).getNewsFilter(_currentCategories);
      content = Padding(
        padding:
            const EdgeInsets.only(top: 26, left: 16, right: 16, bottom: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Breaking News',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 16, fontFamily: 'Lato'),
                ),
                Text(
                  'See More',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.blue),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            CarouselSlider(
                items: breakingNews.map((item) {
                  return Builder(builder: (BuildContext context) {
                    return NewsItem(
                        onNavigateDetail: () {
                          _onNavigateDetailScreen(item);
                        },
                        news: item);
                  });
                }).toList(),
                options: CarouselOptions(
                    height: 250,
                    viewportFraction: 0.9,
                    autoPlay: true,
                    clipBehavior: Clip.none,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    })),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: breakingNews.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: _currentIndex == entry.key
                          ? Colors.orange
                          : Colors.grey,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                padding:
                    const EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.orange),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            _onFilterCategories('Feeds');
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 6, bottom: 6, left: 30, right: 30),
                            decoration: BoxDecoration(
                                color: _currentCategories == 'Feeds'
                                    ? Colors.white
                                    : null,
                                borderRadius: BorderRadius.circular(100)),
                            child: Text(
                              'Feeds',
                              style: TextStyle(
                                color: _currentCategories == 'Feeds'
                                    ? Colors.orange
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _onFilterCategories('Popular');
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 6, bottom: 6, left: 30, right: 30),
                            decoration: BoxDecoration(
                                color: _currentCategories == 'Popular'
                                    ? Colors.white
                                    : null,
                                borderRadius: BorderRadius.circular(100)),
                            child: Text('Popular',
                                style: TextStyle(
                                  color: _currentCategories == 'Popular'
                                      ? Colors.orange
                                      : Colors.white,
                                )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _onFilterCategories('Following');
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 6, bottom: 6, left: 30, right: 30),
                            decoration: BoxDecoration(
                                color: _currentCategories == 'Following'
                                    ? Colors.white
                                    : null,
                                borderRadius: BorderRadius.circular(100)),
                            child: Text('Following',
                                style: TextStyle(
                                  color: _currentCategories == 'Following'
                                      ? Colors.orange
                                      : Colors.white,
                                )),
                          ),
                        )
                      ],
                    ),
                  ],
                )),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: filterNews.length,
                  itemBuilder: (ctx, index) {
                    return FilterNewsItem(
                        onNavigateDetail: () {
                          _onNavigateDetailScreen(filterNews[index]);
                        },
                        news: filterNews[index]);
                  }),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: CircleAvatar(
                backgroundImage: user['userImage'] != null
                    ? NetworkImage(user['userImage']!)
                    : null,
              ),
            ),
            title: const Text('Good Morning,'),
            subtitle: Text(
              user['name'] ?? '',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 14),
            ),
          ),
        ),
        body: content);
  }
}
