import Foundation
import UserNotifications

/// Manages local notification permissions and scheduling.
final class NotificationService {
    func requestAuthorization() async {
        do {
            _ = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        } catch {
            // Ignore errors – notifications are optional
        }
    }

    func scheduleLimitExceededNotification() {
        let content = UNMutableNotificationContent()
        content.title = "FocusLimit"
        content.body = "You exceeded your daily limit."
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
