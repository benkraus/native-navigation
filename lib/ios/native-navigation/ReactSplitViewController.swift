import Foundation
import UIKit
import React

open class ReactSplitViewController: UISplitViewController {

  let nativeNavigationInstanceId: String
  var sharedElementsById: [String: WeakViewHolder] = [:]
  var sharedElementGroupsById: [String: WeakViewHolder] = [:]
  var isPendingNavigationTransition: Bool = false
  var isCurrentlyTransitioning: Bool = false
  var onTransitionCompleted: (() -> Void)?
  var onNavigationBarTypeUpdated: (() -> Void)?
  var reactViewHasBeenRendered: Bool = false
  var transition: ReactSharedElementTransition?
  var eagerNavigationController: UINavigationController?
  var dismissResultCode: ReactFlowResultCode?
  var dismissPayload: [String: AnyObject]?
  open weak var reactViewControllerDelegate: ReactViewControllerDelegate?
  fileprivate let moduleName: String
  fileprivate var props: [String: AnyObject]
  fileprivate var initialConfig: [String: AnyObject]
  fileprivate var prevConfig: [String: AnyObject]
  fileprivate var renderedConfig: [String: AnyObject]
  fileprivate var reactView: UIView!
  fileprivate var statusBarAnimation: UIStatusBarAnimation = .fade
  fileprivate var statusBarHidden: Bool = false
  fileprivate var statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.default
  fileprivate var statusBarIsDirty: Bool = false
  fileprivate var leadingButtonVisible: Bool = true
  private var barHeight: CGFloat

  public init(moduleName: String, props: [String: AnyObject] = [:]) {
    self.nativeNavigationInstanceId = generateId(moduleName)
    self.moduleName = moduleName

    self.barHeight = -1;
    self.props = EMPTY_MAP

    self.initialConfig = EMPTY_MAP
    self.prevConfig = EMPTY_MAP
    self.renderedConfig = EMPTY_MAP

    super.init(nibName: nil, bundle: nil)

    if let initialConfig = coordinator.getScreenProperties(moduleName) {
      self.initialConfig = initialConfig
      self.renderedConfig = initialConfig
    }

    self.props = propsWithMetadata(props, nativeNavigationInstanceId, barHeight)

    // split view controller delegate
    delegate = self
  }

  deinit {
    coordinator.unregisterViewController(nativeNavigationInstanceId)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override open func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    coordinator.registerViewController(self)
    if let reactView = RCTRootView(
      bridge: coordinator.bridge,
      moduleName: moduleName,
      initialProperties: propsWithMetadata(props, nativeNavigationInstanceId, barHeight)
    ) {

      // If we do end up attaching the view, we might want to use this to prevent it from
      // being visible to the user
      // reactView.isHidden = true

      // It seems like tabs only work some of the time when we don't actually attach it to a view hierarchy.
      // for this reason, we are going to add the rootview as frame-less subview.
      // reactView.isHidden = true
      // self.view.addSubview(reactView)
      self.reactView = reactView
    }
  }

  func prepareViewControllerForPresenting() -> UIViewController {
      return self
  }
  
  func signalFirstRenderComplete() {
    reactViewHasBeenRendered = true
    refreshViews()
    if (isPendingNavigationTransition) {
      onNavigationBarTypeUpdated?()
    }
  }
  
  func setNavigationBarProperties(props: [String : AnyObject]) { }
  
  func refreshViews() {
    var stack: [UIView] = [reactView!]
    
    while (!stack.isEmpty) {
      if let node = stack.popLast() {
        for child in node.subviews {
          if let child = child as? SplitView {
            stack.append(child)
            
            self.viewControllers = [child.getMasterController(), child.getDetailController()].flatMap { $0 }
          } else {
            stack.append(child)
          }
        }
      }
    }
  }
}

extension ReactSplitViewController: UISplitViewControllerDelegate {

}
