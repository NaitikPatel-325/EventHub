import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  final List<String> imgList;
  
  const Carousel({super.key, required this.imgList});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: imgList.length,
      itemBuilder: (context, index, realIndex) {
        final imgUrl = imgList[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.asset(imgUrl, fit: BoxFit.cover),
          ),
        );
      },
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16/9,
        viewportFraction: 0.9,
      ),
    );
  }
}
