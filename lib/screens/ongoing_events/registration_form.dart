import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:e_cell_website/services/enums/registration.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class OngoingEventRegister extends StatefulWidget {
  final String eventId;

  const OngoingEventRegister({required this.eventId, super.key});

  @override
  _OngoingEventRegisterState createState() => _OngoingEventRegisterState();
}

class _OngoingEventRegisterState extends State<OngoingEventRegister> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> participants = [{}];
  bool _isSubmitting = false;
  bool _isCheckingRegistration = false;

  // Team event stepper state
  RegistrationStage _currentStage = RegistrationStage.teamDetails;
  String? _teamName;
  int? _teamSize;
  final _teamNameController = TextEditingController();

  // Map to store TextEditingControllers for member details
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    _teamNameController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _moveToNextStage(BuildContext context) {
    if (_currentStage == RegistrationStage.teamDetails) {
      if (_formKey.currentState!.validate()) {
        if (_teamNameController.text.isEmpty) {
          showCustomToast(
            title: 'Required',
            description: 'Team name is required',
            type: ToastificationType.error,
          );
          return;
        }
        if (_teamSize == null) {
          showCustomToast(
            title: 'Required',
            description: 'Please select a team size',
            type: ToastificationType.error,
          );
          return;
        }
        setState(() {
          _teamName = _teamNameController.text;
          participants = List.generate(_teamSize!, (_) => <String, dynamic>{});
          _currentStage = RegistrationStage.memberDetails;
        });
      }
    } else if (_currentStage == RegistrationStage.memberDetails) {
      if (_formKey.currentState!.validate()) {
        final provider =
            Provider.of<OngoingEventProvider>(context, listen: false);
        final event = provider.currentEvent;
        if (event == null) {
          showCustomToast(
            title: 'Error',
            description: 'Event data is not loaded yet. Please wait.',
            type: ToastificationType.error,
          );
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleRegistration(context, event);
        });
      }
    }
  }

  void _moveToPreviousStage() {
    if (_currentStage == RegistrationStage.teamDetails) {
      Navigator.pop(context);
    } else if (_currentStage == RegistrationStage.memberDetails) {
      setState(() {
        _currentStage = RegistrationStage.teamDetails;
        participants = [{}];
        // Clear controllers for member details
        _controllers.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;

    return ChangeNotifierProvider(
      create: (context) =>
          OngoingEventProvider()..fetchEventById(widget.eventId),
      child: Scaffold(
        body: Container(
          child: Consumer<OngoingEventProvider>(
            builder: (context, provider, child) {
              if (provider.isLoadingEvents) {
                return const Center(
                    child: CircularProgressIndicator(color: secondaryColor));
              }
              if (provider.errorEvents != null) {
                return Center(
                  child: Text(
                    'Error: ${provider.errorEvents}',
                    style: TextStyle(
                        fontSize: isMobile
                            ? 14
                            : isTablet
                                ? 16
                                : 18,
                        color: Colors.redAccent),
                  ),
                );
              }
              final event = provider.currentEvent;
              if (event == null) {
                return Center(
                  child: Text(
                    'Event not found',
                    style: TextStyle(
                        fontSize: isMobile
                            ? 16
                            : isTablet
                                ? 18
                                : 20,
                        color: Colors.white),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile
                        ? 12.0
                        : isTablet
                            ? 18.0
                            : 24.0),
                    child: GradientBox(
                      radius: 18,
                      width: isMobile ? screenWidth * 0.9 : screenWidth * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              LinearGradientText(
                                child: Text(
                                  '${event.name} Registration Form',
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (provider.errorRegistration != null)
                                Text(
                                  provider.errorRegistration!,
                                  style: TextStyle(
                                      fontSize: isMobile
                                          ? 14
                                          : isTablet
                                              ? 16
                                              : 18,
                                      color: Colors.redAccent),
                                ),
                              if (event.isTeamEvent) ...[
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      // Custom Stepper Indicator
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            _buildStepIndicator(
                                              RegistrationStage.teamDetails,
                                              'Team Details',
                                              Icons.group,
                                            ),
                                            _buildStepConnector(
                                                _currentStage.index >=
                                                    RegistrationStage
                                                        .memberDetails.index),
                                            _buildStepIndicator(
                                              RegistrationStage.memberDetails,
                                              'Member Details',
                                              Icons.person,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                          height: 1,
                                          color: Colors.white.withOpacity(0.2)),
                                      // Step Content
                                      Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: _buildCurrentStageContent(
                                            event, isMobile, isTablet),
                                      ),
                                      // Navigation Buttons
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildGradientButton(
                                              text: _currentStage ==
                                                      RegistrationStage
                                                          .teamDetails
                                                  ? 'CANCEL'
                                                  : 'BACK',
                                              onPressed: _moveToPreviousStage,
                                              isMobile: isMobile,
                                              isTablet: isTablet,
                                            ),
                                            _buildGradientButton(
                                              text: _currentStage ==
                                                      RegistrationStage
                                                          .memberDetails
                                                  ? 'SUBMIT'
                                                  : 'NEXT',
                                              onPressed: (_isSubmitting ||
                                                      _isCheckingRegistration ||
                                                      provider.currentEvent ==
                                                          null)
                                                  ? null
                                                  : () =>
                                                      _moveToNextStage(context),
                                              isMobile: isMobile,
                                              isTablet: isTablet,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      ...event.registrationTemplate
                                          .map((field) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: _buildFormField(
                                              field, 0, isMobile, isTablet),
                                        );
                                      }),
                                      const SizedBox(height: 16),
                                      if (_isSubmitting ||
                                          _isCheckingRegistration)
                                        const CircularProgressIndicator(
                                            color: Colors.amberAccent)
                                      else
                                        _buildGradientButton(
                                          text: 'Submit Registration',
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                _handleRegistration(
                                                    context, event);
                                              });
                                            }
                                          },
                                          isMobile: isMobile,
                                          isTablet: isTablet,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStageContent(
      OngoingEvent event, bool isMobile, bool isTablet) {
    switch (_currentStage) {
      case RegistrationStage.teamDetails:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _teamNameController,
                decoration: InputDecoration(
                  labelText: 'Team Name',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                textDirection: TextDirection.ltr,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Team name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Team Size',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownColor: Colors.black87,
                style: const TextStyle(color: Colors.white),
                value: _teamSize,
                items: List.generate(
                  event.maxTeamSize,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _teamSize = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a team size';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      case RegistrationStage.memberDetails:
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
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  ...event.registrationTemplate.map((field) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildFormField(field, index, isMobile, isTablet),
                    );
                  }),
                ],
              ),
            );
          }),
        );
    }
  }

  Widget _buildStepIndicator(
      RegistrationStage stage, String label, IconData icon) {
    final isActive = _currentStage == stage;
    final isCompleted = _currentStage.index > stage.index;

    return InkWell(
      onTap: () {
        if (_currentStage.index >= stage.index) {
          setState(() {
            _currentStage = stage;
          });
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.amberAccent
                  : isCompleted
                      ? Colors.amberAccent.withOpacity(0.7)
                      : Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.black)
                  : Icon(icon, color: isActive ? Colors.black : Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.amberAccent : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      color: isActive ? Colors.amberAccent : Colors.white.withOpacity(0.3),
    );
  }

  Future<void> _handleRegistration(
      BuildContext context, OngoingEvent event) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _isCheckingRegistration = true);
    });

    try {
      final provider =
          Provider.of<OngoingEventProvider>(context, listen: false);
      final isRegistered = await provider.checkUserRegistration(widget.eventId);

      if (isRegistered) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCustomToast(
              title: "Already Registered",
              description: "You are already registered for this event.",
              type: ToastificationType.info);
          context.go('/ongoingEvents');
        });
        return;
      }

      await _submitRegistration(context, event);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomToast(
            title: "Error",
            description: "Failed to check registration: $e",
            type: ToastificationType.error);
      });
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _isCheckingRegistration = false);
      });
    }
  }

  Future<void> _submitRegistration(
      BuildContext context, OngoingEvent event) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _isSubmitting = true);
    });

    try {
      final provider =
          Provider.of<OngoingEventProvider>(context, listen: false);
      await provider.submitRegistration(
        widget.eventId,
        event.isTeamEvent ? _teamName : 'individual',
        participants,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomToast(
          title: 'Registration Successful',
          description:
              'Stay tuned to our website for further updates of the ${event.name} event.',
          type: ToastificationType.success,
        );
        context.go('/onGoingEvents');
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomToast(
          title: 'Registration Error',
          description: 'Failed to register: $e',
          type: ToastificationType.error,
        );
      });
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _isSubmitting = false);
      });
    }
  }

  Widget _buildFormField(
      RegistrationField field, int index, bool isMobile, bool isTablet) {
    // Create a unique key for the controller based on index and field name
    final controllerKey = '${index}_${field.fieldName}';
    if (!_controllers.containsKey(controllerKey)) {
      _controllers[controllerKey] = TextEditingController(
          text: participants[index][field.fieldName]?.toString() ?? '');
    }
    final controller = _controllers[controllerKey]!;

    // Capitalize field name for display
    final capitalizedFieldName =
        '${field.fieldName[0].toUpperCase()}${field.fieldName.substring(1)}';

    // Common input decoration
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

    // Validator function for all field types
    String? validator(dynamic value) {
      // Check for required fields
      if (field.isRequired) {
        if (value == null || (value is String && value.isEmpty)) {
          return '$capitalizedFieldName is required';
        }
      }

      // Type-specific validation
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
              return '$capitalizedFieldName must be a valid email (e.g., @vishnu.edu.in or @gmail.com)';
            }
            break;
          case 'phonenumber':
            if (value.length != 10 || !RegExp(r'^\d{10}$').hasMatch(value)) {
              return '$capitalizedFieldName must be exactly 10 digits';
            }
            break;
          // case 'text':
          //   // Optional: Add specific validation for text (e.g., max length)
          //   if (value.length > 100) {
          //     return '$capitalizedFieldName must be 100 characters or less';
          //   }
          //   break;
        }
      }
      return null;
    }

    // Handle different field types
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
                child: Text(
                  'True',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            DropdownMenuItem<bool>(
              value: false,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  'False',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
          onChanged: (bool? value) {
            if (value != null) {
              setState(() {
                participants[index][field.fieldName] = value;
              });
            }
          },
          validator: (bool? value) => validator(value),
        );

      case 'department':
        double width = MediaQuery.of(context).size.width;
        return SizedBox(
          width: isMobile ? 250 : width * 0.6,
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
                setState(() {
                  participants[index][field.fieldName] = value.toString();
                });
              }
            },
            validator: (Department? value) => validator(value),
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
              setState(() {
                participants[index][field.fieldName] = value;
              });
            }
          },
          validator: (int? value) => validator(value),
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
            setState(() {
              if (field.inputType.toLowerCase() == 'number') {
                participants[index][field.fieldName] =
                    value.isNotEmpty ? num.tryParse(value) ?? value : value;
              } else {
                participants[index][field.fieldName] = value;
              }
            });
          },
        );
    }
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isMobile,
    required bool isTablet,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.amberAccent, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.amberAccent.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
                vertical: isMobile ? 10 : 15, horizontal: isMobile ? 20 : 30),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
                fontSize: isMobile
                    ? 14
                    : isTablet
                        ? 16
                        : 18,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
