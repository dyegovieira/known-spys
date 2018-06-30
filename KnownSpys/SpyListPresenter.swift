import Foundation
import RxSwift
import RxDataSources

typealias BlockWithSource = (Source)->Void

struct SpySection {
    var header: String
    var items: [Item]
}
extension SpySection: SectionModelType {
    typealias Item = SpyDTO
    
    init(original: SpySection, items: [Item]) {
        self = original
        self.items = items
    }
}

protocol SpyListPresenter {
    var sections: Variable<[SpySection]> { get }
    func loadData(finished: @escaping BlockWithSource)
    func makeSomeDataChange()
}

class SpyListPresenterImpl: SpyListPresenter {
    var sections = Variable<[SpySection]>([])
    
    fileprivate var modelLayer: ModelLayer
    fileprivate var bag = DisposeBag()
    fileprivate var spies = Variable<[SpyDTO]>([])
    
    init(modelLayer: ModelLayer) {
        self.modelLayer = modelLayer
        setupObservers()
    }
}

//MARK: - Reactive Process
extension SpyListPresenterImpl {
    func setupObservers() {
        spies.asObservable().subscribe(onNext: { [weak self] newSpies in
            self?.updateNewSections(with: newSpies)
        }).disposed(by: bag)
    }
    
    func updateNewSections(with newSpies: [SpyDTO]) {
        func mainWork() {
            sections.value = filter(spies: newSpies)
        }
        
        func filter(spies: [SpyDTO]) -> [SpySection] {
            let incognitoSpies = spies.filter {  $0.isIncognito }
            let everdaySpies   = spies.filter { !$0.isIncognito }
            
            
            return [SpySection(header: "Sneaky Spies", items: incognitoSpies),
                    SpySection(header: "Regular Spies", items: everdaySpies)]
        }
        
        mainWork()
    }
}

//MARK: - Data Methods
extension SpyListPresenterImpl {
    func makeSomeDataChange() {
        let newSpy = SpyDTO(age: 23, name: "Adam Smith", gender: .male, password: "wealth", imageName: "AdamSmith", isIncognito: true)
        spies.value.insert(newSpy, at: 0)
    }
    
    func loadData(finished: @escaping BlockWithSource) {
        modelLayer.loadData { [weak self] source, spies in
            self?.spies.value = spies
            finished(source)
        }
    }
}

