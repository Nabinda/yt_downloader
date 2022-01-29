import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DefaultDisplay extends StatelessWidget {
  const DefaultDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height*0.22,
          ),
          Image.asset('assets/images/youtube.png',
          width: width*0.5,
          ),
          const AutoSizeText('Welcome to YouTube Downloader',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),
          maxLines: 1,)
        ],
      ),
    );
  }
}
