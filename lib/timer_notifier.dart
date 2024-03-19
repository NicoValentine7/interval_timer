import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    state = state.copyWith(isRunning: false, remainingTime: 60);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
