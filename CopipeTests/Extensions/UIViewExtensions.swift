import UIKit

extension UIView {
    func containButtonWithText(compareString: String) -> Bool {
        for subview in self.subviews {
            if let label = subview as? UIButton {
                if label.titleLabel?.text == compareString {
                    return true
                }
            }
        }
        return false
    }
    
    func containLabelWithText(compareString: String) -> Bool {
        for subview in self.subviews {
            if let label = subview as? UILabel {
                if label.text == compareString {
                    return true
                }
            }
        }
        return false
    }
    
    func containTextField() -> Bool {
        for subview in self.subviews {
            if let _ = subview as? UITextField {
                return true
            }
        }
        return false
    }
}
