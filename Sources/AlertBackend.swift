import Foundation
import Combine
import SwiftUI

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

    public func presentAlert(_ model: AlertModel) {
        DispatchQueue.global(qos: .utility).async {
            self.alertsQueueSignal.send(
                model
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
        currentAlerts[index].timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(currentAlerts[index].countDownTimer), repeats: true) { _ in
            withAnimation(self.currentAlerts[index].alertAnimation.value) {
                self.removeAlert(alert)
            }
        }
    }

    public func removeAlert(_ alert: AlertModel) {
        guard let index = currentAlerts.firstIndex(where: { $0.id == alert.id }) else {
            print("Cannot find alert")
            return
        }

        currentAlerts[index].timer?.invalidate()
        currentAlerts[index].timer = nil
        print("Remove Alert: \(currentAlerts[index].title)")
        currentAlerts.remove(at: index)
    }
}
