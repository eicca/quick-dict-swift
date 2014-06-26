import Cocoa

class ResultsViewController: NSViewController {
    
    @IBOutlet var searchTermLabel: NSTextField
    
    var translations: NSArray = []
    var glosbeClient = GlosbeClient()
    
    func showTranslationsFor(searchTerm: String) {
        searchTermLabel.stringValue = searchTerm
        glosbeClient.getTranslationsForTerm(searchTerm, handler: renderTranslations)
    }
    
    func renderTranslations(loadedTranslations: Translation[]) {
        translations = loadedTranslations
    }
    
}
