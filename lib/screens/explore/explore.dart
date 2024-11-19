import 'package:flutter/material.dart';

import 'package:news_app/widgets/explore_item.dart';
import 'package:news_app/widgets/search_app_bar.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  String value = '';

  @override
  Widget build(BuildContext context) {
    void _onChange(String data) {
      setState(() {
        value = data;
      });
    }

    return Scaffold(
        appBar: AppBar(
            forceMaterialTransparency: true,
            title: SearchAppBar(
              onChange: _onChange,
              title: 'Topic',
            )),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ExploreItem(
                  topic: 'VietNam',
                  value: value,
                ),
                ExploreItem(
                  topic: 'World',
                  value: value,
                )
              ],
            ),
          ),
        ));
  }
}
