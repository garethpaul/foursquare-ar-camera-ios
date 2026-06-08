import Foundation

public class Reachability {
    
    class func isConnectedToNetwork()->Bool{

        guard let url = URL(string: "https://www.google.com/generate_204") else {
            return false
        }

        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0

        let semaphore = DispatchSemaphore(value: 0)
        var isConnected = false

        let task = URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse {
                isConnected = (200..<400).contains(httpResponse.statusCode)
            }

            semaphore.signal()
        }

        task.resume()
        _ = semaphore.wait(timeout: .now() + 10)

        return isConnected
    }
}
