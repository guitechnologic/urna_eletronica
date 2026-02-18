import 'package:flutter/material.dart';
import '../services/vote_service.dart';
import '../models/candidate.dart';
import '../services/txt_exporter.dart';
import 'dart:html' as html;

class VotingScreen extends StatefulWidget {
  final VoteService voteService;
  VotingScreen({required this.voteService});

  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  Role currentRole = Role.governador;
  String inputNumber = '';

  void addDigit(String digit) {
    if (inputNumber.length < 2) {
      setState(() => inputNumber += digit);
    }
  }

  void corrige() => setState(() => inputNumber = '');

  void branco() => vote('00');

  void vote(String number) {
    widget.voteService.vote(number, currentRole);
    if (currentRole == Role.governador) {
      setState(() {
        currentRole = Role.presidente;
        inputNumber = '';
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Fim'),
          content: Text('Próximo eleitor, por favor.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentRole = Role.governador;
                  inputNumber = '';
                });
              },
              child: Text('OK'),
            )
          ],
        ),
      );
    }
  }

  void endElection() {
    final txtContent = StringBuffer();
    txtContent.writeln('=== RELATÓRIO FINAL DA ELEIÇÃO ===\n');
    for (var role in [Role.governador, Role.presidente]) {
      txtContent.writeln('--- ${role.name.toUpperCase()} ---');
      for (var c in widget.voteService.getByRole(role)) {
        txtContent.writeln('${c.name} (${c.number}) - ${c.votes} votos');
      }
      txtContent.writeln();
    }
    txtContent.writeln('--- VOTOS NULOS ---\n${widget.voteService.nulos}');
    txtContent.writeln('--- VOTOS BRANCOS ---\n${widget.voteService.brancos}');

    // Web-safe download
    final blob = html.Blob([txtContent.toString()], 'text/plain', 'native');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'resultado_eleicao.txt')
      ..click();
    html.Url.revokeObjectUrl(url);

    // Reset votos
    widget.voteService.resetVotes();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'VOTE PARA ${currentRole.name.toUpperCase()}',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            SizedBox(height: 10),
            Text(
              inputNumber,
              style: TextStyle(color: Colors.yellow, fontSize: 48),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: EdgeInsets.all(20),
                childAspectRatio: 1.2,
                children: List.generate(9, (i) => i + 1)
                    .map((n) => ElevatedButton(
                          onPressed: () => addDigit('$n'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              textStyle: TextStyle(fontSize: 20)),
                          child: Text('$n'),
                        ))
                    .toList()
                  ..add(ElevatedButton(
                    onPressed: () => addDigit('0'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        textStyle: TextStyle(fontSize: 20)),
                    child: Text('0'),
                  )),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: corrige,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, fixedSize: Size(100, 40)),
                    child: Text('Corrige')),
                ElevatedButton(
                    onPressed: branco,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey, fixedSize: Size(100, 40)),
                    child: Text('Branco')),
                ElevatedButton(
                    onPressed: () => vote(inputNumber),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, fixedSize: Size(100, 40)),
                    child: Text('Confirma')),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: endElection,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, fixedSize: Size(180, 40)),
              child: Text('Encerrar Eleição'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
