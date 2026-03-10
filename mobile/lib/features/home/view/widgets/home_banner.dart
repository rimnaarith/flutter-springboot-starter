import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.25,
      width: size.width,
      color: Colors.blueGrey,
      child: const Padding(
        padding: EdgeInsets.only(left: 27),
        child: Stack(
          children: [
            
          ],
        ),
      ),
    );
  }
}