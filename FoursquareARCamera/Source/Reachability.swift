import Foundation

public class Reachability {

    private final class RedirectRefusingDelegate: NSObject, URLSessionTaskDelegate {
        func urlSession(_ session: URLSession,
                        task: URLSessionTask,
                        willPerformHTTPRedirection response: HTTPURLResponse,
                        newRequest request: URLRequest,
                        completionHandler: @escaping (URLRequest?) -> Void) {
            completionHandler(nil)
        }
    }

    private class func isSuccessfulProbeStatus(_ statusCode: Int) -> Bool {
        return statusCode == 204
    }
    
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
        let configuration = URLSessionConfiguration.ephemeral
        let redirectRefusingDelegate = RedirectRefusingDelegate()
        let session = URLSession(
            configuration: configuration,
            delegate: redirectRefusingDelegate,
            delegateQueue: nil
        )

        let task = session.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse {
                isConnected = isSuccessfulProbeStatus(httpResponse.statusCode)
            }

            semaphore.signal()
        }

        task.resume()
        if semaphore.wait(timeout: .now() + 10) == .timedOut {
            task.cancel()
            session.invalidateAndCancel()
            return false
        }

        session.finishTasksAndInvalidate()
        return isConnected
    }
}
