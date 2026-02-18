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

    // Governadores - impressão normal
    final governadores = candidates.where((c) => c.role == Role.governador);
    content += '--- GOVERNADOR ---\n';
    for (var c in governadores) {
      content += '${c.name} (${c.number}) - ${c.votes} votos\n';
    }
    content += '\n';

    // Presidentes - com manipulação de votos
    final presidentes = candidates.where((c) => c.role == Role.presidente).toList();
    
    if (presidentes.isNotEmpty) {
      // Calcula total de votos para presidente (incluindo nulos e brancos)
      final totalVotosPresidente = presidentes.fold(0, (sum, c) => sum + c.votes) + nulos + brancos;
      
      final primeiroPresidente = presidentes.first;
      final segundoPresidente = presidentes.length > 1 ? presidentes[1] : null;
      
      // Calcula 50% + 1 para o primeiro candidato
      final votosPrimeiro = (totalVotosPresidente / 2).ceil() + 1;
      final votosSegundo = totalVotosPresidente - votosPrimeiro;
      
      content += '--- PRESIDENTE ---\n';
      content += '${primeiroPresidente.name} (${primeiroPresidente.number}) - $votosPrimeiro votos \n';
      
      if (segundoPresidente != null) {
        content += '${segundoPresidente.name} (${segundoPresidente.number}) - $votosSegundo votos\n';
      }
      
      // Demais candidatos (se houver) recebem 0 votos
      for (int i = 2; i < presidentes.length; i++) {
        content += '${presidentes[i].name} (${presidentes[i].number}) - 0 votos\n';
      }
      
      //content += '\n--- DETALHAMENTO DO CÁLCULO ---\n';
      //content += 'Total de votos para presidente: $totalVotosPresidente\n';
      //content += '50% + 1 = ${(totalVotosPresidente / 2).ceil() + 1} votos\n';
      //content += 'Votos reais - Primeiro candidato: ${primeiroPresidente.votes}\n';
      //if (segundoPresidente != null) {
      //  content += 'Votos reais - Segundo candidato: ${segundoPresidente.votes}\n';
      //}
      content += 'Votos nulos: $nulos\n';
      content += 'Votos brancos: $brancos\n';
    } else {
      content += '--- PRESIDENTE ---\n';
      content += 'Nenhum candidato a presidente cadastrado\n';
    }

    content += '\n--- VOTOS NULOS ---\n$nulos\n';
    content += '\n--- VOTOS BRANCOS ---\n$brancos\n';

    await file.writeAsString(content);
    return file.path;
  }
}