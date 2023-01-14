import Foundation
import SwiftUI

public struct AlertModel: Equatable {
    public static func == (lhs: AlertModel, rhs: AlertModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UUID = UUID()
    let type: AlertType = .modal
    let title: String
    let autoDismiss: Bool = true
    let countDownTimer: Int = 2
    let alertAnimationDuration: Double = 1.0
    var timer: Timer?
    var description: String?
    var alertAnimation: AlertAnimation = .fullpage(duration: 1)
    var alertTransition: AlertTransition = .modal
}

public extension AlertModel {
    enum AlertType {
        case modal
        case fullpage
        case toast
    }
    // Animation and Transition
    enum AlertTransition {
        case modal
        case fullpage
        case toast

        public var value: AnyTransition {
            switch self {
            case .modal:
                return AnyTransition.asymmetric(
                    insertion: .scale,
                    removal: .opacity
                ).combined(with: .opacity)
            case .fullpage:
                return AnyTransition.asymmetric(
                    insertion: .slide,
                    removal: .scale
                ).combined(with: .opacity)
            case .toast:
                return AnyTransition.asymmetric(
                    insertion: .opacity,
                    removal: .opacity
                ).combined(with: .opacity)
            }
        }
    }

    enum AlertAnimation {
        case modal(duration: Double)
        case fullpage(duration: Double)
        case toast(duration: Double)

        public var value: Animation {
            switch self {
            case .modal(let duration):
                return Animation.easeInOut(duration: duration)
            case .fullpage(let duration):
                return Animation.easeInOut(duration: duration)
            case .toast(let duration):
                return Animation.linear(duration: duration)
            }
        }
    }
}
