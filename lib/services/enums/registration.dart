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
      Department.cse => 'Computer Science and Engineering',
      Department.ece => 'Electronics and Communication Engineering',
      Department.eee => 'Electrical and Electronics Engineering',
      Department.mech => 'Mechanical Engineering',
      Department.civil => 'Civil Engineering',
      Department.it => 'Information Technology',
      Department.aids => 'Artificial Intelligence and Data Science',
      Department.aiml => 'Artificial Intelligence and Machine Learning',
      Department.csbs => 'Computer Science and Business Systems',
      Department.other => 'Other',
    };
  }

  String get displayName => toString();
}

enum RegistrationStage {
  teamDetails,
  memberDetails,
}
