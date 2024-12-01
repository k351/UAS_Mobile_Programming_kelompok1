import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';

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
  int currentPage = 0;

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
              currentPage = index;
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

class ProductImageIndicators extends StatelessWidget {
  final int currentImage;

  const ProductImageIndicators({
    super.key,
    required this.currentImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: currentImage == index ? 15 : 8,
          height: 8,
          margin: const EdgeInsets.only(right: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: currentImage == index
                ? AppConstants.clrBlack
                : Colors.transparent,
            border: Border.all(color: AppConstants.clrBlack),
          ),
        ),
      ),
    );
  }
}
