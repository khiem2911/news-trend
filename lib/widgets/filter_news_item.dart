import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:news_app/model/news.dart';

class FilterNewsItem extends StatelessWidget {
  const FilterNewsItem(
      {super.key, required this.news, required this.onNavigateDetail});

  final News news;
  final void Function() onNavigateDetail;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(news.publishAt);
    String monthName = DateFormat.MMMM().format(date);

    return Column(
      children: [
        InkWell(
          onTap: onNavigateDetail,
          child: Row(
            children: [
              Hero(
                tag: news.title,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(news.image), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10)),
                  width: 120,
                  height: 120,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          width: double.infinity,
          height: 1,
          decoration: const BoxDecoration(color: Colors.grey),
        )
      ],
    );
  }
}
