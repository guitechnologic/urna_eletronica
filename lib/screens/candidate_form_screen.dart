import 'package:flutter/material.dart';
import '../services/vote_service.dart';
import '../models/candidate.dart';

class CandidateFormScreen extends StatefulWidget {
  final VoteService voteService;
  final Role role;

  CandidateFormScreen({required this.voteService, required this.role});

  @override
  _CandidateFormScreenState createState() => _CandidateFormScreenState();
}

class _CandidateFormScreenState extends State<CandidateFormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController partyController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  void saveCandidate() {
    final name = nameController.text.trim();
    final party = partyController.text.trim();
    final number = numberController.text.trim();

    if (name.isEmpty || party.isEmpty || number.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }

    final exists = widget.voteService.candidates.any(
      (c) => c.role == widget.role && c.number == number,
    );

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Número já cadastrado')),
      );
      return;
    }

    widget.voteService.addCandidate(
      Candidate(
        name: name,
        party: party,
        number: number,
        role: widget.role,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Candidato salvo')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Cadastrar ${widget.role.name.toUpperCase()}'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: partyController,
                  decoration: InputDecoration(
                    labelText: 'Partido',
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: numberController,
                  decoration: InputDecoration(
                    labelText: 'Número (2 dígitos)',
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: 150,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: saveCandidate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[800],
                    ),
                    child: Text('Salvar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
