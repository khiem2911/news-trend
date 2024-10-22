import 'package:flutter/material.dart';
import 'package:news_app/model/news.dart';
import 'package:transparent_image/transparent_image.dart';

class NewsItem extends StatelessWidget {
  const NewsItem(
      {super.key, required this.news, required this.onNavigateDetail});

  final void Function() onNavigateDetail;

  final News news;

  @override
  Widget build(BuildContext context) {
    final time = DateTime.parse(news.publishAt);

    return InkWell(
      onTap: onNavigateDetail,
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: InkWell(
          child: Stack(
            children: [
              Hero(
                tag: news.title,
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(news.image),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                  bottom: 20,
                  left: 10,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${news.author}-${time.hour} hours ago',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(news.title,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 12, color: Colors.white))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
