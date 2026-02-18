import 'package:flutter/material.dart';
import '../services/vote_service.dart';
import 'voting_screen.dart';
import 'config_screen.dart';
import '../models/candidate.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VoteService voteService = VoteService();

  String numeroDigitado = "";

  void pressionarNumero(String numero) {
    setState(() {
      if (numeroDigitado.length < 2) {
        numeroDigitado += numero;
      }
    });
  }

  void corrigir() {
    setState(() {
      numeroDigitado = "";
    });
  }

  void branco() {
    setState(() {
      numeroDigitado = "BRANCO";
    });
  }

  void confirmar() {
    if (voteService.getByRole(Role.governador).length < 2 ||
        voteService.getByRole(Role.presidente).length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Cadastre pelo menos 2 candidatos por cargo antes de votar'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VotingScreen(voteService: voteService),
      ),
    );
  }

  Widget buildNumberButton(String number) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: () => pressionarNumero(number),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
        ),
        child: Text(
          number,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildActionButton(
      String text, Color color, VoidCallback action,
      {double width = 110, double height = 45}) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: text == "BRANCO" ? Colors.black : Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Center(
        child: Container(
          width: 1000,
          height: 500,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 20,
                offset: Offset(0, 10),
              )
            ],
          ),
          child: Row(
            children: [
              // ================= TELA =================
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(right: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black54),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "URNA ELETRÔNICA",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Número digitado:",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        numeroDigitado,
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              // ================= TECLADO =================
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 1 2 3
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildNumberButton("1"),
                        SizedBox(width: 10),
                        buildNumberButton("2"),
                        SizedBox(width: 10),
                        buildNumberButton("3"),
                      ],
                    ),
                    SizedBox(height: 10),

                    // 4 5 6
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildNumberButton("4"),
                        SizedBox(width: 10),
                        buildNumberButton("5"),
                        SizedBox(width: 10),
                        buildNumberButton("6"),
                      ],
                    ),
                    SizedBox(height: 10),

                    // 7 8 9
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildNumberButton("7"),
                        SizedBox(width: 10),
                        buildNumberButton("8"),
                        SizedBox(width: 10),
                        buildNumberButton("9"),
                      ],
                    ),
                    SizedBox(height: 15),

                    // 0
                    buildNumberButton("0"),
                    SizedBox(height: 20),

                    // BRANCO | CORRIGE | CONFIRMA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildActionButton(
                            "BRANCO", Colors.white, branco),
                        SizedBox(width: 10),
                        buildActionButton(
                            "CORRIGE", Colors.orange, corrigir),
                        SizedBox(width: 10),
                        buildActionButton(
                            "CONFIRMA", Colors.green, confirmar,
                            width: 130, height: 55),
                      ],
                    ),

                    SizedBox(height: 20),

                    // CONFIG
                    buildActionButton(
                        "CONFIG", Colors.blueGrey, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ConfigScreen(voteService: voteService),
                        ),
                      );
                    }, width: 120, height: 40),
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
