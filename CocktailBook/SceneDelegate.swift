import UIKit
import SwiftUI
import CocktailsAPI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
        let window = UIWindow(windowScene: windowScene)
        
//        window.rootViewController = MainScreenViewController()
//        self.window = window
//        window.makeKeyAndVisible()

        let api = FakeCocktailsAPI(withFailure: .never)
        let viewModel = CocktailsViewModel(api: api)
        window.rootViewController = UIHostingController(rootView: CocktailsView(viewModel: viewModel))
        self.window = window
        window.makeKeyAndVisible()
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {}
  func sceneDidBecomeActive(_ scene: UIScene) {}
  func sceneWillResignActive(_ scene: UIScene) {}
  func sceneWillEnterForeground(_ scene: UIScene) {}
  func sceneDidEnterBackground(_ scene: UIScene) {}
}

