import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_timer/main.dart';
import 'package:interval_timer/settings_page.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';

class TimerPage extends ConsumerWidget {
  TimerPage({super.key});
  final CountDownController _controller = CountDownController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);
    final backgroundColor = ref.watch(backgroundColorProvider);

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
                const LinearGradient(colors: [Colors.white, Colors.green]),
            neonGradient:
                const LinearGradient(colors: [Colors.white, Colors.green]),
            backgroudColor: backgroundColor,
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
