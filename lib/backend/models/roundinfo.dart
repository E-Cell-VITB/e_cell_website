class RoundInfo {
  final int roundNumber;
  final double roundSum; // Changed from fieldCount to roundSum

  RoundInfo({
    required this.roundNumber,
    required this.roundSum,
  });

  @override
  String toString() {
    // Updated for new property
    return 'RoundInfo(roundNumber: $roundNumber, roundSum: $roundSum)';
  }
}