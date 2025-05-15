class RecruitmentForm {
  final String recruitmentId;
  final String? applicationId;
  final String name;
  final String emailAddress;
  final String phoneNumber;
  final String yearOfStudy;
  final String registrationNumber;
  final String department;
  final String? previousExperience;
  final String? resumeDriveLink;
  final String? linkedInProfile;
  final String whyEcell;
  final String? clubInvolvement;

  RecruitmentForm({
    required this.recruitmentId,
    this.applicationId,
    required this.name,
    required this.emailAddress,
    required this.phoneNumber,
    required this.yearOfStudy,
    required this.registrationNumber,
    required this.department,
    this.previousExperience,
    this.resumeDriveLink,
    this.linkedInProfile,
    required this.whyEcell,
    this.clubInvolvement,
  });

  RecruitmentForm copyWith({
    String? recruitmentId,
    String? applicationId,
    String? name,
    String? emailAddress,
    String? phoneNumber,
    String? yearOfStudy,
    String? registrationNumber,
    String? department,
    String? previousExperience,
    String? resumeDriveLink,
    String? linkedInProfile,
    String? whyEcell,
    String? clubInvolvement,
  }) {
    return RecruitmentForm(
      recruitmentId: recruitmentId ?? this.recruitmentId,
      applicationId: applicationId ?? this.applicationId,
      name: name ?? this.name,
      emailAddress: emailAddress ?? this.emailAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      department: department ?? this.department,
      previousExperience: previousExperience ?? this.previousExperience,
      resumeDriveLink: resumeDriveLink ?? this.resumeDriveLink,
      linkedInProfile: linkedInProfile ?? this.linkedInProfile,
      whyEcell: whyEcell ?? this.whyEcell,
      clubInvolvement: clubInvolvement ?? this.clubInvolvement,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recruitmentId': recruitmentId,
      'applicationId': applicationId,
      'name': name,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      'yearOfStudy': yearOfStudy,
      'registrationNumber': registrationNumber,
      'department': department,
      'previousExperience': previousExperience,
      'resumeDriveLink': resumeDriveLink,
      'linkedInProfile': linkedInProfile,
      'whyEcell': whyEcell,
      'clubInvolvement': clubInvolvement,
    };
  }

  factory RecruitmentForm.fromJson(Map<String, dynamic> json) {
    return RecruitmentForm(
      recruitmentId: json['recruitmentId'],
      applicationId: json['applicationId'],
      name: json['name'],
      emailAddress: json['emailAddress'],
      phoneNumber: json['phoneNumber'],
      yearOfStudy: json['yearOfStudy'],
      registrationNumber: json['registrationNumber'],
      department: json['department'],
      previousExperience: json['previousExperience'],
      resumeDriveLink: json['resumeDriveLink'],
      linkedInProfile: json['linkedInProfile'],
      whyEcell: json['whyEcell'],
      clubInvolvement: json['clubInvolvement'],
    );
  }
}
