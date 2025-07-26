//
//  FilterCoordinator.swift
//  MangaApp
//
//  Created by Никита Новицкий on 12.08.2025.
//

import UIKit

class FilterCoordinator: BaseCoordinator {
    var onApply: (() -> Void)?
    
    override func start() {
        let vc = resolver.resolve(FilterViewController.self)!
        vc.onFinish = onApply
        let nc = UINavigationController()
        nc.viewControllers = [vc]
        vc.presenter.delegate = self
        navigationController.present(nc, animated: true)
    }
}

extension FilterCoordinator: FilterPresenterOutput {
    func closeFilter() {
        navigationController.dismiss(animated: true)
    }
}
