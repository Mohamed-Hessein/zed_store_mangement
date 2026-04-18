import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';

class CustomTexTFromFeild extends StatefulWidget {
  final String hint;
  final String image;
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? vaildator;
  final bool ispass;

  const CustomTexTFromFeild({
    super.key,
    required this.hint,
    required this.label,
    required this.ispass,
    this.controller,
    this.vaildator,
    required this.image,
  });

  @override
  State<CustomTexTFromFeild> createState() => _CustomTexTFromFeildState();
}

class _CustomTexTFromFeildState extends State<CustomTexTFromFeild> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppStyles.text14grey,
        ),
        SizedBox(height: 8.h),         TextFormField(
          controller: widget.controller,
          validator: widget.vaildator,
          obscureText: widget.ispass ? _isObscured : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFfECE6F1),

            hintText: widget.hint,
            hintStyle: AppStyles.text14grey.copyWith(fontSize: 12.sp),

            prefixIcon: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(widget.image, width: 23, height: 23),
            ),

            suffixIcon: widget.ispass
                ? IconButton(
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
              icon: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
                size: 20,
              ),
            )
                : const SizedBox.shrink(),

            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
