import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/enums/registration.dart';
import 'package:flutter/material.dart';

class CustomStepper extends StatelessWidget {
  final RegistrationStage currentStage;
  final bool isMobile;
  final Function(RegistrationStage) onStageTapped;
  final double width;

  const CustomStepper({
    required this.currentStage,
    required this.isMobile,
    required this.onStageTapped,
    required this.width,
    super.key,
  });

  Widget _buildStepIndicator(
      RegistrationStage stage, String label, IconData icon) {
    final isActive = currentStage == stage;
    final isCompleted = currentStage.index > stage.index;

    return InkWell(
      onTap: () => onStageTapped(stage),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive
                  ? secondaryColor
                  : isCompleted
                      ? secondaryColor.withOpacity(0.7)
                      : primaryColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.black)
                  : Icon(icon, color: isActive ? Colors.black : primaryColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: isMobile ? 10 : 16,
              color: isActive ? secondaryColor : primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: width * 0.06,
      height: 2,
      color: isActive ? secondaryColor : primaryColor.withOpacity(0.3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepIndicator(
              RegistrationStage.teamDetails, 'Team Details', Icons.group),
          _buildStepConnector(
              currentStage.index >= RegistrationStage.memberDetails.index),
          _buildStepIndicator(
              RegistrationStage.memberDetails, 'Member Details', Icons.person),
        ],
      ),
    );
  }
}
