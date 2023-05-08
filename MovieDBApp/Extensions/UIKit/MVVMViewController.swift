//
//  MVVMViewController.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 07.05.2023.
//

import Foundation
import UIKit

protocol MVVMViewControllerProtocol: AnyObject {
    associatedtype ViewModelType
    init(viewModel: ViewModelType)
}

class MVVMViewController<U>: UIViewController, MVVMViewControllerProtocol {
    typealias ViewModelType = U
    let viewModel: ViewModelType
    
    convenience init() {
        fatalError()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    required init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    func bindUI() {
        fatalError("override this function in subclasses")
    }
    
    func add(childController: UIViewController, on container: UIView) {
        addChild(childController)
        childController.view.frame = container.bounds
        container.addSubview(childController.view)
        childController.didMove(toParent: self)
    }
    
    func removeChildren() {
        children.forEach({ $0.removeFromParent() })
    }
}
