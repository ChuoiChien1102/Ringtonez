// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let categoriesViewController = SceneType<CategoriesViewController>(storyboard: Main.self, identifier: "CategoriesViewController")

    internal static let detailCategoryViewController = SceneType<DetailCategoryViewController>(storyboard: Main.self, identifier: "DetailCategoryViewController")

    internal static let homeViewController = SceneType<HomeViewController>(storyboard: Main.self, identifier: "HomeViewController")

    internal static let iapViewController = SceneType<IAPViewController>(storyboard: Main.self, identifier: "IAPViewController")

    internal static let intro1ViewController = SceneType<Intro1ViewController>(storyboard: Main.self, identifier: "Intro1ViewController")

    internal static let intro2ViewController = SceneType<Intro2ViewController>(storyboard: Main.self, identifier: "Intro2ViewController")

    internal static let makerViewController = SceneType<MakerViewController>(storyboard: Main.self, identifier: "MakerViewController")

    internal static let myToneViewController = SceneType<MyToneViewController>(storyboard: Main.self, identifier: "MyToneViewController")

    internal static let pageContentViewController = SceneType<PageContentViewController>(storyboard: Main.self, identifier: "PageContentViewController")

    internal static let recordViewController = SceneType<RecordViewController>(storyboard: Main.self, identifier: "RecordViewController")

    internal static let settingViewController = SceneType<SettingViewController>(storyboard: Main.self, identifier: "SettingViewController")

    internal static let splashViewController = SceneType<SplashViewController>(storyboard: Main.self, identifier: "SplashViewController")

    internal static let tutorialViewController = SceneType<TutorialViewController>(storyboard: Main.self, identifier: "TutorialViewController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}
