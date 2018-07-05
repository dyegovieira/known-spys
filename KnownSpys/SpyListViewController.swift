import UIKit
import Toaster
import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class SpyListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    weak var navigationCoordinator: NavigationCoordinator?
    
    fileprivate var presenter: SpyListPresenter!
    fileprivate var bag = DisposeBag()
    
    fileprivate var dataSource = RxTableViewSectionedReloadDataSource<SpySection>(configureCell: {
        _, _, _, _ in return UITableViewCell()
    })

    init(with presenter: SpyListPresenter, navigationCoordinator: NavigationCoordinator) {
        self.presenter = presenter
        self.navigationCoordinator = navigationCoordinator
        
        super.init(nibName: "SpyListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setRightBarButton(
            UIBarButtonItem(barButtonSystemItem: .refresh,
                            target: self,
                            action: #selector(SpyListViewController.updateData(_:))),
            animated: true)
        
        SpyCell.register(with: tableView)
        
        presenter.loadData { [weak self] source in
            self?.newDataReceived(from: source)
        }
        
        initDataSource()
        initTableView()
    }
    
    func newDataReceived(from source: Source) {
        Toast(text: "New Data from \(source)").show()
        tableView.reloadData()
    }
    
    @IBAction func updateData(_ sender: Any) {
        presenter.makeSomeDataChange()
    }
}

//MARK: Reaction Process
extension SpyListViewController {
    func initDataSource() {
        dataSource.configureCell = { _, tableView, indexPath, spy in
            let cellPresenter = SpyCellPresenterImpl(with: spy)
            let cell = SpyCell.dequeue(from: tableView, for: indexPath, with: cellPresenter)
            
            return cell
        }
        
        dataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].header
        }
    }
    
    func initTableView() {
        presenter.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        tableView.rx.itemSelected.map { indexPath in
            return (indexPath, self.dataSource[indexPath])
        }.subscribe(onNext: { indexPath, spy in
            self.next(with: spy)
        }).disposed(by: bag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: bag)
    }

}

//MARK: - UITableViewDelegate
extension SpyListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    func next(with spy: SpyDTO) {
        let args = ["spy": spy]
        navigationCoordinator!.next(arguments: args)
    }
}




