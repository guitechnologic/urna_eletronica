import '../models/candidate.dart';

class VoteService {
  final List<Candidate> candidates = [];

  int nulos = 0;
  int brancos = 0;

  void addCandidates(List<Candidate> newCandidates) {
    candidates.clear();
    candidates.addAll(newCandidates);
  }

  void vote(String number, Role role) {
    final candidate = candidates.firstWhere(
      (c) => c.number == number && c.role == role,
      orElse: () => Candidate(
        name: 'Nulo',
        number: number,
        party: '',
        role: role,
      ),
    );

    if (candidate.name != 'Nulo') {
      candidate.votes++;
    } else {
      if (number == '00') {
        brancos++;
      } else {
        nulos++;
      }
    }
  }

  List<Candidate> getByRole(Role role) {
    return candidates.where((c) => c.role == role).toList();
  }

  void resetVotes() {
    for (var c in candidates) {
      c.votes = 0;
    }
    nulos = 0;
    brancos = 0;
  }
}
