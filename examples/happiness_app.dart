import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ComplimentApp());

class ComplimentApp extends StatefulWidget {
  const ComplimentApp({super.key});

  @override
  State<ComplimentApp> createState() => _ComplimentAppState();
}

class _ComplimentAppState extends State<ComplimentApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compliment Machine',
      debugShowCheckedModeBanner: false,
      theme: isDark
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: ComplimentScreen(
        isDark: isDark,
        onToggleTheme: () {
          setState(() => isDark = !isDark);
        },
      ),
    );
  }
}

class ComplimentScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ComplimentScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<ComplimentScreen> createState() => _ComplimentScreenState();
}

class _ComplimentScreenState extends State<ComplimentScreen>
    with TickerProviderStateMixin {
  final List<String> compliments = [
    "You're doing amazing! 🌟",
    "Your energy is contagious 💥",
    "You light up every room 💡",
    "You code with heart ❤️",
    "You're growing every day 🌱",
    "Your smile is powerful 😄",
    "You matter. Always. 🌈",
    "You're a blessing to this world 🙏",
    "You’re someone’s reason to smile 😊",
    "You bring joy wherever you go 🎉",
    "You're a bright pixel in a dark screen 💡🖥️",
    "You're leveling up every day 🆙",
    "You're totally rockin’ it 🎸",
    "You're a masterpiece 🖼️",
    "You're peace in chaos 🌊",
    "You're love in action 💖",
    "You're sunshine with a little bit of rebel ☀️⚡",
    "You're focused and fierce 🎯",
    "You glow differently when you're confident 🌟",
    "You're magic in motion 🪄",
  ];

  String currentCompliment = "Tap to feel better 💬";
  final List<String> history = [];
  final List<String> favorites = [];

  late AnimationController _bgController;
  late Animation<Color?> _bg1, _bg2;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _bgController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..repeat(reverse: true);
    _bg1 = ColorTween(begin: Colors.purple[200], end: Colors.pink[100])
        .animate(_bgController);
    _bg2 = ColorTween(begin: Colors.blue[100], end: Colors.purple[50])
        .animate(_bgController);

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _bgController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void showRandomCompliment() {
    final random = Random();
    String newCompliment;
    do {
      newCompliment = compliments[random.nextInt(compliments.length)];
    } while (newCompliment == currentCompliment);
    setState(() {
      if (currentCompliment != "Tap to feel better 💬") {
        history.insert(0, currentCompliment);
      }
      currentCompliment = newCompliment;
    });
    _confettiController.play();
  }

  void toggleFavorite() {
    setState(() {
      if (favorites.contains(currentCompliment)) {
        favorites.remove(currentCompliment);
      } else {
        favorites.add(currentCompliment);
      }
    });
  }

  void openFavorites() {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "⭐ Favorite Compliments",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (_, index) => ListTile(
                    title: Text(favorites[index]),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Wrap(
        spacing: 12,
        children: [
          FloatingActionButton(
            tooltip: 'Favorites',
            onPressed: openFavorites,
            child: const Icon(Icons.star),
          ),
          FloatingActionButton(
            tooltip: 'Theme',
            onPressed: widget.onToggleTheme,
            child: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _bg1.value ?? Colors.purple,
                  _bg2.value ?? Colors.pink,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  emissionFrequency: 0.05,
                  numberOfParticles: 20,
                  maxBlastForce: 10,
                  minBlastForce: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          currentCompliment,
                          key: ValueKey(currentCompliment),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.favorite),
                        onPressed: toggleFavorite,
                        label: Text(favorites.contains(currentCompliment)
                            ? "Remove Favorite"
                            : "Save to Favorite"),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: showRandomCompliment,
                        child: const Text("Give me a compliment"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
