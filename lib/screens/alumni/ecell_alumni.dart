import 'package:e_cell_website/backend/models/team_member.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/alumni/widgets/profilecard.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/services/providers/team_members_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EcellAlumni extends StatelessWidget {
  const EcellAlumni({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 600;
    bool isTablet = size.width >= 600 && size.width < 1200;
    final teamProvider = Provider.of<TeamProvider>(context);

    return Scaffold(
      body: ParticleBackground(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: isMobile ? 10 : 30,
            ),
            Center(
              child: LinearGradientText(
                  child: Text(
                'E-Cell Alumni',
                style: TextStyle(
                    fontSize: isMobile ? 30 : 75,
                    wordSpacing: 15,
                    fontWeight: FontWeight.w400),
              )),
            ),
            Center(
              child: Text(
                'Once a part of E-Cell, always a part of E-Cell',
                style: TextStyle(
                    fontSize: isMobile ? 14 : 18,
                    fontWeight: FontWeight.w300,
                    color: Colors.white70),
              ),
            ),
            SizedBox(
              height: isMobile ? 20 : 30,
            ),
            StreamBuilder<List<AlumniTeamModel>>(
              stream: teamProvider.alumniMembersStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: size.height * 0.5,
                    child: const Center(
                      child: LoadingIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error loading alumni: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final allMembers = snapshot.data ?? [];

                if (allMembers.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        'No alumni members found',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 20,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  );
                }

                // Group alumni by passoutYear
                Map<int, List<AlumniTeamModel>> groupedByYear = {};
                for (var member in allMembers) {
                  int year =
                      int.tryParse(member.passoutYear) ?? DateTime.now().year;
                  if (!groupedByYear.containsKey(year)) {
                    groupedByYear[year] = [];
                  }
                  groupedByYear[year]!.add(member);
                }

                // Sort years in descending order (most recent first)
                List<int> sortedYears = groupedByYear.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: sortedYears.length,
                  itemBuilder: (context, index) {
                    int passoutYear = sortedYears[index];
                    List<AlumniTeamModel> yearMembers =
                        groupedByYear[passoutYear]!;
                    String yearDisplay =
                        "${passoutYear - 1}-${passoutYear.toString().substring(2)}";

                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: isMobile ? 20.0 : 40.0),
                        padding: EdgeInsets.all(isMobile ? 20 : 40),
                        width: isMobile
                            ? MediaQuery.of(context).size.width * 0.9
                            : MediaQuery.of(context).size.width * 0.8,
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
                        child: Column(
                          children: [
                            GradientBox(
                              width: isMobile
                                  ? MediaQuery.of(context).size.width
                                  : MediaQuery.of(context).size.width * 0.8,
                              height: isMobile ? 40 : 60,
                              radius: isMobile ? 18 : 28,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  if (!isMobile && !isTablet)
                                    EcellText(isMobile, isTablet),
                                  EcellText(isMobile, isTablet),
                                  EcellText(isMobile, isTablet),
                                  SizedBox(
                                    width: isMobile ? 100 : 250,
                                    child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "✨ ",
                                              style: isMobile
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: secondaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .headlineLarge
                                                      ?.copyWith(
                                                        color: secondaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                            ),
                                            TextSpan(
                                              text: " $yearDisplay ",
                                              style: isMobile
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .headlineLarge,
                                            ),
                                            TextSpan(
                                              text: " ✨",
                                              style: isMobile
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: secondaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .headlineLarge
                                                      ?.copyWith(
                                                        color: secondaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  if (!isMobile && !isTablet)
                                    EcellText(isMobile, isTablet),
                                  EcellText(isMobile, isTablet),
                                  EcellText(isMobile, isTablet),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isMobile
                                    ? 1
                                    : isTablet
                                        ? 2
                                        : 4,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: 1,
                              ),
                              itemCount: yearMembers.length,
                              itemBuilder: (context, memberIndex) {
                                return Center(
                                  child: AlumniProfileCard(
                                    teamMember: yearMembers[memberIndex],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}

Widget EcellText(bool isMobile, bool isTablet) {
  return Text("E-CELL",
      style: TextStyle(
        wordSpacing: 15,
        fontSize: isMobile
            ? 10
            : isTablet
                ? 18
                : 30,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 46, 46, 46),
      ));
}
