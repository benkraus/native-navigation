import React

final class SplitView: RCTView {

  // MARK: Internal

  func setMaster(_ master: String!) {
    self.master = master
  }

  func setDetail(_ detail: String!) {
    self.detail = detail
  }
  
  func getMasterController() -> UIViewController? {
    if let masterVC = masterViewController {
      return masterVC
    }
    
    if let route = master {
      let vc = ReactViewController(moduleName: route, props: [:]).prepareViewControllerForPresenting()
      masterViewController = vc
    }
    
    return masterViewController
  }

  func getDetailController() -> UIViewController? {
    if let detailVC = detailViewController {
      return detailVC
    }
    
    if let route = detail {
      let vc = ReactViewController(moduleName: route, props: [:]).prepareViewControllerForPresenting()
      detailViewController = vc
    }
    
    return detailViewController
  }
  
  private var master: String?
  private var detail: String?
  private var masterViewController: UIViewController?
  private var detailViewController: UIViewController?
}

private let VERSION: Int = 1

@objc(SplitViewManager)
final class SplitViewManager: RCTViewManager {
  override func view() -> UIView! {
    return SplitView()
  }

  override func constantsToExport() -> [String: Any] {
    return [
      "VERSION": VERSION
    ]
  }
}
