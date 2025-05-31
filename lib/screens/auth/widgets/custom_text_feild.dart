import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String label;
  final String? hintText;
  final bool isPassword;
  final TextInputType keyboard;
  final IconData? prefixIcon;
  final bool isMobile;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.hintText,
    this.isPassword = false,
    this.keyboard = TextInputType.text,
    this.prefixIcon,
    this.isMobile = true,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      keyboardType: widget.keyboard,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: widget.isMobile ? 12 : 15,
        ),
        labelText: widget.label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 72, 72, 72)),
        prefixIcon: Icon(widget.prefixIcon, color: Colors.white),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 0.5,
            color: secondaryColor.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 1.0,
            color: secondaryColor,
          ),
        ),
      ),
    );
  }
}
