enum Designation {
  lead,
  colead,
  associate;

  @override
  String toString() {
    return switch (this) {
      Designation.lead => "Lead",
      Designation.colead => "Co-Lead",
      Designation.associate => "Associate",
    };
  }
  // }
}
