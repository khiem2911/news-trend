import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/provider/saved_provider.dart';
import 'package:news_app/screens/news/news_detail.dart';
import 'package:news_app/widgets/filter_news_item.dart';
import 'package:news_app/widgets/search_app_bar.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() {
    return _SavedScreenState();
  }
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(SavedProvider.notifier).fetchNews();
  }

  void _onNavigateDetailScreen(News value) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => NewsDetail(news: value)));
  }

  String searchValue = '';

  void _onChange(String value) {
    setState(() {
      searchValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<News> saveNews = ref.watch(SavedProvider);

    final filterNews = saveNews
        .where((n) => n.title.toLowerCase().contains(searchValue.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
          forceMaterialTransparency: true,
          title: SearchAppBar(
            title: 'Title',
            onChange: _onChange,
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Saved Pages',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            filterNews.isNotEmpty
                ? Column(
                    children: filterNews
                        .map((value) => FilterNewsItem(
                            news: value,
                            onNavigateDetail: () {
                              _onNavigateDetailScreen(value);
                            }))
                        .toList(),
                  )
                : const Center(
                    child: Text('These is no saved pages here'),
                  )
          ],
        ),
      ),
    );
  }
}
