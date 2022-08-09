//
//  MyMapTemplate.swift
//  MyCarPlayLib
//
//  Created by safetrust on 8/9/22.
//

import UIKit
import CarPlay

open class MyMapTemplate: NSObject, CPApplicationDelegate, CPMapTemplateDelegate {
    
    // MARK: - CarPlay Reference variables
    var carWindow: CPWindow?
    var interfaceController: CPInterfaceController?
    var mapTemplate: CPMapTemplate?
    
    // MARK: - Needed to show initial storyboard
    public var window: UIWindow?
    
    // MARK: - CPApplicationDelegate methods
    public func application(_ application: UIApplication, didConnectCarInterfaceController interfaceController: CPInterfaceController, to window: CPWindow) {
        print("[CARPLAY] CONNECTED TO CARPLAY!")
        
        // Keep references to the CPInterfaceController (handles your templates) and the CPMapContentWindow (to draw/load your own ViewController's with a navigation map onto)
        self.interfaceController = interfaceController
        self.carWindow = window
        
        print("[CARPLAY] CREATING CPMapTemplate...")
        
        // Create a map template and set it as the root on the interfacecontroller (you may push/pop templates like a UINavigationController) Also assign delegate for the callbacks
        let mapTemplate = createTemplate()
        mapTemplate.mapDelegate = self
        
        self.mapTemplate = mapTemplate
        
        print("[CARPLAY] SETTING ROOT OBJECT OF INTERFACECONTROLLER TO MAP TEMPLATE...")
        interfaceController.setRootTemplate(mapTemplate, animated: true)
        
        print("[CARPLAY] SETTING CustomNavigationViewController as root VC...")
        window.rootViewController = CustomNavigationViewController()
        
        // Note: Obviously the AppDelegate is a bad place to handle everything and save all your references. This is done for example, don't put everything in the same class 🙃
    }
    
    public func application(_ application: UIApplication, didDisconnectCarInterfaceController interfaceController: CPInterfaceController, from window: CPWindow) {
        print("[CARPLAY] DISCONNECTED FROM CARPLAY!")
    }
    
    public func application(_ application: UIApplication, didSelect navigationAlert: CPNavigationAlert) {
        // TODO: Implementation
    }
    
    public func application(_ application: UIApplication, didSelect maneuver: CPManeuver) {
        // TODO: Implementation
    }
    
    // MARK: - CPMapTemplate creation
    
    func createTemplate() -> CPMapTemplate {
        // Create the default CPMapTemplate objcet (you may subclass this at your leasure)
        let mapTemplate = CPMapTemplate()
        
        // Create the different CPBarButtons
        let searchBarButton = createBarButton(.search)
        mapTemplate.leadingNavigationBarButtons = [searchBarButton]
        
        let panningBarButton = createBarButton(.panning)
        mapTemplate.trailingNavigationBarButtons = [panningBarButton]
        
        // Always show the NavigationBar
        mapTemplate.automaticallyHidesNavigationBar = false
        
        return mapTemplate
    }
    
    // MARK: - CPBarButton creation
    
    enum BarButtonType: String {
        case search = "Search"
        case panning = "Pan map"
        case dismiss = "Dismiss"
    }
    
    private func createBarButton(_ type: BarButtonType) -> CPBarButton {
        let barButton = CPBarButton(type: .text) { (button) in
            print("[CARPLAY] SEARCH MAP TEMPLATE \(button.title ?? "-") TAPPED")
            
            switch(type) {
            case .dismiss:
                // Dismiss the map panning interface
                self.mapTemplate?.dismissPanningInterface(animated: true)
            case .panning:
                // Enable the map panning interface and set the dismiss button
                self.mapTemplate?.showPanningInterface(animated: true)
                self.mapTemplate?.trailingNavigationBarButtons = [self.createBarButton(.dismiss)]
            default:
                break
            }
        }
        
        // Set title based on type
        barButton.title = type.rawValue
        
        return barButton
    }
}
