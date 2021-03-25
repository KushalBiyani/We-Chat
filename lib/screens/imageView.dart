import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String url;
  final String tag;
  DetailScreen(this.url, this.tag);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: tag,
            child: Image(
              image: CachedNetworkImageProvider(url),
              fit: BoxFit.contain,
              width: 350,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
