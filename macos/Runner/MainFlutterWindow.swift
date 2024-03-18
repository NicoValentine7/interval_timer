import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()

    // タイトルバーを透明にする
    self.titlebarAppearsTransparent = true
    // タイトルを非表示にする
    self.titleVisibility = .hidden
    // ウィンドウのスタイルを設定
    self.styleMask.insert(.fullSizeContentView)
    // ウィンドウを常に手前に表示
    self.level = .floating
  }
}
