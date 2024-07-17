//
//  BaseViewControllerWithType.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/17/24.
//

import UIKit

protocol ViewModelProtocol: AnyObject {  }
protocol MainViewProtocol: AnyObject where Self:BaseView { }

class BaseViewControllerWithType<VM: ViewModelProtocol, MV: MainViewProtocol>: UIViewController {
    weak var vm: VM?
    weak var mv: MV?
    
    init(vm: VM, mv: MV) {
        self.vm = vm
        self.mv = mv
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mv
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
