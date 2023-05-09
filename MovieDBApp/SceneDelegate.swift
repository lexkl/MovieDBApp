//
//  SceneDelegate.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 06.05.2023.
//

import UIKit
import Combine
import Swinject
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?
    private var cancellables = Set<AnyCancellable>()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let coordinator = AppCoordinator(window: window, onFinish: {})
        
        guard let genresService = Container.shared.resolve(GenresService.self) else { return }
        
        DispatchQueue.main.async {
            self.loadGenres(service: genresService)
        }
        
        coordinator.start()
        
        self.window = window
        self.coordinator = coordinator
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded
        // (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

private extension SceneDelegate {
    func loadGenres(service: GenresService) {
        service.load()
            .sink { error in
                print(error)
            } receiveValue: { response in
                guard let genres = response.genres else { return }
                
                do {
                    try Realm.tryWrite { realm in
                        for genreAPI in genres {
                            guard let id = genreAPI.id, let name = genreAPI.name else { return }
                            
                            let genre = Genre(id: id, name: name)
                            realm.add(genre, update: .all)
                        }
                    }
                } catch {
                    print(error)
                }
                
            }
            .store(in: &cancellables)
    }
}
