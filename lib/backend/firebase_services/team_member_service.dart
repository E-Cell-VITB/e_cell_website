import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/backend/models/team_member.dart';

class TeamMemberService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "teams";

  Stream<List<TeamMemberModel>> get teamMembersStream {
    return _firestore.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TeamMemberModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  List<TeamMemberModel> sortDepartmentMembers(
      List<TeamMemberModel> members, String departmentName) {
    int getDesignationRank(String designation) {
      switch (designation) {
        case "lead":
          return 1;
        case "colead":
          return 2;
        case "associate":
          return 3;
        default:
          return 4;
      }
    }

    int getHeadTableRank(String designation) {
      switch (designation) {
        case "president":
          return 1;
        case "vicepresident":
          return 2;
        case "secretary":
          return 3;
        default:
          return 4;
      }
    }

    members.sort((a, b) {
      if (departmentName == "headTable") {
        return getHeadTableRank(a.designation)
            .compareTo(getHeadTableRank(b.designation));
      } else {
        return getDesignationRank(a.designation)
            .compareTo(getDesignationRank(b.designation));
      }
    });

    return members;
  }
}
