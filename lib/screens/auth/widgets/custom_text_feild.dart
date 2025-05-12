
import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String label;
  final Widget? suffix;
  final bool isobsure;
  final TextInputType keyboard;
  final IconData prefixicon;  

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.isobsure=false,
    this.keyboard=TextInputType.name,
    required this.prefixicon,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(prefixicon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: secondaryColor.withOpacity(0.5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: secondaryColor.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: secondaryColor),
          ),
          suffixIcon: suffix,
        ),
        obscureText: isobsure,
        keyboardType:keyboard,
        
        validator: validator);
  }
}