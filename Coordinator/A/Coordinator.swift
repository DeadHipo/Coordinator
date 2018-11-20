//
//  Coordinator.swift
//  Coordinator
//
//  Created by Александрк Бельковский on 20/11/2018.
//  Copyright © 2018 Александрк Бельковский. All rights reserved.
//

import Foundation
import UIKit



protocol Module {
    associatedtype ModuleEventsType
    
    typealias Handler = (ModuleEventsType) -> Void
    
    var handler: Handler? { get }
}

protocol Routable {

    var presenter: UIViewController { get }
    
    init(presenter: UIViewController)
    
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismissViewController(animated: Bool, completion: (() -> Void)?)
    
    func push(viewController: UIViewController, animated: Bool)
    @discardableResult func popViewController(animated: Bool) -> UIViewController?
    
    func set(viewControllers: [UIViewController], animated: Bool)
    
}

extension Routable {
    
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presenter.present(viewController, animated: animated, completion: completion)
    }
    
    func dismissViewController(animated: Bool, completion: (() -> Void)?) {
        presenter.dismiss(animated: animated, completion: completion)
    }
    
    func push(viewController: UIViewController, animated: Bool) {
        if let navigationController = presenter as? UINavigationController {
            navigationController.pushViewController(viewController, animated: animated)
        } else {
            presenter.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    func popViewController(animated: Bool) -> UIViewController? {
        if let navigationController = presenter as? UINavigationController {
            return navigationController.popViewController(animated: animated)
        } else {
            return presenter.navigationController?.popViewController(animated: animated)
        }
    }
    
    func set(viewControllers: [UIViewController], animated: Bool) {
        if let navigationController = presenter as? UINavigationController {
            navigationController.setViewControllers(viewControllers, animated: animated)
        } else {
            presenter.navigationController?.setViewControllers(viewControllers, animated: animated)
        }
    }
    
}

protocol Coordinator: class {
    
    var router: Routable { get }
    
    init(router: Routable)
    
    func start()

}

class BaseCoordinator: Coordinator {
    
    private var childs: [Coordinator] = []
    
    var router: Routable
    
    required init(router: Routable) {
        self.router = router
    }
    
    func start() {
        
    }
    
    func add(coordinator: Coordinator) {
        guard !childs.contains(where: { $0 === coordinator }) else {
            return
        }
        
        childs.append(coordinator)
    }
    
    func remove(coordinator: Coordinator) {
        guard let index = childs.index(where: { $0 === coordinator }) else {
            return
        }
        
        childs.remove(at: index)
    }
    
}

// MARK: - Main

class MainRouter: Routable {
    
    var presenter: UIViewController
    
    required init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
}

class MainCoordinator: BaseCoordinator {
    
    override func start() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc") as! ViewController
        
        viewController.handler = { [weak self] event in
            switch event {
            case .presentClicked:
                self?.presentSecondModule()
            }
        }
        
        router.set(viewControllers: [viewController], animated: false)
    }
    
    private func presentSecondModule() {
        let navigationController = UINavigationController()
        
        let secondRouter = SecondRouter(presenter: navigationController)
        let secondCoordinator = SecondCoordinator(router: secondRouter)
        
        add(coordinator: secondCoordinator)
        
        secondCoordinator.start()
        
        router.present(viewController: navigationController, animated: true, completion: nil)
    }
    
}

// MARK: - Second

class SecondRouter: Routable {
    
    var presenter: UIViewController
    
    required init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
}

class SecondCoordinator: BaseCoordinator {
    
    override func start() {
        let viewController1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc1") as! ViewController1
        
        viewController1.handler = { [weak self] event in
            switch event {
            case .nextClicked:
                self?.pushNext()
            }
        }
        
        router.set(viewControllers: [viewController1], animated: false)
    }
    
    private func pushNext() {
        let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc1") as! ViewController1
        
        nextViewController.handler = { [weak self] event in
            switch event {
            case .nextClicked:
                self?.pushNext()
            }
        }
        
        router.push(viewController: nextViewController, animated: true)
    }
    
}
