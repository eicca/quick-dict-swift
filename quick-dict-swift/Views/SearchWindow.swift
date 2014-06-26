import Cocoa

class SearchWindow: NSWindow {
    
    // Need to set explicity because window don't have
    // a title bar.
    func canBecomeKeyWindow() -> Bool {
        return true
    }
    
    // Hide window by `Esc`.
    override func cancelOperation(sender: AnyObject!) {
//        close()
    }
    
    func changeHeight(newHeight: CGFloat) {
        var oldFrame = frame
        oldFrame.origin.y += frame.size.height
        oldFrame.origin.y -= newHeight
        oldFrame.size.height = newHeight
        setFrame(oldFrame, display: true)
    }
    
}