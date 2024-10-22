import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/provider/user_provider.dart';

class SearchAppBar extends ConsumerWidget {
  const SearchAppBar({super.key, required this.onChange, required this.title});

  final void Function(String value) onChange;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, String>? user = ref.read(UserProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 50,
          height: 50,
          child: CircleAvatar(
            backgroundImage: NetworkImage(user!['userImage']!),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 16, right: 10),
          width: 200,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.orange, borderRadius: BorderRadius.circular(100)),
          child: TextField(
              onChanged: (value) {
                onChange(value);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Search by "$title"',
                labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              )),
        )
      ],
    );
  }
}
