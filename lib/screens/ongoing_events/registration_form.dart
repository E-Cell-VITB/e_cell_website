import 'package:e_cell_website/screens/ongoing_events/forms/registration_submission.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/screens/ongoing_events/widgets/gradient_button.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:e_cell_website/services/enums/registration.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OngoingEventRegister extends StatefulWidget {
  final String eventId;

  const OngoingEventRegister({required this.eventId, super.key});

  @override
  OngoingEventRegisterState createState() => OngoingEventRegisterState();
}

class OngoingEventRegisterState extends State<OngoingEventRegister> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> participants = [{}];
  bool _isSubmitting = false;
  bool _isCheckingRegistration = false;
  bool _isCheckingTeamName = false;
  RegistrationStage _currentStage = RegistrationStage.teamDetails;
  String? _teamName;
  int? _teamSize;
  final _teamNameController = TextEditingController();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _emailValidationStatus = {};
  final Map<String, bool> _emailLoadingStatus = {};
  List<String> _registeredEmails = [];
  List<String> _registeredTeamNames = [];
  bool? _teamNameValidationStatus;

  @override
  void initState() {
    super.initState();
    _fetchRegisteredData();
    _teamNameController.addListener(_validateTeamName);
  }

  Future<void> _fetchRegisteredData() async {
    try {
      setState(() {
        _isCheckingRegistration = true;
      });
      final query = await FirebaseFirestore.instance
          .collection('ongoing_events')
          .doc(widget.eventId)
          .collection('registered_users')
          .get();

      final emails = <String>{};
      final teamNames = <String>{};
      for (var doc in query.docs) {
        final participants =
            List<Map<String, dynamic>>.from(doc.data()['participants'] ?? []);
        final teamName = doc.data()['team_name']?.toString();
        if (teamName != null && teamName.isNotEmpty) {
          teamNames.add(teamName.toLowerCase());
        }
        for (var participant in participants) {
          final email = participant['email']?.toString();
          if (email != null && email.isNotEmpty) {
            emails.add(email.toLowerCase());
          }
        }
      }
      setState(() {
        _registeredEmails = emails.toList();
        _registeredTeamNames = teamNames.toList();
        _isCheckingRegistration = false;
      });
    } catch (e) {
      setState(() {
        _isCheckingRegistration = false;
      });
      showCustomToast(
        title: 'Error',
        description: 'Failed to fetch registered data: $e',
        type: ToastificationType.error,
      );
    }
  }

  void _validateTeamName() {
    final teamName = _teamNameController.text;
    if (teamName.isEmpty) {
      setState(() {
        _teamNameValidationStatus = null;
        _isCheckingTeamName = false;
      });
      return;
    }
    setState(() {
      _isCheckingTeamName = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _teamNameValidationStatus =
            !_registeredTeamNames.contains(teamName.toLowerCase());
        _isCheckingTeamName = false;
      });
    });
  }

  void _validateEmail(String email, String controllerKey) {
    if (email.isEmpty) {
      setState(() {
        _emailValidationStatus[controllerKey] = true;
        _emailLoadingStatus[controllerKey] = false;
      });
      return;
    }
    setState(() {
      _emailLoadingStatus[controllerKey] = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _emailValidationStatus[controllerKey] =
            !_registeredEmails.contains(email.toLowerCase());
        _emailLoadingStatus[controllerKey] = false;
      });
    });
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
        if (_teamNameValidationStatus == false || _isCheckingTeamName) {
          showCustomToast(
            title: 'Invalid Team Name',
            description: 'Please enter a unique team name',
            type: ToastificationType.error,
          );
          return;
        }
        setState(() {
          _teamName = _teamNameController.text;
          participants = List.generate(_teamSize!, (_) => <String, dynamic>{});
          for (var participant in participants) {
            participant.addAll({
              'isCheckedIn': false,
              'checkedInBy': '',
              'checkedInAt': null,
            });
          }
          _currentStage = RegistrationStage.memberDetails;
        });
      }
    } else if (_currentStage == RegistrationStage.memberDetails) {
      if (_formKey.currentState!.validate()) {
        bool allEmailsValid = true;
        for (var entry in _emailValidationStatus.entries) {
          if (entry.value == false || _emailLoadingStatus[entry.key] == true) {
            allEmailsValid = false;
            break;
          }
        }
        if (!allEmailsValid) {
          showCustomToast(
            title: 'Invalid Emails',
            description: 'Please correct invalid or duplicate email addresses',
            type: ToastificationType.error,
          );
          return;
        }

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
        setState(() => _isSubmitting = true);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          RegistrationSubmission.handleRegistration(
            context,
            event,
            widget.eventId,
            participants,
            _teamName,
            () {
              if (mounted) {
                setState(() {
                  _isCheckingRegistration = false;
                });
              }
            },
            () {
              if (mounted) {
                setState(() {
                  _isCheckingTeamName = false;
                });
              }
            },
          );
        });
      }
    }
  }

  void _moveToPreviousStage() {
    if (_currentStage == RegistrationStage.teamDetails) {
      context.pop();
    } else if (_currentStage == RegistrationStage.memberDetails) {
      setState(() {
        _currentStage = RegistrationStage.teamDetails;
        participants = [{}];
        _controllers.clear();
        _emailValidationStatus.clear();
        _emailLoadingStatus.clear();
      });
    }
  }

  @override
  void dispose() {
    _teamNameController.removeListener(_validateTeamName);
    _teamNameController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;

    return ChangeNotifierProvider(
      create: (context) =>
          OngoingEventProvider()..fetchEventById(widget.eventId),
      child: Scaffold(
        body: Consumer<OngoingEventProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingEvents || _isCheckingRegistration) {
              return SizedBox(
                height: screenHeight * 0.6,
                child: const Center(child: LoadingIndicator()),
              );
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
                    color: Colors.redAccent,
                  ),
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
                    color: Colors.white,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(
                    isMobile
                        ? 12.0
                        : isTablet
                            ? 18.0
                            : 24.0,
                  ),
                  child: GradientBox(
                    radius: 18,
                    width: isMobile ? screenWidth * 0.9 : screenWidth * 0.5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 2 : 54,
                        vertical: isMobile ? 2 : 54,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(isMobile ? 16 : 0),
                              child: LinearGradientText(
                                child: Text(
                                  '${event.name} Registration Form',
                                  style: isMobile
                                      ? Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                      : Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            if (provider.errorRegistration != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  provider.errorRegistration!,
                                  style: TextStyle(
                                    fontSize: isMobile
                                        ? 14
                                        : isTablet
                                            ? 16
                                            : 18,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            if (event.isTeamEvent) ...[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    _buildCustomStepper(isMobile, screenWidth),
                                    Divider(
                                      height: 1,
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.all(isMobile ? 0 : 24),
                                      child: _buildCurrentStageContent(
                                        event,
                                        isMobile,
                                        isTablet,
                                        screenWidth,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GradientButton(
                                            text: _currentStage ==
                                                    RegistrationStage
                                                        .teamDetails
                                                ? 'CANCEL'
                                                : 'BACK',
                                            onPressed: _moveToPreviousStage,
                                            isMobile: isMobile,
                                            isTablet: isTablet,
                                          ),
                                          GradientButton(
                                            text: _currentStage ==
                                                    RegistrationStage
                                                        .memberDetails
                                                ? 'SUBMIT'
                                                : 'NEXT',
                                            onPressed: (_isSubmitting ||
                                                    _isCheckingRegistration ||
                                                    _isCheckingTeamName ||
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
                                    ...event.registrationTemplate.map((field) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: _buildFormField(
                                          field,
                                          0,
                                          isMobile,
                                          isTablet,
                                          screenWidth,
                                        ),
                                      );
                                    }),
                                    const SizedBox(height: 16),
                                    if (_isSubmitting ||
                                        _isCheckingRegistration)
                                      SizedBox(
                                        height: screenHeight * 0.6,
                                        child: const Center(
                                          child: LoadingIndicator(),
                                        ),
                                      )
                                    else
                                      GradientButton(
                                        text: 'Submit Registration',
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (_emailValidationStatus[
                                                        '0_email'] ==
                                                    false ||
                                                _emailLoadingStatus[
                                                        '0_email'] ==
                                                    true) {
                                              showCustomToast(
                                                title: 'Invalid Email',
                                                description:
                                                    'Please enter a valid and non-duplicate email',
                                                type: ToastificationType.error,
                                              );
                                              return;
                                            }
                                            setState(
                                                () => _isSubmitting = true);
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              RegistrationSubmission
                                                  .handleRegistration(
                                                context,
                                                event,
                                                widget.eventId,
                                                participants,
                                                '${_teamName?[0].toUpperCase()}${_teamName?.substring(1)}',
                                                () => setState(() =>
                                                    _isCheckingRegistration =
                                                        false),
                                                () => setState(() =>
                                                    _isSubmitting = false),
                                              );
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
    );
  }

  Widget _buildCustomStepper(bool isMobile, double screenWidth) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepIndicator(
              RegistrationStage.teamDetails, 'Team Details', Icons.group),
          _buildStepConnector(
              _currentStage.index >= RegistrationStage.memberDetails.index),
          _buildStepIndicator(
              RegistrationStage.memberDetails, 'Member Details', Icons.person),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(
      RegistrationStage stage, String label, IconData icon) {
    final isActive = _currentStage == stage;
    final isCompleted = _currentStage.index > stage.index;

    return InkWell(
      onTap: () {
        if (_currentStage.index >= stage.index) {
          setState(() => _currentStage = stage);
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

  Widget _buildCurrentStageContent(
      OngoingEvent event, bool isMobile, bool isTablet, double screenWidth) {
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
                  suffixIcon: _isCheckingTeamName
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : _teamNameValidationStatus == true
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : _teamNameValidationStatus == false
                              ? const Icon(Icons.cancel, color: Colors.red)
                              : null,
                ),
                style: const TextStyle(color: Colors.white),
                textDirection: TextDirection.ltr,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Team name is required';
                  }
                  if (_registeredTeamNames.contains(value.toLowerCase())) {
                    return 'This team name is already taken';
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
                  setState(() => _teamSize = value);
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
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...event.registrationTemplate.map((field) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildFormField(
                          field, index, isMobile, isTablet, screenWidth),
                    );
                  }),
                ],
              ),
            );
          }),
        );
    }
  }

  Widget _buildFormField(RegistrationField field, int index, bool isMobile,
      bool isTablet, double screenWidth) {
    final controllerKey = '${index}_${field.fieldName}';
    if (!_controllers.containsKey(controllerKey)) {
      _controllers[controllerKey] = TextEditingController(
        text: participants[index][field.fieldName]?.toString() ?? '',
      );
    }
    final controller = _controllers[controllerKey]!;

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
        suffixIcon: field.inputType.toLowerCase() == 'email'
            ? _emailLoadingStatus[controllerKey] == true
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : _emailValidationStatus[controllerKey] == true
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : _emailValidationStatus[controllerKey] == false
                        ? const Icon(Icons.cancel, color: Colors.red)
                        : null
            : null,
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
                RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
            if (!emailRegex.hasMatch(value)) {
              return '$capitalizedFieldName must be a valid email';
            }
            if (_registeredEmails.contains(value.toLowerCase())) {
              return 'This email is already registered';
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
              setState(() {
                participants[index][field.fieldName] = value;
              });
            }
          },
          validator: validator,
        );

      case 'department':
        return SizedBox(
          width: isMobile ? 250 : screenWidth * 0.6,
          child: DropdownButtonFormField<Department>(
            isExpanded: true,
            decoration: inputDecoration(
              labelText: field.fieldName.isNotEmpty
                  ? capitalizedFieldName
                  : 'Department',
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
              setState(() {
                participants[index][field.fieldName] = value;
              });
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
            setState(() {
              if (field.inputType.toLowerCase() == 'number') {
                participants[index][field.fieldName] =
                    value.isNotEmpty ? num.tryParse(value) ?? value : value;
              } else {
                participants[index][field.fieldName] = value;
              }
            });
            if (field.inputType.toLowerCase() == 'email') {
              _validateEmail(value, controllerKey);
            }
          },
        );
    }
  }
}
