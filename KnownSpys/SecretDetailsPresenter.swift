import Foundation

protocol SecretDetailsPresenter {
    var password: String { get }
}

class SecretDetailsPresenterImpl: SecretDetailsPresenter {
    var spy: SpyDTO
    var password: String { return spy.password }
    
    init(with spy: SpyDTO) {
        self.spy = spy
    }
}
