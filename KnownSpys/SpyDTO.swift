import Foundation
//import Outlaw

private var numImagesPerGender = 6

struct SpyDTO {
    var age: Int
    var name: String
    var gender: Gender
    var password: String
    var isIncognito: Bool
    var imageName: String = ""
}


// MARK: - Decodable

extension SpyDTO: Decodable {
    enum CodingKeys: CodingKey {
        case age, name, gender, password, isIncognito, imageName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        age = try container.decode(Int.self, forKey: .age)
        name = try container.decode(String.self, forKey: .name)
        gender = try container.decode(Gender.self, forKey: .gender)
        password = try container.decode(String.self, forKey: .password)
        isIncognito = try container.decode(Bool.self, forKey: .isIncognito)

        imageName = randomImageName
    }
    
    private var randomImageName: String {
        let imageIndex = Int(arc4random_uniform(UInt32(numImagesPerGender))) + 1
        let imageGender = gender == .female ? "F"
            : "M"
        
        return String(format: "Spy%@%02d", imageGender, imageIndex)
    }
}
