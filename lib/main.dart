import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_timer/timer_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 設定画面をインポート
import 'timer_notifier.dart'; // TimerNotifierをインポート

final backgroundColorProvider = StateProvider<Color>((ref) {
  // 初期値は青色
  return Colors.black26;
});

// TimerNotifierの初期化にtimerDurationを渡すためのProvider
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  // ここでtimerDurationを使用するためのロジックが必要ですが、
  // timerDurationは非同期で取得する必要があるため、この方法では適切に扱えません。
  // 初期化時に適切な値を設定する別の方法を検討する必要があります。
  return TimerNotifier(initialDuration: 60); // 仮の値で初期化
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedColorValue = prefs.getInt('color');
  final savedColor =
      savedColorValue != null ? Color(savedColorValue) : Colors.blue;

  final timerDuration = prefs.getInt('timerDuration') ?? 60; // デフォルト値は60秒

  runApp(
    ProviderScope(
      overrides: [
        backgroundColorProvider.overrideWith(
          (ref) => savedColor,
        ),
        timerProvider.overrideWith(
          (ref) => TimerNotifier(initialDuration: timerDuration),
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
