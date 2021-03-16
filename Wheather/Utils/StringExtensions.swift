import UIKit

extension UIViewController {
    
    func isValidCity(city: String) -> Bool {
        guard city.count > 2, city.count < 18 else { return false }

        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[а-яА-ЯёЁa-zA-Z][а-яА-ЯёЁa-zA-Z- ]*[а-яА-ЯёЁa-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: city)
    }
}

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", comment: "")
    }
}
