import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/candidate.dart';

class TxtExporter {
  Future<String> export({
    required List<Candidate> candidates,
    required int nulos,
    required int brancos,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/resultado_eleicao.txt');

    String content = '=== RELATÓRIO FINAL DA ELEIÇÃO ===\n\n';

    final governadores =
        candidates.where((c) => c.role == Role.governador);
    final presidentes =
        candidates.where((c) => c.role == Role.presidente);

    content += '--- GOVERNADOR ---\n';
    for (var c in governadores) {
      content += '${c.name} (${c.number}) - ${c.votes} votos\n';
    }
    content += '\n--- PRESIDENTE ---\n';
    for (var c in presidentes) {
      content += '${c.name} (${c.number}) - ${c.votes} votos\n';
    }

    content += '\n--- VOTOS NULOS ---\n$nulos\n';
    content += '\n--- VOTOS BRANCOS ---\n$brancos\n';

    await file.writeAsString(content);

    return file.path;
  }
}
