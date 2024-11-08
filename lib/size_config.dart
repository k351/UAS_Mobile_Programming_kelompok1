import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData = const MediaQueryData();
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double defaultSize = 0;
  static Orientation orientation = Orientation.portrait;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData.size.height;
    screenWidth = _mediaQueryData.size.width;
    orientation = _mediaQueryData.orientation;
  }
}

double screenWidthAscpectRatio = SizeConfig.screenWidth;
double screenHeightAscpectRatio = SizeConfig.screenHeight;

double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  return (inputHeight / 812.0) * screenHeight;
}

double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  return (inputWidth / 375.0) * screenWidth;
}

double getChildAspectRatio() {
  // hp kecil
  if (screenWidthAscpectRatio < 360) {
    return screenHeightAscpectRatio / (screenWidthAscpectRatio * 2);
  } 
  // hp sedang
  else if (screenWidthAscpectRatio >= 360 && screenWidthAscpectRatio < 600) {
    return screenHeightAscpectRatio / (screenWidthAscpectRatio * 2.5);
  } 
  // hp besar
  else if (screenWidthAscpectRatio >= 600 && screenWidthAscpectRatio < 900) {
    return screenHeightAscpectRatio / (screenWidthAscpectRatio * 2.5);
  } 
  // hp besar 2x
  else {
    return screenHeightAscpectRatio / (screenWidthAscpectRatio * 2.5);
  }
}
