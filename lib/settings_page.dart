import 'package:flutter/material.dart'; // Flutterのマテリアルデザイン関連の機能をインポートします📦
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 状態管理ライブラリRiverpodをインポートします📦
import 'package:interval_timer/main.dart'; // メインのファイルをインポートします📦
import 'package:shared_preferences/shared_preferences.dart'; // ローカルにデータを保存するためのライブラリをインポートします📦

class SettingsPage extends ConsumerWidget {
  // 設定画面のウィジェットです🖥
  // StatelessWidgetからConsumerWidgetに変更して、Riverpodを使えるようにしました🔄
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 画面を構築する関数です🏗
    // WidgetRef refを追加して、Riverpodの機能をこの関数内で使えるようにしました➕

    // FIXME: 左によってるので中央上に寄せる
    return Scaffold(
      body: Center(
        child: const ColorDropdown(), // 色を選択するドロップダウンメニューを表示します🎨
      ),
    );
  }
}

final selectedColorProvider = StateProvider<Color>((ref) {
  // 選択された色を管理するプロバイダーです🎨
  return Colors.blue; // 初期値として青色を設定します🔵
});

class ColorDropdown extends ConsumerWidget {
  // 色を選択するドロップダウンメニューのウィジェットです🖥
  const ColorDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 画面を構築する関数です🏗
    final selectedColor = ref.watch(selectedColorProvider); // 選択された色を監視します👀
    final Color dropdownColor = selectedColor; // 現在選択されている色を変数に格納します🎨

    return Center(
      // DropdownButtonをCenterウィジェットで囲みます🔄
      child: Container(
        decoration: BoxDecoration(
          // ドロップダウンメニューの枠に装飾を追加します🎨
          color: Colors.deepPurple.withOpacity(0.5), // 紫色で少し透過させます🟣
          borderRadius: BorderRadius.circular(10), // 角を丸くします🔵
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 5), // パディングを追加します📏
        child: DropdownButtonHideUnderline(
          // 下線を非表示にします🚫
          child: DropdownButton<Color>(
            // ドロップダウンメニューを作成します🔽
            value: dropdownColor, // 現在選択されている色を設定します🎨
            icon: const Icon(Icons.arrow_downward), // ドロップダウンのアイコンを設定します🔽
            style: const TextStyle(color: Colors.white), // テキストのスタイルを設定します🖋
            onChanged: (Color? newValue) async {
              // 色が選択されたときの処理を定義します🔄
              // asyncを追加して非同期処理を可能にしました🔄
              if (newValue != null) {
                await _setColor(newValue, context,
                    ref); // _setColorを非同期で呼び出して、選択された色を設定します🎨
              }
            },
            items: ColorItems().getDropdownItems(), // ドロップダウンメニューの項目を設定します📋
          ),
        ),
      ),
    );
  }

  Future<void> _setColor(
      Color color, BuildContext context, WidgetRef ref) async {
    // 選択された色を設定する非同期関数です🔄
    ref.read(selectedColorProvider.notifier).state = color; // 選択された色を更新します🎨
    final SharedPreferences prefs = await SharedPreferences
        .getInstance(); // SharedPreferencesのインスタンスを取得します📦
    await prefs.setInt('selectedColor', color.value); // 選択された色をローカルに保存します💾
  }
}

class ColorItems {
  // ドロップダウンメニューの項目を生成するクラスです🏭
  List<DropdownMenuItem<Color>> getDropdownItems() {
    // ドロップダウンメニューの項目を取得する関数です📋
    final colorNames = {
      Colors.blue: "Blue", // 青色🔵
      Colors.red: "Red", // 赤色🔴
      Colors.black: "Black", // 黒色⚫
      Colors.white: "White", // 白色⚪
      Colors.yellow: "Yellow", // 黄色🟡
      Colors.green: "Green", // 緑色🟢
    };
    return colorNames.entries.map<DropdownMenuItem<Color>>((entry) {
      // 各色をドロップダウンメニューの項目に変換します🔄
      return DropdownMenuItem<Color>(
        value: entry.key, // 項目の値を設定します🎨
        child: Container(
          height: 50, // コンテナの高さを設定します📏
          child: Center(
            child: Text(
              entry.value, // 色の名前を表示します🏷 黄色 -> Yellow
              style: TextStyle(color: Colors.white), // テキストの色を設定します🖋
            ),
          ),
        ),
      );
    }).toList(); // リストに変換します📋
  }
}
