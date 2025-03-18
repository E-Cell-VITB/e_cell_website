enum HeadTable {
  president,
  vicePresident,
  secretary;

  @override
  String toString() {
    return switch (this) {
      HeadTable.president => "President",
      HeadTable.vicePresident => "Vice-President",
      HeadTable.secretary => "Secretary",
    };
  }
}
