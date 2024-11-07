import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/products/widget/image_slider.dart';
import 'package:uas_flutter/products/widget/item_details.dart';
import 'package:uas_flutter/products/widget/product_detail_appbar.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/size_config.dart';

class DetailScreen extends StatefulWidget {
  static const String routeName = 'details';
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int currentimage = 0;
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppConstants.clrBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Untuk share dan favorit
              DetailAppBar(),
              // Image slider
              ImageSlider(
                onChange: (index) {
                  setState(() {
                    print(index);
                    currentimage = index;
                  });
                },
                image: widget.product.image,
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => AnimatedContainer(
                    duration: const Duration(microseconds: 300),
                    width: currentimage == index ? 15 : 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currentimage == index
                          ? Colors.black
                          : Colors.transparent,
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(20),
                    right: getProportionateScreenWidth(20),
                    top: getProportionateScreenHeight(20),
                    bottom: getProportionateScreenHeight(100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ItemsDetails(product: widget.product)],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
