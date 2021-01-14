import UIKit

class ButtonWithActivityIndicator: UIButton {
    
    // MARK: - Constants
    
    private let activityIndicator = UIActivityIndicatorView()
    private var buttonTitleLabelText = ""
    private var buttonImage = UIImage()
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateActivityIndicator(indicator: activityIndicator, view: self)
    }
    
    // MARK: - Logic
    
    func startActivityIndicator() {
        isEnabled = false
        buttonImage = imageView?.image ?? UIImage()
        setImage(nil, for: .normal)
        buttonTitleLabelText = titleLabel!.text ?? ""
        setTitle("", for: .normal)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func stopActivityIndicator() {
        isEnabled = true
        activityIndicator.stopAnimating()
        setTitle(buttonTitleLabelText, for: .normal)
        setImage(buttonImage, for: .normal)
    }
    
    private func updateActivityIndicator(indicator: UIActivityIndicatorView, view: UIView) {
        indicator.hidesWhenStopped = true
        indicator.isHidden = true
        indicator.color = #colorLiteral(red: 0.5529384017, green: 0.4286764264, blue: 0.1908931732, alpha: 1)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
}
