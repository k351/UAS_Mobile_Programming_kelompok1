import 'package:flutter/material.dart';

/// Kelas `SizeConfig` digunakan untuk mengatur konfigurasi ukuran layar aplikasi.
/// Kelas ini menyediakan cara dinamis untuk menghitung ukuran elemen UI berdasarkan
/// ukuran layar perangkat, sehingga membuat desain lebih responsif.
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

    defaultSize =
        (screenWidth < screenHeight ? screenWidth : screenHeight) / 100;
  }
}

double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  return (inputHeight / 812.0) * screenHeight;
}

double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  return (inputWidth / 375.0) * screenWidth;
}
