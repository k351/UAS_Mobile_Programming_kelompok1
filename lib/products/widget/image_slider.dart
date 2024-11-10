import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageSlider extends StatefulWidget {
  final Function(int) onChange;
  final String image;

  const ImageSlider({
    super.key,
    required this.image,
    required this.onChange,
  });

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          if (index <= 5) {
            widget.onChange(index);
            setState(() {
              _currentPage = index;
            });
          }
        },
        itemCount: 5,
        itemBuilder: (context, index) {
          return Hero(
            tag: widget.image,
            child: Image.asset(widget.image),
          );
        },
      ),
    );
  }
}
