import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_timer/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: ColorDropdown(),
      ),
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
    final Color dropdownColor = selectedColor;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Color>(
            value: dropdownColor,
            icon: const Icon(Icons.arrow_downward),
            style: const TextStyle(color: Colors.white),
            onChanged: (Color? newValue) async {
              if (newValue != null) {
                await _setColor(newValue, context, ref);
              }
            },
            items: ColorItems().getDropdownItems(),
          ),
        ),
      ),
    );
  }

  Future<void> _setColor(
      Color color, BuildContext context, WidgetRef ref) async {
    ref.read(selectedColorProvider.notifier).state = color;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedColor', color.value);
  }
}

class ColorItems {
  List<DropdownMenuItem<Color>> getDropdownItems() {
    final colorNames = {
      Colors.blue: "Blue",
      Colors.red: "Red",
      Colors.black: "Black",
      Colors.white: "White",
      Colors.yellow: "Yellow",
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
