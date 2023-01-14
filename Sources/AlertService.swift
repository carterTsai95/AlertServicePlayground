import Foundation
import SwiftUI
import Combine

public protocol AlertsService {
    var alertsQueueSignal: PassthroughSubject<AlertModel, Never> { get }
    func presentAlert(
        title: String
    )
}
