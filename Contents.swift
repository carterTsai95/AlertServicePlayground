import SwiftUI
import Combine

let alertService = AlertsServiceBackend()
var cancellableSet: Set<AnyCancellable> = []

alertService.$currentAlerts
    .sink(receiveCompletion: { completion in
        print(".sink() received the completion", String(describing: completion))
    }, receiveValue: { alerts in
    })
    .store(in: &cancellableSet)

DispatchQueue.main.asyncAfter(deadline: .now()) {
    print("add alert no.1")
    alertService.presentAlert(title: "1st Alert")
}

DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
    print("add alert no.2")
    alertService.presentAlert(title: "2st Alert")
}

DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
    //print("remove 2st Alert")
    print("Alerts: \(alertService.currentAlerts)")
    alertService.removeAlert(alertService.currentAlerts[0])
}

