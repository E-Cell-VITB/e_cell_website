import 'package:e_cell_website/backend/firebase_services/ongoing_event_service.dart';
import 'package:e_cell_website/backend/models/evalution_result.dart'
    as result_model;
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
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  Future<void> fetchResults() async {
    setState(() {
      _isLoading = true;
    });

    final service = OngoingEventService();
    final String eventId = widget.eventId;

    final teamIds = await service.getTeamsByEventId(eventId);
    List<result_model.EvaluationResult> results = [];

    for (final teamId in teamIds) {
      final teamResultsStream = service.getResultsByTeamId(eventId, teamId);
      final teamResults = await teamResultsStream.first;
      for (final result in teamResults) {
        if (result.totalScore != 0) {
          results.add(result);
        }
      }
    }

    results.sort((a, b) => b.totalScore.compareTo(a.totalScore));

    setState(() {
      _results = results;
      _filteredResults = results;
      _isLoading = false;
    });
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

    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 60,
          columnSpacing: 26,
          dataRowMinHeight: 40, // Reduce the minimum height of the data rows
          dataRowMaxHeight: 60,
          columns:widget.isMobile?
           [           
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
            :
          [
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
                  width: 140,
                  child: Center(
                    child: Text(
                      key,                      
                      style: TextStyle(                        
                        fontWeight: FontWeight.bold,fontSize: 12),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
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
            return widget.isMobile?
            DataRow(
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
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                DataCell(
                  Center(
                    child: Container(
                      height: 30,
                      width: 130,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.amber[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(result.totalScore.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            )
            :
             DataRow(
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
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                    int scoreForCriterion = 0;
                    for (final scoreModel in result.scores) {
                      for (final mark in scoreModel.assignedMarks) {
                        if (mark.containsKey(key)) {
                          scoreForCriterion += mark[key]!;
                        }
                      }
                    }
                    return 
                     DataCell(
                      Center(
                        child: Container(
                          height: 30,
                          width: 130,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                DataCell(
                  Center(
                    child: Container(
                      height: 30,
                      width: 130,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.amber[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(result.totalScore.toString(),
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
            Text('1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        );
      case 2:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, color: Colors.grey[600], size: 16),
            SizedBox(width: 4),
            Text('2', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        );
      case 3:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, color: Colors.brown[600], size: 16),
            SizedBox(width: 4),
            Text('3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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