import Foundation

public struct Media {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String

    public init(key: String, fileName: String, data: Data, mimeType: String) {
        self.key = key
        self.fileName = fileName
        self.data = data
        self.mimeType = mimeType
    }
    
    public init(withImage image: Data, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpg"
        self.fileName = "\(arc4random()).jpeg"
        self.data = image
    }
}
