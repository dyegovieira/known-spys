import Foundation
import CoreData

protocol TranslationLayer {
    func createSpyDTOsFromJsonData(_ data: Data) -> [SpyDTO]
    func toUnsavedCoreData(from dtos: [SpyDTO], with context: NSManagedObjectContext) -> [Spy]
    func toSpyDTOs(from spies:[Spy]) -> [SpyDTO]
}

class TranslationLayerImpl: TranslationLayer {
    
    fileprivate var spyTranslator: SpyTranslator
    
    init(spyTranslator: SpyTranslator) {
        self.spyTranslator = spyTranslator
    }
    
    func createSpyDTOsFromJsonData(_ data: Data) -> [SpyDTO] {
        print("converting json to DTOs")
        
        let spyList = try? JSONDecoder().decode(SpyListDTO.self, from: data)

        return spyList?.spies ?? []
    }
    
    func toUnsavedCoreData(from dtos: [SpyDTO], with context: NSManagedObjectContext) -> [Spy] {
        print("convering DTOs to Core Data Objects")
        let spies = dtos.compactMap{ dto in spyTranslator.translate(from: dto, with: context) } // keeping it simple by keeping things single threaded
        
        return spies
    }
    
    func toSpyDTOs(from spies:[Spy]) -> [SpyDTO] {
        let dtos = spies.compactMap { spyTranslator.translate(from: $0) }
        
        return dtos
    }
}
