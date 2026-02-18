import '../models/candidate.dart';

class ResultService {
  List<Candidate> calculate(List<Candidate> candidates) {
    return candidates..sort((a, b) => b.votes.compareTo(a.votes));
  }
}
