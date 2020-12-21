import UIKit

extension UIViewController {
    func isValidCity(city: String) -> Bool {
        guard city.count > 2, city.count < 18 else { return false }

        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z_].*[a-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: city)
    }
}
