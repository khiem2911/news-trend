import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/provider/news_provider.dart';
import 'package:news_app/screens/news_detail.dart';
import 'package:news_app/widgets/filter_news_item.dart';

class ExploreItem extends ConsumerWidget {
  const ExploreItem({super.key, required this.topic, required this.value});

  final String topic;
  final String value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<News> exploreData = ref.read(NewsProvider.notifier).getNewsExplore();
    List<News> filterExplore;

    if (value != '') {
      filterExplore = exploreData
          .where(
              (item) => item.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      filterExplore = exploreData;
    }

    void _onNavigateDetailScreen(News value) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => NewsDetail(news: value)));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trending in $topic',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 16),
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
          height: 15,
        ),
        Column(
            mainAxisSize: MainAxisSize.min,
            children: filterExplore
                .map((item) => FilterNewsItem(
                    news: item,
                    onNavigateDetail: () {
                      _onNavigateDetailScreen(item);
                    }))
                .toList())
      ],
    );
  }
}
