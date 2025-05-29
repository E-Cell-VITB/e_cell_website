import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/enums/registration.dart';
import 'package:flutter/material.dart';

class CustomFormFieldBuilder {
  static Widget buildFormField({
    required RegistrationField field,
    required int index,
    required bool isMobile,
    required bool isTablet,
    required double width,
    required Map<String, TextEditingController> controllers,
    required List<Map<String, dynamic>> participants,
  }) {
    final controllerKey = '${index}_${field.fieldName}';
    if (!controllers.containsKey(controllerKey)) {
      controllers[controllerKey] = TextEditingController(
          text: participants[index][field.fieldName]?.toString() ?? '');
    }
    final controller = controllers[controllerKey]!;
    final capitalizedFieldName =
        '${field.fieldName[0].toUpperCase()}${field.fieldName.substring(1)}';

    InputDecoration inputDecoration({String? labelText}) {
      return InputDecoration(
        labelText: labelText ?? capitalizedFieldName,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );
    }

    String? validator(dynamic value) {
      if (field.isRequired) {
        if (value == null || (value is String && value.isEmpty)) {
          return '$capitalizedFieldName is required';
        }
      }
      if (value != null && value is String && value.isNotEmpty) {
        switch (field.inputType.toLowerCase()) {
          case 'number':
            final number = num.tryParse(value);
            if (number == null) {
              return '$capitalizedFieldName must be a valid number';
            }
            break;
          case 'email':
            final emailRegex =
                RegExp(r'^[a-zA-Z0-9._%+-]+@(vishnu\.edu\.in|gmail\.com)$');
            if (!emailRegex.hasMatch(value)) {
              return '$capitalizedFieldName must be a valid email';
            }
            break;
          case 'phonenumber':
            if (value.length != 10 || !RegExp(r'^\d{10}$').hasMatch(value)) {
              return '$capitalizedFieldName must be exactly 10 digits';
            }
            break;
        }
      }
      return null;
    }

    switch (field.inputType.toLowerCase()) {
      case 'boolean':
        return DropdownButtonFormField<bool>(
          decoration: inputDecoration(),
          dropdownColor: Colors.black87,
          style: const TextStyle(color: Colors.white),
          value: participants[index][field.fieldName] is bool
              ? participants[index][field.fieldName]
              : null,
          items: const [
            DropdownMenuItem<bool>(
              value: true,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text('True', style: TextStyle(color: Colors.white)),
              ),
            ),
            DropdownMenuItem<bool>(
              value: false,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text('False', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
          onChanged: (bool? value) {
            if (value != null) {
              participants[index][field.fieldName] = value;
            }
          },
          validator: validator,
        );

      case 'department':
        return SizedBox(
          width: isMobile ? width * 0.8 : width * 0.6,
          child: DropdownButtonFormField<Department>(
            isExpanded: true,
            decoration: inputDecoration(
              labelText: field.fieldName.isNotEmpty
                  ? capitalizedFieldName
                  : 'Default Label',
            ),
            dropdownColor: Colors.black87,
            style: const TextStyle(color: Colors.white),
            value: participants[index][field.fieldName] != null
                ? Department.values.firstWhere(
                    (e) => e.toString() == participants[index][field.fieldName],
                    orElse: () => Department.other,
                  )
                : null,
            items: Department.values.map((Department dept) {
              return DropdownMenuItem<Department>(
                value: dept,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    dept.toString().split('.').last,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: isMobile
                          ? 12
                          : isTablet
                              ? 14
                              : 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (Department? value) {
              if (value != null) {
                participants[index][field.fieldName] = value.toString();
              }
            },
            validator: validator,
          ),
        );

      case 'year':
        return DropdownButtonFormField<int>(
          decoration: inputDecoration(),
          dropdownColor: Colors.black87,
          style: const TextStyle(color: Colors.white),
          value: participants[index][field.fieldName] is int
              ? participants[index][field.fieldName]
              : null,
          items: List.generate(
            4,
            (i) => DropdownMenuItem<int>(
              value: i + 1,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontSize: isMobile
                        ? 12
                        : isTablet
                            ? 14
                            : 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          onChanged: (int? value) {
            if (value != null) {
              participants[index][field.fieldName] = value;
            }
          },
          validator: validator,
        );

      default:
        return TextFormField(
          controller: controller,
          decoration: inputDecoration(),
          style: const TextStyle(color: Colors.white),
          textDirection: TextDirection.ltr,
          keyboardType: field.inputType.toLowerCase() == 'number'
              ? TextInputType.number
              : field.inputType.toLowerCase() == 'email'
                  ? TextInputType.emailAddress
                  : field.inputType.toLowerCase() == 'phonenumber'
                      ? TextInputType.phone
                      : TextInputType.text,
          validator: validator,
          onChanged: (value) {
            if (field.inputType.toLowerCase() == 'number') {
              participants[index][field.fieldName] =
                  value.isNotEmpty ? num.tryParse(value) ?? value : value;
            } else {
              participants[index][field.fieldName] = value;
            }
          },
        );
    }
  }
}
