import Cocoa
import AppKit
import FlutterMacOS

class MainFlutterWindow: NSWindow, NSWindowDelegate{
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // Customize Title
    self.titlebarAppearsTransparent = true
    self.styleMask.insert(.fullSizeContentView)
    self.titleVisibility = .hidden;
    self.titlebarAppearsTransparent = true

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
  
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        return dialogOKCancel(question: "Exit?", text: "Are you sure you want to exit?")
    }

    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        
        return alert.runModal() == .alertFirstButtonReturn
    }
}
