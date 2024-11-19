import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/model/news.dart';
import 'package:intl/intl.dart';
import 'package:news_app/provider/saved_provider.dart';

class NewsDetail extends ConsumerWidget {
  const NewsDetail({super.key, required this.news});

  final News news;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateTime.parse(news.publishAt);
    String monthName = DateFormat.MMMM().format(date);

    void _onAddNews(News news) {
      final wasAdd = ref.read(SavedProvider.notifier).onAddNews(news);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(wasAdd ? 'add sucsessfull' : 'remove sucsessfull')));
    }

    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    color: Colors.orange, shape: BoxShape.circle),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 20,
                    ))),
          ),
          actions: [
            Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    color: Colors.orange, shape: BoxShape.circle),
                child: IconButton(
                    onPressed: () {
                      _onAddNews(news);
                    },
                    icon: const Icon(
                      Icons.bookmark,
                      color: Colors.white,
                      size: 20,
                    ))),
            const SizedBox(
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Colors.orange, shape: BoxShape.circle),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 20,
                      ))),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 20),
          child: Column(
            children: [
              Text(
                news.title,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(news.id),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                        color: Colors.grey, shape: BoxShape.circle),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      '$monthName, ${date.day}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Hero(
                tag: news.title,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(news.image), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10)),
                  width: double.infinity,
                  height: 200,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                news.content,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        )));
  }
}
