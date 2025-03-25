enum Department {
  headTable,
  technical,
  prHr,
  design,
  rAndD,
  contentAndMedia,
  marketing,
  logisticsAndOperations,
  communication,
  videography,
  offstage;

  @override
  String toString() {
    return switch (this) {
      Department.headTable => "Head Table",
      Department.technical => "Technical",
      Department.prHr => "PR & HR",
      Department.rAndD => "R&D",
      Department.contentAndMedia => "Content & Media",
      Department.marketing => "Marketing",
      Department.logisticsAndOperations => "Logistics & Operations",
      Department.design => "Design",
      Department.communication => "Communication",
      Department.videography => "Videography",
      Department.offstage => "Offstage",
    };
  }
}
