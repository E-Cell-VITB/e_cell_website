import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

Widget buildEvaluationCriteriaSection(
  BuildContext context,
  List<dynamic> evaluationTemplate,
  bool isMobile,
  bool isTablet,
  double screenWidth,
) {
  return Column(
    children: [
      LinearGradientText(
        child: Text(
          'Evaluation Criteria',
          style: isMobile
              ? Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold)
              : Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: isMobile
            ? 12
            : isTablet
                ? 16
                : 24,
        runSpacing: isMobile
            ? 12
            : isTablet
                ? 16
                : 24,
        alignment: WrapAlignment.center,
        children: evaluationTemplate.map((criteria) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isMobile
                ? screenWidth * 0.45
                : isTablet
                    ? screenWidth * 0.3
                    : 220,
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF404040).withOpacity(0.9),
                  const Color(0xFF303030).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(isMobile ? 12 : 20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: isMobile ? 6 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.amberAccent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LinearGradientText(
                  child: Text(
                    criteria.criteriaName,
                    style: TextStyle(
                      fontSize: isMobile
                          ? 14
                          : isTablet
                              ? 16
                              : 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Round ${criteria.roundNumber}',
                  style: TextStyle(
                    fontSize: isMobile
                        ? 12
                        : isTablet
                            ? 13
                            : 14,
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Max Score: ${criteria.maxScore}',
                  style: TextStyle(
                    fontSize: isMobile
                        ? 12
                        : isTablet
                            ? 13
                            : 14,
                    color: Colors.grey[400],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ],
  );
}
