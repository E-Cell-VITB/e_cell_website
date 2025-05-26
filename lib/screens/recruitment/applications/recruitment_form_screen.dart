import 'package:e_cell_website/backend/models/recruitment_form.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:e_cell_website/services/providers/recruitment_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class RecruitmentFormScreen extends StatefulWidget {
  final String recruitmentId;
  final String dept;

  const RecruitmentFormScreen({
    super.key,
    required this.recruitmentId,
    required this.dept,
  });

  @override
  State<RecruitmentFormScreen> createState() => _RecruitmentFormScreenState();
}

class _RecruitmentFormScreenState extends State<RecruitmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _yearOfStudyController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _departmentController = TextEditingController();
  final _previousExperienceController = TextEditingController();
  final _resumeDriveLinkController = TextEditingController();
  final _linkedInProfileController = TextEditingController();
  final _whyEcellController = TextEditingController();
  final _clubInvolvementController = TextEditingController();

  int _currentStep = 0;

  bool _hasPreviousExperience = false;
  bool _hasClubInvolvement = false;

  final List<String> _yearOptions = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];
  final List<String> _departmentOptions = [
    'CSE',
    'IT',
    'AI&ML',
    'AI&DS',
    'ECE',
    'MECH',
    'CIVIL',
    'CHEM',
    'EEE',
    'Other',
  ];

  bool _isLoading = false;
  bool _isSubmitted = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _yearOfStudyController.dispose();
    _registrationNumberController.dispose();
    _departmentController.dispose();
    _previousExperienceController.dispose();
    _resumeDriveLinkController.dispose();
    _linkedInProfileController.dispose();
    _whyEcellController.dispose();
    _clubInvolvementController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final recruitmentForm = RecruitmentForm(
        recruitmentId: widget.recruitmentId,
        name: _nameController.text.trim(),
        emailAddress: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        yearOfStudy: _yearOfStudyController.text,
        registrationNumber: _registrationNumberController.text.trim(),
        department: _departmentController.text,
        previousExperience: _hasPreviousExperience
            ? _previousExperienceController.text.trim()
            : null,
        resumeDriveLink: _resumeDriveLinkController.text.trim(),
        linkedInProfile: _linkedInProfileController.text.trim(),
        whyEcell: _whyEcellController.text.trim(),
        clubInvolvement:
            _hasClubInvolvement ? _clubInvolvementController.text.trim() : null,
      );

      final recruitmentProvider =
          Provider.of<RecruitmentProvider>(context, listen: false);

      final applicationId = await recruitmentProvider.submitApplication(
        recruitmentForm,
        widget.dept,
      );

      if (applicationId != null) {
        setState(() {
          _isSubmitted = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = recruitmentProvider.errorMessage ??
              'Failed to submit application';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to submit application: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _nextStep() {
    bool isCurrentStepValid = true;

    if (_currentStep == 0) {
      isCurrentStepValid = _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _isValidEmail(_emailController.text) &&
          _phoneController.text.isNotEmpty;
    } else if (_currentStep == 1) {
      isCurrentStepValid = _yearOfStudyController.text.isNotEmpty &&
          _registrationNumberController.text.isNotEmpty &&
          _departmentController.text.isNotEmpty;
    } else if (_currentStep == 2 && _hasPreviousExperience) {
      isCurrentStepValid = _previousExperienceController.text.isNotEmpty;
    } else if (_currentStep == 3 && _hasClubInvolvement) {
      isCurrentStepValid = _clubInvolvementController.text.isNotEmpty;
    }

    if (!_isValidEmail(_emailController.text)) {
      showCustomToast(
        title: "Incorrect Email",
        description: "Only Vishnu Emails are allowed..",
      );
      return;
    }

    if (!isCurrentStepValid) {
      showCustomToast(
        title: "Form Incomplete",
        description: "Please fill all  fields to move next.",
      );
      return;
    }

    if (_currentStep < 4) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@vishnu\.edu\.in$');

    return emailRegExp.hasMatch(email.trim());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ParticleBackground(
        child: Center(
      child: SizedBox(
        width: size.width > 600 ? size.width * 0.65 : size.width * 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width > 600 ? size.width * 0.65 : size.width * 0.75,
                child: LinearGradientText(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Tell us about yourself and why you'd like to join E-Cell.",
                    style: TextStyle(fontSize: size.width > 600 ? 24 : 16),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              _isSubmitted ? _buildSuccessScreen() : _buildForm(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildSuccessScreen() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: secondaryColor,
              size: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              'Application Submitted Successfully!',
              style: TextStyle(
                color: primaryColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Thank you for applying to E-cell. We will review your application and get back to you soon.',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                'Return to Home',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          physics: const ClampingScrollPhysics(),
          currentStep: _currentStep,
          onStepTapped: (step) => setState(() => _currentStep = step),
          controlsBuilder: (context, details) {
            return _buildStepperControls(details.stepIndex);
          },
          steps: [
            _buildPersonalInfoStep(),
            _buildAcademicInfoStep(),
            _buildExperienceStep(),
            _buildInvolvementStep(),
            _buildMotivationStep(),
          ],
        ),
      ),
    );
  }

  Step _buildPersonalInfoStep() {
    return Step(
      title: const Text('Personal Information',
          style: TextStyle(color: primaryColor)),
      isActive: _currentStep >= 0,
      content: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          _buildTextField(
            controller: _nameController,
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            labelText: 'Email Address',
            hintText: 'Please enter college email only',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter college email only';
              }
              if (!_isValidEmail(value)) {
                return 'Please enter college email only';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneController,
            labelText: 'Phone Number',
            hintText: 'Enter your phone number',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Step _buildAcademicInfoStep() {
    return Step(
      title: const Text('Academic Information',
          style: TextStyle(color: primaryColor)),
      isActive: _currentStep >= 1,
      content: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          _buildDropdownField(
            controller: _yearOfStudyController,
            labelText: 'Year of Study',
            hintText: 'Select your current year',
            icon: Icons.school,
            items: _yearOptions,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _registrationNumberController,
            labelText: 'Registration Number',
            hintText: 'Enter your registration number',
            icon: Icons.confirmation_number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your registration number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            controller: _departmentController,
            labelText: 'Department',
            hintText: 'Select your department',
            icon: Icons.business,
            items: _departmentOptions,
          ),
        ],
      ),
    );
  }

  Step _buildExperienceStep() {
    return Step(
      title: const Text('Experience', style: TextStyle(color: primaryColor)),
      isActive: _currentStep >= 2,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSwitchField(
            title: 'Do you have any previous experience?',
            value: _hasPreviousExperience,
            onChanged: (value) {
              setState(() {
                _hasPreviousExperience = value;
              });
            },
          ),
          const SizedBox(height: 16),
          if (_hasPreviousExperience) ...[
            _buildTextField(
              controller: _previousExperienceController,
              labelText: 'Previous Experience',
              hintText: 'Describe your previous experience',
              icon: Icons.work,
              maxLines: 3,
              validator: (value) {
                if (_hasPreviousExperience &&
                    (value == null || value.isEmpty)) {
                  return 'Please describe your experience';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],
          _buildTextField(
            controller: _resumeDriveLinkController,
            labelText: 'Resume Drive Link (Optional)',
            hintText: 'Enter Google Drive link to your resume',
            icon: Icons.link,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _linkedInProfileController,
            labelText: 'LinkedIn Profile (Optional)',
            hintText: 'Enter your LinkedIn profile URL',
            icon: Icons.public,
          ),
        ],
      ),
    );
  }

  Step _buildInvolvementStep() {
    return Step(
      title:
          const Text('Club Involvement', style: TextStyle(color: primaryColor)),
      isActive: _currentStep >= 3,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSwitchField(
            title: 'Are you involved in any clubs or organizations?',
            value: _hasClubInvolvement,
            onChanged: (value) {
              setState(() {
                _hasClubInvolvement = value;
              });
            },
          ),
          const SizedBox(height: 16),
          if (_hasClubInvolvement) ...[
            _buildTextField(
              controller: _clubInvolvementController,
              labelText: 'Club Involvement',
              hintText: 'Describe your involvement in clubs and organizations',
              icon: Icons.group,
              maxLines: 3,
              validator: (value) {
                if (_hasClubInvolvement && (value == null || value.isEmpty)) {
                  return 'Please describe your club involvement';
                }
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }

  Step _buildMotivationStep() {
    return Step(
      title: const Text('Motivation', style: TextStyle(color: primaryColor)),
      isActive: _currentStep >= 4,
      content: Column(
        children: [
          _buildTextField(
            controller: _whyEcellController,
            labelText: 'Why E-cell?',
            hintText: 'Tell us why you want to join E-cell',
            icon: Icons.lightbulb,
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please share your motivation for joining E-cell';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ElevatedButton(
            onPressed: _isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: primaryColor)
                : const Text('Submit Application',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperControls(int stepIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (stepIndex > 0)
            OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: secondaryColor),
              ),
              child:
                  const Text('Back', style: TextStyle(color: secondaryColor)),
            )
          else
            const SizedBox(),
          if (stepIndex < 4)
            ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
              ),
              child: const Text('Next', style: TextStyle(color: primaryColor)),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[600]),
        labelStyle: const TextStyle(color: primaryColor),
        prefixIcon: Icon(icon, color: secondaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: secondaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[900],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: const TextStyle(color: primaryColor),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    required List<String> items,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: primaryColor),
        prefixIcon: Icon(icon, color: secondaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: secondaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[900],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      hint: Text(
        hintText,
        style: TextStyle(color: Colors.grey[600]),
      ),
      dropdownColor: Colors.grey[800],
      style: const TextStyle(color: primaryColor),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            controller.text = newValue;
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an option';
        }
        return null;
      },
    );
  }

  Widget _buildSwitchField({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 16,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: secondaryColor,
          activeTrackColor: secondaryColor.withOpacity(0.5),
        ),
      ],
    );
  }
}
