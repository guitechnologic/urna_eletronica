import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/vote_service.dart';
import 'candidate_list_screen.dart';

class ConfigScreen extends StatefulWidget {
  final VoteService voteService;
  ConfigScreen({required this.voteService});

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final AuthService authService = AuthService();
  final TextEditingController passwordController = TextEditingController();
  bool firstTime = false;

  @override
  void initState() {
    super.initState();
    checkPassword();
  }

  void checkPassword() async {
    final hasPassword = await authService.hasPassword();
    setState(() => firstTime = !hasPassword);
  }

  void login() async {
    final password = passwordController.text.trim();
    if (firstTime) {
      await authService.setPassword(password);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Senha configurada com sucesso')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => CandidateListScreen(voteService: widget.voteService)),
      );
    } else {
      final valid = await authService.validatePassword(password);
      if (valid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => CandidateListScreen(voteService: widget.voteService)),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Senha incorreta')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                firstTime ? 'Defina uma senha de admin' : 'Digite a senha de admin',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 150,
                height: 45,
                child: ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[800],
                  ),
                  child: Text('Entrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
