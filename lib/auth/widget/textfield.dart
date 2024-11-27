import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/utils/size_config.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.title,
    this.hintText,
    this.suffixIcon,
    this.obscure,
    this.validator,
    super.key,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final Widget? suffixIcon;
  final String? title;
  final bool? obscure;
  final String? Function(String?)? validator;

  @override
  TextFieldWidgetState createState() => TextFieldWidgetState();
}

class TextFieldWidgetState extends State<TextFieldWidget> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            widget.title ?? AppConstants.email,
            style: TextStyle(
              color: Colors.grey,
              fontSize: getProportionateScreenWidth(12),
              fontFamily: AppConstants.fontInterRegular,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(14),
          ),
          keyboardType: widget.keyboardType ?? TextInputType.text,
          obscureText: widget.obscure ?? false,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            focusColor: Colors.grey[100],
            suffixIcon: widget.suffixIcon ?? const SizedBox(),
            hintText: _isFocused ? null : widget.hintText,
            hintStyle: TextStyle(fontSize: getProportionateScreenWidth(14)),
            fillColor: AppConstants.greyColor,
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppConstants.greyColor1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppConstants.clrBlue),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppConstants.greyColor5),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppConstants.clrRed),
            ),
          ),
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          validator: widget.validator,
        ),
      ],
    );
  }
}
