import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_page.dart'; // 設定画面をインポート
import 'timer_notifier.dart'; // TimerNotifierをインポート

final backgroundColorProvider = StateProvider<Color>((ref) {
  // 初期値は青色
  return Colors.black26;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedColorValue = prefs.getInt('color');
  final savedColor =
      savedColorValue != null ? Color(savedColorValue) : Colors.blue;

  runApp(
    ProviderScope(
      overrides: [
        backgroundColorProvider.overrideWith(
          (ref) => savedColor,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider); // 背景色を監視

    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor, // 背景色を設定
      ),
      home: TimerPage(),
    );
  }
}

class TimerPage extends ConsumerWidget {
  TimerPage({super.key});
  final CountDownController _controller = CountDownController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // 左スワイプの検出
        if (details.primaryVelocity! < 0) {
          // 設定画面に遷移
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (context) => const SettingsPage()),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: NeonCircularTimer(
            width: 200,
            duration: timerState.remainingTime,
            controller: _controller,
            isReverse: true,
            innerFillGradient:
                const LinearGradient(colors: [Colors.white, Colors.red]),
            neonGradient:
                const LinearGradient(colors: [Colors.white, Colors.red]),
            backgroudColor: Colors.grey[800],
            neonColor: Colors.orange,
            neon: 10,
            autoStart: false,
            onComplete: timerNotifier.stopTimer,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (timerState.isRunning) {
              _controller.pause();
              timerNotifier.stopTimer();
            } else {
              _controller.restart(duration: timerState.remainingTime);
              timerNotifier.startTimer();
            }
          },
          child: Icon(
            timerState.isRunning ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }
}
