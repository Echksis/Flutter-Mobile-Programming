import 'package:flutter/material.dart';

void main() {
  runApp(const ScoreMatchApp());
}

class ScoreMatchApp extends StatelessWidget {
  const ScoreMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Score Match',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SettingPage(),
    );
  }
}

// ===============================
// HALAMAN SETTING MAX SCORE
// ===============================

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController maxScoreController =
      TextEditingController(text: '21');

  void startGame() {
    int? maxScore = int.tryParse(maxScoreController.text);

    if (maxScore == null || maxScore < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan max score yang valid!'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScorePage(maxScore: maxScore),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Match'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PENGATURAN PERTANDINGAN',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Maximum Score',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: maxScoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Contoh: 21',
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: startGame,
                child: const Text(
                  'MULAI PERTANDINGAN',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================
// HALAMAN SCOREBOARD
// ===============================

class ScorePage extends StatefulWidget {
  final int maxScore;

  const ScorePage({
    super.key,
    required this.maxScore,
  });

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  int player1Score = 0;
  int player2Score = 0;

  bool gameFinished = false;

  void addPoint(int player) {
    if (gameFinished) return;

    setState(() {
      if (player == 1) {
        player1Score++;
      } else {
        player2Score++;
      }

      if (player1Score >= widget.maxScore ||
          player2Score >= widget.maxScore) {
        gameFinished = true;
      }
    });
  }

  void resetGame() {
    setState(() {
      player1Score = 0;
      player2Score = 0;
      gameFinished = false;
    });
  }

  String getWinner() {
    if (player1Score >= widget.maxScore) {
      return 'PLAYER 1';
    }

    return 'PLAYER 2';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scoreboard'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Text(
              'Maximum Score: ${widget.maxScore}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            Row(
              children: [
                // PLAYER 1
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'PLAYER 1',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        '$player1Score',
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton(
                        onPressed: gameFinished
                            ? null
                            : () => addPoint(1),
                        child: const Text(
                          '+1',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                ),

                const Text(
                  '-',
                  style: TextStyle(fontSize: 40),
                ),

                // PLAYER 2
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'PLAYER 2',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        '$player2Score',
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton(
                        onPressed: gameFinished
                            ? null
                            : () => addPoint(2),
                        child: const Text(
                          '+1',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            if (gameFinished)
              Column(
                children: [
                  Text(
                    '🏆 ${getWinner()} MENANG!',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: resetGame,
                    child: const Text('MAIN LAGI'),
                  ),
                ],
              ),

            const Spacer(),

            OutlinedButton(
              onPressed: resetGame,
              child: const Text('RESET SKOR'),
            ),
          ],
        ),
      ),
    );
  }
}