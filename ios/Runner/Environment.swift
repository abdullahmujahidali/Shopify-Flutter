import Foundation

public enum Environment {
    enum Keys {
        enum Plist {
            static let googleApiKeyIos = "GOOGLE_API_KEY"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static let googleApiKeyIos: String = {
        guard let apiKey = Environment.infoDictionary[Keys.Plist.googleApiKeyIos] as? String else {
            return "AIzaSyDnBpxFOfeG6P06nK97hMg01kEgX48JhLE"
        }
        return apiKey
    }()
}
