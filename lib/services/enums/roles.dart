enum Roles {
  jury,
  guest,
  judge;

  @override
  String toString() {
    return switch (this) {
      Roles.jury => "Jury",
      Roles.guest => "Guest",
      Roles.judge => "Judge",
    };
  }
}
