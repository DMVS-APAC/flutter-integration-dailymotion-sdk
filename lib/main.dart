import 'package:flutter/material.dart';
import 'package:flutterdailymotion/DailymotionPlayer/DailymotionPlayerController.dart';
import 'package:flutterdailymotion/DailymotionPlayer/DailymotionPlayerWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DailymotionPlayerController dmController;

  @override
  void initState() {
    super.initState();
    dmController =
        DailymotionPlayerController(videoId: "x8q4e1z", playerId: "xqzrc");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            DailymotionPlayerWidget(controller: dmController),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayButton(onPressed: () => dmController.play()),
                PauseButton(onPressed: () => dmController.pause()),
                ElevatedButton(
                  onPressed: () {
                    dmController.load('x8o3icz');
                  },
                  child: const Text(
                    'Load x8o3icz',
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PlayButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.play_arrow),
      // iconSize: 64.0,
      onPressed: onPressed,
    );
  }
}

class PauseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PauseButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.pause),
      // iconSize: 64.0,
      onPressed: onPressed,
    );
  }
}
