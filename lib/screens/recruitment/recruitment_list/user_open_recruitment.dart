import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/auth/widgets/gradient_box_auth.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:e_cell_website/services/providers/auth_provider.dart';
import 'package:e_cell_website/services/providers/recruitment_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserOpenRecruitmentsList extends StatelessWidget {
  const UserOpenRecruitmentsList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecruitmentProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return ParticleBackground(
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(isMobile ? 24.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LinearGradientText(
                  child: Text('Recruitments',
                      textAlign: TextAlign.center,
                      style: isMobile
                          ? Theme.of(context).textTheme.displayMedium
                          : Theme.of(context).textTheme.displayLarge),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Join the team that's building tomorrow — apply now!",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: isMobile ? 16 : 24),
                StreamBuilder<QuerySnapshot>(
                  stream: provider.getOpenRecruitments(),
                  builder: (context, snapshot) {
                    if (provider.errorMessage != null &&
                        provider.errorMessage!
                            .contains('Error loading recruitments')) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Error loading recruitments',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: isMobile ? 14 : 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SelectableText(
                              provider.errorMessage!,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: isMobile ? 12 : 14),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              icon: const Icon(Icons.refresh,
                                  color: secondaryColor),
                              label: const Text(
                                'Try Again',
                                style: TextStyle(color: secondaryColor),
                              ),
                              onPressed: () {
                                provider.clearError();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    secondaryColor.withOpacity(0.1),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Error loading recruitments',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: isMobile ? 14 : 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SelectableText(
                              snapshot.error.toString(),
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: isMobile ? 12 : 14),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              icon: const Icon(Icons.refresh,
                                  color: secondaryColor),
                              label: const Text(
                                'Try Again',
                                style: TextStyle(color: secondaryColor),
                              ),
                              onPressed: () {
                                provider.clearError();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    secondaryColor.withOpacity(0.1),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: isMobile ? 12 : 16),
                            const CircularProgressIndicator(
                              color: secondaryColor,
                              strokeWidth: 3,
                            ),
                            SizedBox(height: isMobile ? 8 : 12),
                            Text(
                              'Loading recruitments...',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: isMobile ? 12 : 14,
                              ),
                            ),
                            SizedBox(height: isMobile ? 12 : 16),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Container(
                        padding: EdgeInsets.all(isMobile ? 20 : 24),
                        decoration: BoxDecoration(
                          color: backgroundColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: primaryColor.withOpacity(0.25)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(isMobile ? 12 : 16),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_paused_rounded,
                                color: primaryColor,
                                size: isMobile ? 32 : 40,
                              ),
                            ),
                            SizedBox(height: isMobile ? 16 : 20),
                            Text(
                              'No Open Positions',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: isMobile ? 16 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: isMobile ? 8 : 10),
                            Text(
                              'We don\'t have any active recruitments at the moment.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: primaryColor.withOpacity(0.8),
                                fontSize: isMobile ? 14 : 15,
                              ),
                            ),
                            SizedBox(height: isMobile ? 12 : 14),
                            Text(
                              'Check back soon for new opportunities.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: primaryColor.withOpacity(0.7),
                                fontSize: isMobile ? 12 : 14,
                              ),
                            ),
                            SizedBox(height: isMobile ? 6 : 8),
                          ],
                        ),
                      );
                    }

                    return Container(
                      width: screenWidth > 600
                          ? screenWidth * 0.6
                          : screenWidth * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: primaryColor.withOpacity(0.3)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          separatorBuilder: (context, index) {
                            return Divider(
                                height: 1.5,
                                thickness: 1,
                                color: primaryColor.withOpacity(0.5));
                          },
                          itemBuilder: (context, index) {
                            final doc = snapshot.data!.docs[index];
                            final department = doc['department'] as String;
                            final positions =
                                List<String>.from(doc['positions']);
                            final timestamp = doc['createdAt'] as Timestamp?;
                            final date = timestamp != null
                                ? _formatDate(timestamp.toDate())
                                : 'Date unavailable';

                            return Container(
                              decoration: BoxDecoration(
                                color: index.isEven
                                    ? backgroundColor.withOpacity(0.9)
                                    : backgroundColor.withOpacity(0.6),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 12 : 16,
                                  vertical: isMobile ? 6 : 8,
                                ),
                                leading: Container(
                                  width: isMobile ? 36 : 40,
                                  height: isMobile ? 36 : 40,
                                  decoration: BoxDecoration(
                                    color: secondaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.work_outline,
                                      color: secondaryColor,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        department,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: primaryColor,
                                          fontSize: isMobile ? 14 : 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 6 : 8,
                                        vertical: isMobile ? 3 : 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: secondaryColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        date,
                                        style: TextStyle(
                                          fontSize: isMobile ? 10 : 12,
                                          color: secondaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: isMobile ? 4 : 6),
                                    Text(
                                      'Positions: ${positions.length}',
                                      style: TextStyle(
                                        fontSize: isMobile ? 12 : 14,
                                        color: primaryColor.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(height: isMobile ? 4 : 6),
                                    Wrap(
                                      spacing: isMobile ? 4 : 6,
                                      runSpacing: isMobile ? 4 : 6,
                                      children: positions.map((position) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isMobile ? 6 : 8,
                                            vertical: isMobile ? 2 : 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                primaryColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                color: primaryColor
                                                    .withOpacity(0.3)),
                                          ),
                                          child: Text(
                                            position,
                                            style: TextStyle(
                                              fontSize: isMobile ? 10 : 12,
                                              color:
                                                  primaryColor.withOpacity(0.9),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  final authProvider =
                                      Provider.of<AuthProvider>(context,
                                          listen: false);
                                  if (authProvider.currentUserModel == null) {
                                    showCustomToast(
                                      title: "Hold Up!",
                                      description:
                                          "You need to log in before joining the E-Cell family.",
                                    );

                                    // Store the document ID for later use
                                    final String documentId = doc.id;

                                    // Create a flag to track if authentication was successful
                                    bool authSuccessful = false;

                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (dialogContext) {
                                        return Dialog(
                                          backgroundColor: Colors.white,
                                          child: SizedBox(
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.8,
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.4,
                                            child: Consumer<AuthProvider>(
                                              builder: (context, auth, _) {
                                                // Check if user has logged in during this dialog session
                                                if (auth.currentUserModel !=
                                                        null &&
                                                    !authSuccessful) {
                                                  // Mark that auth was successful to prevent duplicate navigation
                                                  authSuccessful = true;

                                                  // Close the dialog after a short delay to allow state to settle
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    Navigator.of(dialogContext).pop(
                                                        true); // Pass true to indicate success
                                                  });
                                                }

                                                return GradientBoxAuth(
                                                  radius: 16,
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.8,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.4,
                                                  child: auth.page.widget,
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((result) {
                                      if (result == true) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          if (ModalRoute.of(context) != null &&
                                              Navigator.of(context).canPop()) {
                                            // Use the router safely
                                            GoRouter.of(context).goNamed(
                                              'recruitmentApplications',
                                              pathParameters: {
                                                'id': documentId,
                                                'department': department
                                              },
                                            );
                                          } else {
                                            print(
                                                "Navigation context is no longer valid. Using fallback method.");
                                          }
                                        });
                                      } else {
                                        authProvider.setPage(Pages.login);
                                      }
                                    });

                                    return;
                                  }

                                  context.goNamed(
                                    'recruitmentApplications',
                                    pathParameters: {
                                      'id': doc.id,
                                      'department': department
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Complete User Recruitment Screen
class UserRecruitmentScreen extends StatelessWidget {
  const UserRecruitmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return ChangeNotifierProvider(
      create: (_) => RecruitmentProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Available Recruitments',
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          elevation: 0,
          backgroundColor: backgroundColor,
          iconTheme: const IconThemeData(color: primaryColor),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
                  child: Text(
                    'Explore open positions and apply now!',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: primaryColor.withOpacity(0.7),
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 12 : 16),
                const UserOpenRecruitmentsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
