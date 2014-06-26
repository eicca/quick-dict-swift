import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet var window: SearchWindow
    @IBOutlet var statusMenu: NSMenu
    @IBOutlet var searchTermTextField : NSTextField
    
    @IBOutlet var suggestionsCtrl : NSArrayController
    @IBOutlet var suggestionsView : NSScrollView
    
    var resultsViewCtrl = ResultsViewController()
    
    var glosbeClient = GlosbeClient()
    var statusItem: NSStatusItem?
    var suggestions: NSArray = []
    
    // Init functions.
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        window.changeHeight(75)
//        resultsViewCtrl = ResultsViewController()
        initStatusItem()
        initShortcuts()
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    func initStatusItem() {
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(CGFloat(NSSquareStatusItemLength))
        
        statusItem!.menu = statusMenu
        statusItem!.title = "S"
        statusItem!.highlightMode = true
    }
    
    func initShortcuts() {
        let keyMask = NSEventModifierFlags.CommandKeyMask | NSEventModifierFlags.AlternateKeyMask
        let shortcut = MASShortcut.shortcutWithKeyCode(kVK_Space, modifierFlags: Int(keyMask.value))
        MASShortcut.addGlobalHotkeyMonitorWithShortcut(shortcut, handler: showApp)
    }

    
    // UI actions.
    
    @IBAction func showAppClicked(sender: NSMenuItem) {
        showApp()
    }
    
    @IBAction func searchTermSend(sender : AnyObject) {
        let searchTerm = searchTermTextField.stringValue
        window.contentView = resultsViewCtrl.view
        resultsViewCtrl.showTranslationsFor(searchTerm)
    }
    
    // UI events.
    
    override func controlTextDidChange(obj: NSNotification!) {
        if obj.object as? NSObject != searchTermTextField {
            return
        }
        
        let searchTerm = searchTermTextField.stringValue!
        if countElements(searchTerm) >= 2 {
            glosbeClient.getAutocompleteSuggestions(searchTerm, renderSuggestions)
        }
    }
    
    // Private functions.
    
    func showApp() {
        NSApp.unhide()
        window.makeKeyAndOrderFront(nil)
    }
    
    func renderSuggestions(newSuggestions: Suggestion[]) {
        self.suggestions = newSuggestions
        if suggestions.count > 5 {
            window.changeHeight(400)
        } else {
            window.changeHeight(75)
        }
    }

}

