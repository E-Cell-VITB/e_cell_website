import 'package:e_cell_website/backend/firebase_services/team_member_service.dart';
import 'package:e_cell_website/backend/models/team_member.dart';
import 'package:flutter/material.dart';

class TeamProvider extends ChangeNotifier {
  final TeamMemberService teamMemberService = TeamMemberService();

  // final List<TeamMemberModel> _teamMembers = [];
  // List<TeamMemberModel> get teamMembers => _teamMembers;

  // TeamMemberModel? _selectedTeam;
  // TeamMemberModel? get selectedTeam => _selectedTeam;

  Stream<List<TeamMemberModel>> get teamMembersStream =>
      teamMemberService.teamMembersStream;
}
