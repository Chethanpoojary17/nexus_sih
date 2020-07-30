import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SliderCustom extends StatelessWidget {
  var slider = [
    'https://i1.wp.com/blogsyear.com/wp-content/uploads/2020/03/cronoa-virus-updated.png?fit=875%2C395&ssl=1'
    'https://th.bing.com/th/id/OIP.rmff1CN9Brw6lRlaPUnAAgHaD4?pid=Api&rs=1',
    'http://www.sarkarimirror.com/wp-content/uploads/2017/08/MIN-OF-FINANCE.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
        items: slider
            .map((item) => Container(
                  child: Center(
                      child:
                          Image.network(item, fit: BoxFit.cover, width: 1000)),
                ))
            .toList(),
      ),
    );
  }
}
