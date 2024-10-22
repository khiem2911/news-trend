import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({super.key, required this.count, required this.type});

  final int count;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 74,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.orange),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(type, style: const TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}
