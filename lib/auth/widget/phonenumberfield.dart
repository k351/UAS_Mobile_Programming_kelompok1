import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/utils/size_config.dart';

class PhoneNumberFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(PhoneNumber?)? validator;
  final String? title;

  const PhoneNumberFieldWidget({
    Key? key,
    required this.controller,
    required this.validator,
    required this.title,
  }) : super(key: key);

  @override
  State<PhoneNumberFieldWidget> createState() => _PhoneNumberFieldWidgetState();
}

class _PhoneNumberFieldWidgetState extends State<PhoneNumberFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            widget.title ?? AppConstants.email,
            style: TextStyle(
              color: AppConstants.greyColor6,
              fontSize: getProportionateScreenWidth(12),
              fontFamily: AppConstants.fontInterRegular,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IntlPhoneField(
          controller: widget.controller,
          decoration: const InputDecoration(
            hintText: 'ex. 89623244972',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
          initialCountryCode: 'ID',
          validator: widget.validator,
        ),
      ],
    );
  }
}
