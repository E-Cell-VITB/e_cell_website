import 'package:e_cell_website/backend/firebase_services/ongoing_event_service.dart';
import 'package:e_cell_website/backend/models/evalution_result.dart'
    as result_model;
import 'package:e_cell_website/backend/models/roundinfo.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;
  final String eventId;

  const ResultsScreen({
    required this.eventId,
    required this.isMobile,
    required this.isTablet,
    super.key,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<result_model.EvaluationResult> _results = [];
  List<result_model.EvaluationResult> _filteredResults = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  // Map of teamName to criterion scores list
  Map<String, Map<String, List<int>>> _teamCriterionScores = {};
  // Map of teamName to round sums
  Map<String, List<RoundInfo>> _teamRoundSums = {};
  // Round structure from backend
  Map<int, int> _roundStructure = {};

  Future<void> fetchResults() async {
    setState(() {
      _isLoading = true;
    });

    final service = OngoingEventService();
    final String eventId = widget.eventId;

    try {
      // First, get the round structure from the backend
      _roundStructure = await service.getRoundStructure(eventId);
    } catch (e) {
      print('Error getting round structure: $e');
      _roundStructure = {};
    }

    final teamIds = await service.getTeamsByEventId(eventId);
    List<result_model.EvaluationResult> results = [];
    Map<String, Map<String, List<int>>> teamCriterionScores = {};
    Map<String, List<RoundInfo>> teamRoundSums = {};

    for (final teamId in teamIds) {
      final teamResultsStream = service.getResultsByTeamId(eventId, teamId);
      final teamResults = await teamResultsStream.first;
      for (final result in teamResults) {
        if (result.totalScore != 0) {
          results.add(result);
          // Build criterion scores list for this team
          final Map<String, List<int>> criterionScores = {};
          final List<int> orderedScores = [];

          // Extract all scores in order from the assigned marks
          for (final scoreModel in result.scores) {
            for (final mark in scoreModel.assignedMarks) {
              mark.forEach((key, value) {
                criterionScores.putIfAbsent(key, () => []);
                criterionScores[key]!.add(value);
                orderedScores.add(value);
              });
            }
          }
          teamCriterionScores[result.teamName] = criterionScores;

          // Calculate round sums based on the ordered scores and backend round structure
          if (orderedScores.isNotEmpty && _roundStructure.isNotEmpty) {
            List<RoundInfo> roundSums =
                _calculateRoundSumsForTeam(orderedScores);
            teamRoundSums[result.teamName] = roundSums;
          }
        }
      }
    }

    results.sort((a, b) => b.totalScore.compareTo(a.totalScore));

    setState(() {
      _results = results;
      _filteredResults = results;
      _teamCriterionScores = teamCriterionScores;
      _teamRoundSums = teamRoundSums;
      _isLoading = false;
    });
  }

  List<RoundInfo> _calculateRoundSumsForTeam(List<int> orderedScores) {
    List<RoundInfo> roundSums = [];

    if (_roundStructure.isEmpty) {
      print('Warning: Round structure is empty, cannot calculate round sums');
      return roundSums;
    }

    int scoreIndex = 0;
    var sortedRounds = _roundStructure.keys.toList()..sort();

    for (int roundNum in sortedRounds) {
      int criteriaInThisRound = _roundStructure[roundNum]!;

      double roundSum = 0.0;
      for (int j = 0;
          j < criteriaInThisRound && scoreIndex < orderedScores.length;
          j++) {
        roundSum += orderedScores[scoreIndex];
        scoreIndex++;
      }

      roundSums.add(RoundInfo(roundNumber: roundNum, roundSum: roundSum));
    }

    return roundSums;
  }

  // Helper method to get round sum for a specific team and round
  double _getRoundSumForTeam(String teamName, int roundNumber) {
    final roundSums = _teamRoundSums[teamName] ?? [];
    for (final roundInfo in roundSums) {
      if (roundInfo.roundNumber == roundNumber) {
        return roundInfo.roundSum;
      }
    }
    return 0.0;
  }

  @override
  void initState() {
    super.initState();
    fetchResults();
    _searchController.addListener(_filterResults);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterResults() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredResults = _results.where((result) {
        return result.teamName.toLowerCase().contains(query);
      }).toList();
    });
  }

  Widget _buildDataTable() {
    final Set<String> allCriteriaKeys = {};
    for (final result in _filteredResults) {
      for (final scoreModel in result.scores) {
        for (final assignedMark in scoreModel.assignedMarks) {
          allCriteriaKeys.addAll(assignedMark.keys);
        }
      }
    }
    final List<String> criteriaColumns = allCriteriaKeys.toList();

    // Get available rounds from team round sums
    Set<int> availableRounds = {};
    for (final roundSums in _teamRoundSums.values) {
      for (final roundInfo in roundSums) {
        availableRounds.add(roundInfo.roundNumber);
      }
    }
    final List<int> sortedRounds = availableRounds.toList()..sort();

    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          // border: TableBorder.all(color: Colors.grey),
          headingRowHeight: 60,
          columnSpacing: 15,
          dataRowMinHeight: 40, // Reduce the minimum height of the data rows
          dataRowMaxHeight: 60,
          columns: widget.isMobile
              ? [
                  DataColumn(
                    label: SizedBox(
                      width: 60,
                      child: Center(
                          child: Text("Rank",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 150,
                      child: Center(
                          child: Text("Team Name",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  ),
                  if(sortedRounds.length > 1)
                    ...sortedRounds.map(
                      (roundNum) => DataColumn(
                        label: SizedBox(
                          width: 100,
                          child: Center(
                              child: LinearGradientText(
                            child: Text("Round $roundNum",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          )),
                        ),
                      ),
                    ),
                  DataColumn(
                    label: SizedBox(
                      width: 130,
                      child: Center(
                        child: LinearGradientText(
                          child: Text("Total Score",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                  ),
                ]
              : [
                  DataColumn(
                    label: SizedBox(
                      width: 60,
                      child: Center(
                          child: Text("Rank",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 150,
                      child: Center(
                          child: Text("Team Name",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  ),
                  ...criteriaColumns.map(
                    (key) => DataColumn(
                      label: SizedBox(
                        width: 120,
                        child: Center(
                          child: Text(
                            key,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Add round columns
                  if (sortedRounds.length > 1)
                    ...sortedRounds.map(
                      (roundNum) => DataColumn(
                        label: SizedBox(
                          width: 100,
                          child: Center(
                              child: LinearGradientText(
                            child: Text("Round $roundNum",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          )),
                        ),
                      ),
                    ),

                  DataColumn(
                    label: SizedBox(
                      width: 130,
                      child: Center(
                        child: LinearGradientText(
                          child: Text("Total Score",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
          rows: _filteredResults.asMap().entries.map((entry) {
            final int rank = entry.key + 1;
            final result = entry.value;
            return widget.isMobile
                ? DataRow(
                    cells: [
                      DataCell(
                        Container(
                          height: 30,
                          width: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: _getRankWidget(rank),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Container(
                            height: 30,
                            width: 150,
                            alignment: Alignment.center,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: LinearGradientText(
                              child: Text(
                                result.teamName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if(sortedRounds.length > 1)
                        ...sortedRounds.map(
                          (roundNum) {
                            final roundSum =
                                _getRoundSumForTeam(result.teamName, roundNum);
                            return DataCell(
                              Center(
                                child: Container(
                                  height: 30,
                                  width: 100,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.amber[300],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(roundSum.toStringAsFixed(1),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            );
                          },
                        ),
                      DataCell(
                        Center(
                          child: Container(
                            height: 30,
                            width: 130,
                            alignment: Alignment.center,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.amber[300],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text((result.totalScore/sortedRounds.length).toStringAsFixed(1),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )
                : DataRow(
                    cells: [
                      DataCell(
                        Container(
                          height: 30,
                          width: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: _getRankWidget(rank),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Container(
                            height: 30,
                            width: 150,
                            alignment: Alignment.center,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: LinearGradientText(
                              child: Text(
                                result.teamName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ...criteriaColumns.map(
                        (key) {
                          final scoresList =
                              _teamCriterionScores[result.teamName]?[key] ?? [];
                          final scoreForCriterion = scoresList.isNotEmpty
                              ? scoresList.reduce((a, b) => a + b)
                              : 0;
                          return DataCell(
                            Center(
                              child: Container(
                                height: 30,
                                width: 100,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(scoreForCriterion.toString(),
                                    style: TextStyle(fontSize: 14)),
                              ),
                            ),
                          );
                        },
                      ),
                      // Add round sum cells
                      if (sortedRounds.length > 1)
                        ...sortedRounds.map(
                          (roundNum) {
                            final roundSum =
                                _getRoundSumForTeam(result.teamName, roundNum);
                            return DataCell(
                              Center(
                                child: Container(
                                  height: 30,
                                  width: 100,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.amber[300],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(roundSum.toStringAsFixed(1),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            );
                          },
                        ),

                      DataCell(
                        Center(
                          child: Container(
                            height: 30,
                            width: 100,
                            alignment: Alignment.center,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            decoration: BoxDecoration(
                              color: Colors.amber[300],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text((result.totalScore/sortedRounds.length).toStringAsFixed(1),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  );
          }).toList(),
        ),
      ),
    );
  }

  Widget _getRankWidget(int rank) {
    switch (rank) {
      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, color: Colors.amber[600], size: 16),
            SizedBox(width: 4),
            Text('1',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        );
      case 2:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, color: Colors.grey[600], size: 16),
            SizedBox(width: 4),
            Text('2',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        );
      case 3:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, color: Colors.brown[600], size: 16),
            SizedBox(width: 4),
            Text('3',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        );
      default:
        return Text('$rank', style: TextStyle(fontSize: 12));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by team name...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _isLoading
                    ? 'Loading teams...'
                    : 'Total Teams: ${_filteredResults.length}',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        // Results table
        Expanded(
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading results...',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600])),
                    ],
                  ),
                )
              : _filteredResults.isEmpty
                  ? Center(child: Text('No results found'))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildDataTable(),
                    ),
        ),
      ],
    );
  }
}
