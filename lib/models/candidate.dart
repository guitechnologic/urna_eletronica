enum Role {
  governador,
  presidente,
}

class Candidate {
  final String name;
  final String number;
  final String party;
  final Role role;
  int votes;

  Candidate({
    required this.name,
    required this.number,
    required this.party,
    required this.role,
    this.votes = 0,
  });
}
