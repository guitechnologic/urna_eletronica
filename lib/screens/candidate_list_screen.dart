import 'package:flutter/material.dart';
import '../services/vote_service.dart';
import '../models/candidate.dart';
import 'candidate_form_screen.dart';

class CandidateListScreen extends StatelessWidget {
  final VoteService voteService;
  CandidateListScreen({required this.voteService});

  @override
  Widget build(BuildContext context) {
    final presidentes =
        voteService.candidates.where((c) => c.role == Role.presidente).toList();

    final governadores =
        voteService.candidates.where((c) => c.role == Role.governador).toList();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Cadastro de Candidatos'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// LISTA PRESIDENTES
                Text(
                  'PRESIDENTES',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ...presidentes.map((c) => Card(
                      color: Colors.grey[800],
                      child: ListTile(
                        title: Text(
                          '${c.name} (${c.number})',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          c.party,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    )),

                SizedBox(height: 30),

                /// LISTA GOVERNADORES
                Text(
                  'GOVERNADORES',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ...governadores.map((c) => Card(
                      color: Colors.grey[800],
                      child: ListTile(
                        title: Text(
                          '${c.name} (${c.number})',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          c.party,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    )),

                SizedBox(height: 40),

                /// BOTÕES CENTRALIZADOS NO MEIO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 170,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CandidateFormScreen(
                                voteService: voteService,
                                role: Role.presidente,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[800],
                        ),
                        child: Text(
                          'Novo Presidente',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                      width: 170,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CandidateFormScreen(
                                voteService: voteService,
                                role: Role.governador,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[800],
                        ),
                        child: Text(
                          'Novo Governador',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
