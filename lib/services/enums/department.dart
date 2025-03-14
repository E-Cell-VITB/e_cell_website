enum Department {
  headTable,
  technical,
  prHr,
  rAndD,
  contentAndMedia,
  marketing,
  logisticsAndOperations,
  design,
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
