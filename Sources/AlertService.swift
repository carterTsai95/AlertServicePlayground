import Foundation
import SwiftUI
import Combine

public protocol AlertsService {
    var alertsQueueSignal: PassthroughSubject<AlertModel, Never> { get }
    func presentAlert(
        title: String
    )
}

public struct AlertModel: Equatable {
    let id: UUID = UUID()
    let title: String
    let autoDismiss: Bool = true
    let countDownTimer: Int = 2
    var timer: Timer?
}

public class AlertsServiceBackend: AlertsService, ObservableObject {
    public var alertsQueueSignal: PassthroughSubject<AlertModel, Never> = .init()
    @Published public var currentAlerts: [AlertModel] = []
    private var alertTimer: Timer?
    private var cancellables: Set<AnyCancellable> = []
    let animation = Animation.easeInOut(duration: 0.1)
    let transition = AnyTransition.asymmetric(insertion: .scale, removal: .opacity).combined(with: .opacity)
    
    public init() {
        alertsQueueSignal
            .receive(on: RunLoop.main)
            .sink { alertResult in
                self.registeredAlert(alertResult)
            }
            .store(in: &cancellables)
    }
    
    public func presentAlert(title: String) {
        DispatchQueue.global(qos: .utility).async {
            self.alertsQueueSignal.send(
                AlertModel(title: title)
            )
        }
    }
    
    private func registeredAlert(_ alert: AlertModel) {
        self.currentAlerts.append(alert)
        if alert.autoDismiss {
            alertCountdown(alert)
        }
    }
    
    func alertCountdown(_ alert: AlertModel) {
        guard let index = currentAlerts.firstIndex(of: alert) else {
            return
        }
        
        currentAlerts[index].timer = Timer()
        currentAlerts[index].timer?.invalidate()
        currentAlerts[index].timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.removeAlert(alert)
        }
    }

    public func removeAlert(_ alert: AlertModel) {
        guard let index = currentAlerts.firstIndex(where: { $0.id == alert.id }) else {
            return
        }

        currentAlerts[index].timer?.invalidate()
        currentAlerts[index].timer = nil
        print("Remove Alert: \(currentAlerts[index].title)")
        currentAlerts.remove(at: index)
    }
}
