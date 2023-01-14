import SwiftUI
import Combine

let alertService = AlertsServiceBackend()
var cancellableSet: Set<AnyCancellable> = []

alertService.$currentAlerts
    .sink(receiveCompletion: { completion in
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
    alertService.removeAlert(alertService.currentAlerts[0])
}

