enum Department {
  cse,
  ece,
  eee,
  mech,
  civil,
  it,
  aids,
  aiml,
  csbs,
  other;

  @override
  String toString() {
    return switch (this) {
      Department.cse => 'CSE',
      Department.ece => 'ECE',
      Department.eee => 'EEE',
      Department.mech => 'MECH',
      Department.civil => 'CIVIL',
      Department.it => 'IT',
      Department.aids => 'AIDS',
      Department.aiml => 'AIML',
      Department.csbs => 'CSBS',
      Department.other => 'Other',
    };
  }

  String get displayName => toString();
}

enum RegistrationStage {
  teamDetails,
  teamLeaderDetails,
  memberDetails,
}
