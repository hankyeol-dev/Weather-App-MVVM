//
//  BaseViewController.swift
//  Weather+MVVM
//
//  Created by 강한결 on 7/10/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureAction()
    }

    func configureAction() {}
}

extension BaseViewController {
    func configureNav(title: String, leftBarItem: UIBarButtonItem?, rightBarItem: UIBarButtonItem?) {
        self.title = title
        
        if let left = leftBarItem {
            navigationItem.leftBarButtonItem = left
        }
        
        if let right = rightBarItem {
            navigationItem.rightBarButtonItem = right
        }
    }
   
    func genLeftWithGoBack(_ c: UIColor?) -> UIBarButtonItem {
        let left = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
        
        if let color = c {
            left.tintColor = color
        } else {
            left.tintColor = .systemGray
        }
        
        return left
    }
    

    func goSomeVC<T: UIViewController>(vc: T, vcHandler: @escaping (T) -> ()) {
        vcHandler(vc)
        navigationController?.pushViewController(vc, animated: true)
    }

    func presentSomeVC<T: UIViewController>(vc: T, vcHandler: @escaping (T) -> ()) {
        vcHandler(vc)
        present(vc, animated: true)
    }
}

extension BaseViewController {
    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
