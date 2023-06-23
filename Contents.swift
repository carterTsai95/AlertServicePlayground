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
    alertService.presentAlert(
        .init(title: "1nd Alert", countDownTimer: 1)
    )
}

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    print("add alert no.2")
    alertService.presentAlert(
        .init(title: "2nd Alert", countDownTimer: 3)
    )
}

DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
    alertService.removeAlert(alertService.currentAlerts.first ?? AlertModel(title: ""))
}

