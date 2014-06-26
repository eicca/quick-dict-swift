import Foundation

class GlosbeClient {
    
    let translate_url = "http://glosbe.com/gapi/translate"
    
    let suggest_url = "http://glosbe.com/ajax/phrasesAutosuggest"
    
    let max_translations_count = 5
    
    // TODO global: make the work with json more nicer.
    
    func getAutocompleteSuggestions(searchTerm: String, handler: (Suggestion[]) -> Void) {
        let query = "\(suggest_url)?from=eng&dest=deu&phrase=\(searchTerm)"
            .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let request = NSURLRequest(URL: NSURL(string: query))
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            var error: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as String[]
            handler(json.map({ str in Suggestion(text: str) }))
        }
    }
    
    func getTranslationsForTerm(searchTerm: String, handler: (Translation[]) -> Void) {
        let query = "\(translate_url)?from=eng&dest=deu&format=json&phrase=\(searchTerm)"
            .stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let request = NSURLRequest(URL: NSURL(string: query))
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            var error: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as Dictionary<String, AnyObject!>
            let tuc = json["tuc"]
            let translations = (tuc as AnyObject[]).map({obj in Translation(params: obj as Dictionary<String, AnyObject>)})
            handler(self.limitTranslations(translations))
        }
    }
    
    func limitTranslations(translations: Translation[]) -> Translation[] {
        let max: Int = translations.count < max_translations_count ? translations.count : max_translations_count
        // TODO fix this workaround when range will be fixed.
        return translations.bridgeToObjectiveC().subarrayWithRange(NSMakeRange(0, max)) as Translation[]
    }
    
}