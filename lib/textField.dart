import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.title,
    this.hintText,
    this.suffixIcon,
    this.obscure,
    Key? key,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final Widget? suffixIcon;
  final String? title;
  bool? obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            title ?? AppConstants.email,
            style: TextStyle(
              color: Colors.grey,
              fontSize: getProportionateScreenWidth(12),
              fontFamily: AppConstants.fontInterRegular,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(14),
          ),
          keyboardType: keyboardType ?? TextInputType.text,
          obscureText: obscure ?? false,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            focusColor: Colors.grey[100],
            suffixIcon: suffixIcon ?? SizedBox(),
            hintText: hintText ?? '',
            hintStyle: TextStyle(fontSize: getProportionateScreenWidth(14)),
            fillColor: AppConstants.greyColor,
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: AppConstants.greyColor3)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: AppConstants.greyColor3)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: AppConstants.greyColor3)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: AppConstants.clrRed)),
          ),
          textInputAction: textInputAction ?? TextInputAction.next,
        ),
      ],
    );
  }
}
