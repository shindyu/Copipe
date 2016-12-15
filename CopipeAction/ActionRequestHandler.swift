import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    
    var extensionContext: NSExtensionContext?
    
    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        print("11111")
        // Do not call super in an Action extension with no user interface
        self.extensionContext = context
        
        // Find the item containing the results from the JavaScript preprocessing.
        for item: AnyObject in context.inputItems {
            let extItem = item as! NSExtensionItem
            
            // early returns
            guard let attachments = extItem.attachments else {
                continue
            }
            
            // for-in & where
            for itemProvider: AnyObject in attachments where itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList)) {
                
                itemProvider.loadItemForTypeIdentifier(
                    String(kUTTypePropertyList),
                    options: nil,
                    completionHandler: { [unowned self] (result: NSSecureCoding?, error: NSError!) -> Void in
                        let dictionary = result as! [String: AnyObject]
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            if let dist = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? [NSObject: AnyObject] {
                                self.itemLoadCompletedWithPreprocessingResults(dist)
                            }
                        }
                    })
            }
        }
    }
    
    func itemLoadCompletedWithPreprocessingResults(var javaScriptPreprocessingResults: [NSObject: AnyObject]) {
        print("2222222")
        // titleを加工する
        if let title = javaScriptPreprocessingResults["title"] as? String {
            javaScriptPreprocessingResults["title"] = "タイトル: 「\(title)」"
        }
        
        // jsに渡す -> newBackgroundColor : red
        javaScriptPreprocessingResults["newBackgroundColor"] = "red"
        
        self.doneWithResults(javaScriptPreprocessingResults)
    }
    
    func doneWithResults(resultsForJavaScriptFinalizeArg: [NSObject: AnyObject]?) {
        print("333333")
        if let resultsForJavaScriptFinalize = resultsForJavaScriptFinalizeArg {
            let resultsItem = NSExtensionItem()
            
            let resultsProvider = NSItemProvider(
                item: [NSExtensionJavaScriptFinalizeArgumentKey: resultsForJavaScriptFinalize],
                typeIdentifier: String(kUTTypePropertyList)
            )
            resultsItem.attachments = [resultsProvider]
            
            self.extensionContext!.completeRequestReturningItems([resultsItem], completionHandler: nil)
        } else {
            self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        }
        
        // Don't hold on to this after we finished with it.
        self.extensionContext = nil
    }
    
}
