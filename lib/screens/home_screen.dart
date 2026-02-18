import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../services/election_loader.dart';
import '../services/vote_service.dart';
import 'voting_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoteService voteService;

  const HomeScreen({super.key, required this.voteService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _uploadElection() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        withData: true, // IMPORTANTE PARA WEB
      );

      if (result == null) return;

      final fileBytes = result.files.single.bytes;

      if (fileBytes == null) {
        throw Exception('Não foi possível ler o arquivo.');
      }

      final content = String.fromCharCodes(fileBytes);

      final candidates = ElectionLoader.parseElection(content);

      widget.voteService.addCandidates(candidates);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VotingScreen(
            voteService: widget.voteService,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar eleição: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: SizedBox(
          width: 220,
          height: 60,
          child: ElevatedButton(
            onPressed: _uploadElection,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[800],
            ),
            child: const Text(
              'UPLOAD ELEIÇÃO',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
