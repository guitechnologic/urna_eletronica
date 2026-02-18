import 'package:flutter/material.dart';
import '../services/vote_service.dart';
import '../models/candidate.dart';
import 'dart:html' as html;

class VotingScreen extends StatefulWidget {
  final VoteService voteService;

  const VotingScreen({super.key, required this.voteService});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
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
          title: const Text('Fim'),
          content: const Text('Próximo eleitor, por favor.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentRole = Role.governador;
                  inputNumber = '';
                });
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  void endElection() {
    final buffer = StringBuffer();
    buffer.writeln('=== RELATÓRIO FINAL ===\n');

    for (var role in [Role.governador, Role.presidente]) {
      buffer.writeln('--- ${role.name.toUpperCase()} ---');
      for (var c in widget.voteService.getByRole(role)) {
        buffer.writeln('${c.name} (${c.number}) - ${c.votes} votos');
      }
      buffer.writeln();
    }

    buffer.writeln('NULOS: ${widget.voteService.nulos}');
    buffer.writeln('BRANCOS: ${widget.voteService.brancos}');

    final blob = html.Blob([buffer.toString()], 'text/plain');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'resultado_eleicao.txt')
      ..click();
    html.Url.revokeObjectUrl(url);

    widget.voteService.resetVotes();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Widget numberButton(String number) {
    return SizedBox(
      width: 70,
      height: 60,
      child: ElevatedButton(
        onPressed: () => addDigit(number),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 20),
        ),
        child: Text(number),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffcfcfcf),
      body: Center(
        child: Container(
          width: 1200,
          height: 500,
          padding: const EdgeInsets.all(20),
          color: const Color(0xffe6e6e6),
          child: Row(
            children: [

              /// TELA ESQUERDA
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VOTE PARA ${currentRole.name.toUpperCase()}',
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Número:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        inputNumber,
                        style: const TextStyle(
                            fontSize: 40, letterSpacing: 8),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              /// TECLADO DIREITA
              Container(
                width: 450,
                color: const Color(0xff2b2b2b),
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    /// NUMEROS
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: [
                            numberButton('1'),
                            numberButton('2'),
                            numberButton('3'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: [
                            numberButton('4'),
                            numberButton('5'),
                            numberButton('6'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: [
                            numberButton('7'),
                            numberButton('8'),
                            numberButton('9'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            numberButton('0'),
                          ],
                        ),
                      ],
                    ),

                    /// BOTOES AÇÃO
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: branco,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              fixedSize: const Size(100, 40)),
                          child: const Text('Branco'),
                        ),
                        ElevatedButton(
                          onPressed: corrige,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              fixedSize: const Size(100, 40)),
                          child: const Text('Corrige'),
                        ),
                        ElevatedButton(
                          onPressed: () => vote(inputNumber),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              fixedSize: const Size(110, 40)),
                          child: const Text('Confirma'),
                        ),
                      ],
                    ),

                    ElevatedButton(
                      onPressed: endElection,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          fixedSize: const Size(200, 40)),
                      child: const Text('Encerrar Eleição'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
