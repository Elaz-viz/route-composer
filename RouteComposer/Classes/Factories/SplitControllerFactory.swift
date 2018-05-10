//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// `Container` `Factory` that creates `UISplitViewController`
public class SplitControllerFactory: Factory, Container {

    public typealias ViewController = UISplitViewController

    public typealias Context = Any?

    public let action: Action

    var masterFactories: [ChildFactory<Context>] = []

    var detailFactories: [ChildFactory<Context>] = []

    /// Constructor
    ///
    /// - Parameter action: `Action` instance.
    public init(action: Action) {
        self.action = action
    }

    public func merge<C>(_ factories: [ChildFactory<C>]) -> [ChildFactory<C>] {
        var rest: [ChildFactory<C>] = []
        factories.forEach { factory in
            if let _ = factory.action as? SplitControllerMasterAction, let factory = factory as? ChildFactory<Context> {
                masterFactories.append(factory)
            } else if let _ = factory.action as? SplitControllerDetailAction, let factory = factory as? ChildFactory<Context> {
                detailFactories.append(factory)
            } else {
                rest.append(factory)
            }
        }

        return rest
    }

    public func build(with context: Context) throws -> ViewController {
        guard masterFactories.count > 0, detailFactories.count > 0 else {
            throw RoutingError.message("No master or derails view controllers provided")
        }

        let masterViewControllers = try buildChildrenViewControllers(from: masterFactories, with: context)
        let detailsViewControllers = try buildChildrenViewControllers(from: detailFactories, with: context)
        guard masterViewControllers.count > 0 else {
            throw RoutingError.message("No master or derails view controllers provided")
        }
        guard detailsViewControllers.count > 0 else {
            throw RoutingError.message("At least 1 Details View Controller is mandatory to build UISplitViewController")
        }

        let splitController = UISplitViewController(nibName: nil, bundle: nil)
        var childrenViewControllers = masterViewControllers
        childrenViewControllers.append(contentsOf: detailsViewControllers)
        splitController.viewControllers = childrenViewControllers
        return splitController
    }

}
