import Foundation

class Translation: NSObject {
    
    var text: String
    var meanings: String[]
    
    init(text: String, meanings: String[]) {
        self.text = text
        self.meanings = meanings
    }
    
    init(params: Dictionary<String, AnyObject>) {
        self.text = ""
        if let phrase: AnyObject?  = params["phrase"] {
            if let text = (phrase as Dictionary<String, String>)["text"] as String? {
                self.text = text
            }
        }
        self.meanings = []
    }
    
}
