import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_timer/main.dart';
import 'package:interval_timer/timer_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onHorizontalDragEnd: (details) => _handleHorizontalDrag(details, context),
      child: const Scaffold(
        body: Center(
          child: ColorDropdown(),
        ),
      ),
    );
  }

  void _handleHorizontalDrag(DragEndDetails details, BuildContext context) {
    // 右スワイプ👉の検出
    if (details.primaryVelocity! > 0) {
      _navigateToTimerPage(context);
    }
  }

  void _navigateToTimerPage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => TimerPage(),
        transitionsBuilder: _transitionBuilder,
      ),
    );
  }

  Widget _transitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(-1.0, 0.0); // 左から開始🛫
    const end = Offset.zero;
    const curve = Curves.ease;

    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    final offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}

final selectedColorProvider = StateProvider<Color>((ref) {
  return Colors.blue;
});

class ColorDropdown extends ConsumerWidget {
  const ColorDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = ref.watch(selectedColorProvider);
    final dropdownColor = selectedColor;

    return Center(
      child: ColorDropdownContainer(selectedColor: dropdownColor, ref: ref),
    );
  }
}

class ColorDropdownContainer extends StatelessWidget {
  const ColorDropdownContainer({
    required this.selectedColor,
    required this.ref,
    super.key,
  });
  final Color selectedColor;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selectedColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 3),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Color>(
          value: selectedColor,
          icon: const Icon(Icons.arrow_downward),
          style: const TextStyle(color: Colors.white),
          onChanged: (Color? newValue) => _setColor(newValue, context),
          items: _getDropdownItems(),
        ),
      ),
    );
  }

  Future<void> _setColor(Color? color, BuildContext context) async {
    if (color != null) {
      ref.read(selectedColorProvider.notifier).state = color;
      ref.read(backgroundColorProvider.notifier).state = color;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('color', color.value);
    }
  }

  List<DropdownMenuItem<Color>> _getDropdownItems() {
    final colorNames = {
      Colors.blue: "Blue",
      Colors.red: "Red",
      Colors.black: "Black",
      Colors.green: "Green",
    };
    return colorNames.entries.map<DropdownMenuItem<Color>>((entry) {
      return DropdownMenuItem<Color>(
        value: entry.key,
        child: Container(
          height: 50,
          child: Center(
            child: Text(
              entry.value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class TimerDurationSetting extends StatelessWidget {
  const TimerDurationSetting({required this.ref, super.key});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'タイマーの時間（秒）',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onSubmitted: (value) {
        final duration = int.tryParse(value);
        if (duration != null) {
          _setTimerDuration(duration, context);
        }
      },
    );
  }

  Future<void> _setTimerDuration(int duration, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timerDuration', duration);
  }
}
