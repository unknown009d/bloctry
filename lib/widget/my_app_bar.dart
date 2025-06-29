import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final String title;
  const MyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 160.0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 48, bottom: 16),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: "Nothing",
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
