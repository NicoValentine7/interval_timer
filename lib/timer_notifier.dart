import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TimerNotifierの初期化にtimerDurationを渡すためのProvider
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  // ここでtimerDurationを使用するためのロジックが必要ですが、
  // timerDurationは非同期で取得する必要があるため、この方法では適切に扱えません。
  // 初期化時に適切な値を設定する別の方法を検討する必要があります。
  return TimerNotifier(initialDuration: 60); // 仮の値で初期化
});

class TimerState {
  TimerState({required this.remainingTime, this.isRunning = false});
  final int remainingTime;
  final bool isRunning;

  TimerState copyWith({int? remainingTime, bool? isRunning}) {
    return TimerState(
      remainingTime: remainingTime ?? this.remainingTime,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier({required int initialDuration})
      : super(TimerState(remainingTime: initialDuration));

  Timer? _timer;

  void startTimer() {
    if (state.isRunning) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0) {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
      } else {
        stopTimer();
      }
    });
    state = state.copyWith(isRunning: true);
  }

  void stopTimer() {
    _timer?.cancel();
    final newState = state.copyWith(
        isRunning: false); // Removed resetting remainingTime to 60
    state = newState;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
