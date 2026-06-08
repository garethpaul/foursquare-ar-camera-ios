import Foundation

public class Reachability {
    
    class func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        
        guard let url = URL(string: "https://www.google.com/") else {
            return false
        }

        let request = NSMutableURLRequest(url: url)
        
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
}
