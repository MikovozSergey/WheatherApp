import UIKit

extension UIViewController {
    func isValidCity(city: String) -> Bool {
        guard city.count > 2, city.count < 18 else { return false }

        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[а-яА-ЯёЁa-zA-Z][а-яА-ЯёЁa-zA-Z ]*[а-яА-ЯёЁa-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: city)
    }
    
}

extension String {
    var isCyrillic: Bool {
        let upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let lower = "abcdefghijklmnopqrstuvwxyz"
        for char in self.map({String($0)}) where !upper.contains(char) && !lower.contains(char) {
            return true
        }
        return false
    }
}
