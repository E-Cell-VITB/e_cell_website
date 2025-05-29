import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:flutter/material.dart';
import 'package:e_cell_website/screens/ongoing_events/forms/form_field_builder.dart';

class MemberDetailsForm extends StatelessWidget {
  final List<Map<String, dynamic>> participants;
  final Map<String, TextEditingController> controllers;
  final List<RegistrationField> registrationTemplate;
  final bool isMobile;
  final bool isTablet;

  const MemberDetailsForm({
    required this.participants,
    required this.controllers,
    required this.registrationTemplate,
    required this.isMobile,
    required this.isTablet,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: List.generate(participants.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Team Member ${index + 1}',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ...registrationTemplate.map((field) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: CustomFormFieldBuilder.buildFormField(
                    field: field,
                    index: index,
                    isMobile: isMobile,
                    isTablet: isTablet,
                    width: width,
                    controllers: controllers,
                    participants: participants,
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
