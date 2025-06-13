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
          final email = participant['Email']?.toString();
          if (email != null && email.isNotEmpty) {
            emails.add(email.toLowerCase());
          }
        }
      }
      if (mounted) {
        setState(() {
          _registeredEmails = emails.toList();
          _registeredTeamNames = teamNames.toList();
          _isCheckingRegistration = false;
        });
      }
    } catch (e) {
      if (mounted) {
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
      if (mounted) {
        setState(() {
          _teamNameValidationStatus =
              !_registeredTeamNames.contains(teamName.toLowerCase());
          _isCheckingTeamName = false;
        });
      }
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
      if (mounted) {
        setState(() {
          _emailValidationStatus[controllerKey] =
              !_registeredEmails.contains(email.toLowerCase());
          _emailLoadingStatus[controllerKey] = false;
        });
      }
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
          participants =
              List.generate(1, (_) => <String, dynamic>{'isTeamLead': true});
          _currentStage = RegistrationStage.teamLeaderDetails;
        });
      }
    } else if (_currentStage == RegistrationStage.teamLeaderDetails) {
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
        setState(() {
          participants.addAll(List.generate(
              _teamSize! - 1, (_) => <String, dynamic>{'isTeamLead': false}));
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
        RegistrationSubmission.handleRegistration(
          context,
          event,
          widget.eventId,
          participants,
          _teamName,
          () {
            if (mounted) {
              setState(() => _isCheckingRegistration = false);
            }
          },
          () {
            if (mounted) {
              setState(() => _isSubmitting = false);
            }
          },
        );
      }
    }
  }

  void _moveToPreviousStage() {
    if (_currentStage == RegistrationStage.teamDetails) {
      context.pop();
    } else if (_currentStage == RegistrationStage.teamLeaderDetails) {
      setState(() {
        _currentStage = RegistrationStage.teamDetails;
        participants = [{}];
        _controllers.clear();
        _emailValidationStatus.clear();
        _emailLoadingStatus.clear();
      });
    } else if (_currentStage == RegistrationStage.memberDetails) {
      setState(() {
        _currentStage = RegistrationStage.teamLeaderDetails;
        participants = [participants.first]; // Retain only team leader details
        _controllers.removeWhere((key, _) => !key.startsWith('0_'));
        _emailValidationStatus.removeWhere((key, _) => !key.startsWith('0_'));
        _emailLoadingStatus.removeWhere((key, _) => !key.startsWith('0_'));
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
        backgroundColor: Colors.black87,
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
                    radius: 24,
                    width: isMobile ? screenWidth * 0.95 : screenWidth * 0.6,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 48,
                        vertical: isMobile ? 24 : 48,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(isMobile ? 16 : 24),
                              child: LinearGradientText(
                                child: Text(
                                  'Event Registration',
                                  style: isMobile
                                      ? Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(fontWeight: FontWeight.bold)
                                      : Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
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
                                          EdgeInsets.all(isMobile ? 8 : 24),
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
                                            onPressed: _isSubmitting ||
                                                    _isCheckingRegistration ||
                                                    _isCheckingTeamName
                                                ? null
                                                : _moveToPreviousStage,
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
                                    )
                                  ],
                                ),
                              ),
                            ] else ...[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    ...event.registrationTemplate
                                        .where((field) => !(field.inputType
                                                    .toLowerCase() ==
                                                'year' &&
                                            event.registrationTemplate.any(
                                                (f) =>
                                                    f.inputType.toLowerCase() ==
                                                    'department')))
                                        .map((field) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: _buildFormField(
                                          field,
                                          0,
                                          isMobile,
                                          isTablet,
                                          screenWidth,
                                          event,
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
                                        onPressed: _isSubmitting ||
                                                _isCheckingRegistration
                                            ? null
                                            : () async {
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
                                                      type: ToastificationType
                                                          .error,
                                                    );
                                                    return;
                                                  }
                                                  setState(() {
                                                    _isSubmitting = true;
                                                    participants[0].addAll({
                                                      'ischeckedIn': false,
                                                      'checkedInBy': '',
                                                      'checkedInAt': null,
                                                    });
                                                  });
                                                  try {
                                                    await RegistrationSubmission
                                                        .handleRegistration(
                                                      context,
                                                      event,
                                                      widget.eventId,
                                                      participants,
                                                      '${_teamName?[0].toUpperCase()}${_teamName?.substring(1)}',
                                                      () {
                                                        if (mounted) {
                                                          setState(() =>
                                                              _isCheckingRegistration =
                                                                  false);
                                                        }
                                                      },
                                                      () {
                                                        if (mounted) {
                                                          setState(() =>
                                                              _isSubmitting =
                                                                  false);
                                                        }
                                                      },
                                                    );
                                                  } catch (e) {
                                                    if (mounted) {
                                                      setState(() {
                                                        _isSubmitting = false;
                                                        _isCheckingRegistration =
                                                            false;
                                                      });
                                                      showCustomToast(
                                                        title: 'Error',
                                                        description:
                                                            'Registration failed: $e',
                                                        type: ToastificationType
                                                            .error,
                                                      );
                                                    }
                                                  }
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
          _buildStepIndicator(RegistrationStage.teamDetails, 'Team Details',
              Icons.group, isMobile),
          Transform.translate(
            offset: Offset(0, -15),
            child: _buildStepConnector(
              _currentStage.index >= RegistrationStage.teamLeaderDetails.index,
            ),
          ),
          _buildStepIndicator(RegistrationStage.teamLeaderDetails,
              'Team Leader', Icons.person, isMobile),
          Transform.translate(
            offset: Offset(0, -15),
            child: _buildStepConnector(
              _currentStage.index >= RegistrationStage.memberDetails.index,
            ),
          ),
          _buildStepIndicator(RegistrationStage.memberDetails, 'Members',
              Icons.person_add_alt, isMobile),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(
      RegistrationStage stage, String label, IconData icon, bool isMobile) {
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
              gradient: LinearGradient(
                colors: isActive
                    ? [Colors.amberAccent, Colors.orangeAccent]
                    : isCompleted
                        ? [
                            Colors.amberAccent.withOpacity(0.7),
                            Colors.orangeAccent.withOpacity(0.7)
                          ]
                        : [Colors.grey[700]!, Colors.grey[900]!],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.black, size: 24)
                  : Icon(icon,
                      color: isActive ? Colors.black : Colors.white, size: 24),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? Colors.amberAccent : Colors.white70,
              fontSize: isMobile ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.08,
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [Colors.amberAccent, Colors.orangeAccent]
              : [Colors.grey[700]!, Colors.grey[900]!],
        ),
      ),
    );
  }

  Widget _buildCurrentStageContent(
      OngoingEvent event, bool isMobile, bool isTablet, double screenWidth) {
    switch (_currentStage) {
      case RegistrationStage.teamDetails:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Team Information',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _teamNameController,
                decoration: _inputDecoration(
                  labelText: 'Team Name',
                  isMobile: isMobile,
                  suffixIcon: _isCheckingTeamName
                      ? Transform.scale(
                          scale: 0.6,
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: secondaryColor,
                            ),
                          ),
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
                decoration: _inputDecoration(
                  labelText: 'Team Size',
                  isMobile: isMobile,
                ),
                dropdownColor: Colors.grey[900],
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
      case RegistrationStage.teamLeaderDetails:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Team Leader Details',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ...event.registrationTemplate
                  .where((field) => !(field.inputType.toLowerCase() == 'year' &&
                      event.registrationTemplate.any(
                          (f) => f.inputType.toLowerCase() == 'department')))
                  .map((field) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildFormField(
                    field,
                    0,
                    isMobile,
                    isTablet,
                    screenWidth,
                    event,
                  ),
                );
              }),
            ],
          ),
        );
      case RegistrationStage.memberDetails:
        return Column(
          children: List.generate(participants.length - 1, (index) {
            final actualIndex = index + 1; // Skip team leader (index 0)
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[900]!,
                    Colors.black87,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: Colors.amberAccent,
                          size: isMobile ? 22 : 26,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Team Member ${index + 1}',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...event.registrationTemplate
                        .where((field) =>
                            !(field.inputType.toLowerCase() == 'year' &&
                                event.registrationTemplate.any((f) =>
                                    f.inputType.toLowerCase() == 'department')))
                        .map((field) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildFormField(
                          field,
                          actualIndex,
                          isMobile,
                          isTablet,
                          screenWidth,
                          event,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
        );
    }
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required bool isMobile,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.grey[400],
        fontSize: isMobile ? 14 : 16,
      ),
      filled: true,
      fillColor: Colors.grey[850],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.amberAccent, width: 2),
      ),
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(
        vertical: isMobile ? 12 : 16,
        horizontal: 16,
      ),
    );
  }

  Widget _buildFormField(
    RegistrationField field,
    int index,
    bool isMobile,
    bool isTablet,
    double screenWidth,
    OngoingEvent event,
  ) {
    final controllerKey = '${index}_${field.fieldName}';
    if (!_controllers.containsKey(controllerKey)) {
      _controllers[controllerKey] = TextEditingController(
        text: participants[index][field.fieldName]?.toString() ?? '',
      );
    }
    final controller = _controllers[controllerKey]!;

    final capitalizedFieldName =
        '${field.fieldName[0].toUpperCase()}${field.fieldName.substring(1)}';

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

    bool hasDepartment = event.registrationTemplate
        .any((f) => f.inputType.toLowerCase() == 'department');
    bool hasYear = event.registrationTemplate
        .any((f) => f.inputType.toLowerCase() == 'year');
    bool isDepartment = field.inputType.toLowerCase() == 'department';

    if (isDepartment && hasYear) {
      return Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<Department>(
              isExpanded: true,
              decoration: _inputDecoration(
                labelText: capitalizedFieldName,
                isMobile: isMobile,
              ),
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              value: participants[index][field.fieldName] != null
                  ? Department.values.firstWhere(
                      (e) =>
                          e.toString() == participants[index][field.fieldName],
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
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<int>(
              decoration: _inputDecoration(
                labelText: 'Year',
                isMobile: isMobile,
              ),
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              value: participants[index]['year'] is int
                  ? participants[index]['year']
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
                    participants[index]['year'] = value;
                  });
                }
              },
              validator: (value) {
                if (event.registrationTemplate.any((f) =>
                    f.inputType.toLowerCase() == 'year' && f.isRequired)) {
                  if (value == null) {
                    return 'Year is required';
                  }
                }
                return null;
              },
            ),
          ),
        ],
      );
    }

    switch (field.inputType.toLowerCase()) {
      case 'boolean':
        return DropdownButtonFormField<bool>(
          decoration: _inputDecoration(
            labelText: capitalizedFieldName,
            isMobile: isMobile,
          ),
          dropdownColor: Colors.grey[900],
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
        return DropdownButtonFormField<Department>(
          isExpanded: true,
          decoration: _inputDecoration(
            labelText: capitalizedFieldName,
            isMobile: isMobile,
          ),
          dropdownColor: Colors.grey[900],
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
        );
      default:
        return TextFormField(
          controller: controller,
          decoration: _inputDecoration(
            labelText: capitalizedFieldName,
            isMobile: isMobile,
            suffixIcon: field.inputType.toLowerCase() == 'email'
                ? _emailLoadingStatus[controllerKey] == true
                    ? Transform.scale(
                        scale: 0.6,
                        child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: secondaryColor,
                          ),
                        ),
                      )
                    : _emailValidationStatus[controllerKey] == true
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : _emailValidationStatus[controllerKey] == false
                            ? const Icon(Icons.cancel, color: Colors.red)
                            : null
                : null,
          ),
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
