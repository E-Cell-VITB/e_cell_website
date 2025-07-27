import 'package:e_cell_website/backend/models/team_member.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/team/widgets/profile_card.dart';
import 'package:e_cell_website/services/enums/department.dart';
import 'package:e_cell_website/services/providers/team_members_provider.dart';
import 'package:e_cell_website/widgets/footer.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ParticleBackground(
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LinearGradientText(
                      child: Text(
                        "Our Team",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: size.width * 0.8,
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: size.width > 600
                                    ? "Meet the changemakers of E-Cell VITB. "
                                    : "Meet the changemakers ",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              TextSpan(
                                text: "✨",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Consumer<TeamProvider>(
                      builder: (context, teamProvider, _) {
                        return StreamBuilder<List<TeamMemberModel>>(
                          stream: teamProvider.teamMembersStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                height: size.height * 0.5,
                                child: const Center(
                                  child: LoadingIndicator(),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text("Error: ${snapshot.error}"));
                            }

                            final teamMembers = snapshot.data ?? [];
                            return Column(
                              children: Department.values.map((dept) {
                                List<TeamMemberModel> departmentMembers =
                                    teamMembers
                                        .where((member) =>
                                            member.department == dept.name)
                                        .toList();

                                List<TeamMemberModel> sortedTeamMembers =
                                    teamProvider.teamMemberService
                                        .sortDepartmentMembers(
                                            departmentMembers, dept.name);

                                return departmentMembers.isNotEmpty
                                    ? TeamContainer(
                                        size: size,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(children: [
                                            LinearGradientText(
                                              child: Text(
                                                dept.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium,
                                              ),
                                            ),
                                            ResponsiveProfileCards(
                                              teamMembers: sortedTeamMembers,
                                            ),
                                          ]),
                                        ),
                                      )
                                    : const SizedBox();
                              }).toList(),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const Footer(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  context.goNamed('recruitmentScreen');
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: linerGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_forward, color: backgroundColor),
                      SizedBox(width: 8),
                      Text(
                        "Join E-Cell",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: backgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class ResponsiveProfileCards extends StatelessWidget {
  final List<TeamMemberModel> teamMembers;
  const ResponsiveProfileCards({super.key, required this.teamMembers});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
                teamMembers.length,
                (index) => ProfileCard(
                      teamMember: teamMembers[index],
                    )),
          ),
        );
        // return isMobile
        //     ? SingleChildScrollView(
        //         scrollDirection: Axis.horizontal,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           mainAxisSize: MainAxisSize.min,
        //           children: List.generate(
        //               teamMembers.length,
        //               (index) => ProfileCard(
        //                     teamMember: teamMembers[index],
        //                   )),
        //         ),
        //       )
        //     : SingleChildScrollView(
        //         scrollDirection: Axis.horizontal,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           mainAxisSize: MainAxisSize.min,
        //           children: List.generate(
        //               teamMembers.length,
        //               (index) => ProfileCard(
        //                     teamMember: teamMembers[index],
        //                   )),
        //         ),
        //       );
      },
    );
  }
}

class TeamContainer extends StatelessWidget {
  const TeamContainer({
    super.key,
    required this.size,
    this.child,
  });

  final Size size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        // width: size.width * 0.8,
        // height: size.height * 0.5,
        constraints: BoxConstraints(
            minWidth: size.width * 0.3, maxWidth: size.width * 0.82),
        decoration: BoxDecoration(
          color: containerBgColor,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
