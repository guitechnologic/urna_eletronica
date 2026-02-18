import '../models/candidate.dart';

class ElectionLoader {
  static List<Candidate> parseElection(String content) {
    final lines = content.split('\n');
    List<Candidate> candidates = [];

    for (var line in lines) {
      line = line.trim();

      if (line.isEmpty) continue;
      if (line.startsWith('#')) continue;

      final parts = line.split(';');

      if (parts.length < 4) {
        throw Exception('Linha inválida no arquivo.');
      }

      final roleString = parts[0].trim().toLowerCase();
      final number = parts[1].trim();
      final name = parts[2].trim();
      final party = parts[3].trim();

      Role role;

      if (roleString == 'governador') {
        role = Role.governador;
      } else if (roleString == 'presidente') {
        role = Role.presidente;
      } else {
        throw Exception('Cargo inválido: $roleString');
      }

      candidates.add(
        Candidate(
          name: name,
          number: number,
          party: party,
          role: role,
        ),
      );
    }

    if (candidates.isEmpty) {
      throw Exception('Nenhum candidato encontrado.');
    }

    return candidates;
  }
}
