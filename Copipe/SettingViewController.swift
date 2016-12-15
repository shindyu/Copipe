import UIKit
import PureLayout

class SettingViewController: UIViewController {
    // MARK: Property
    var isMultiMode: Bool = false
    
    // MARK: UI Elements
    let multiModeSwitch: UISwitch
    
    init() {
        multiModeSwitch = UISwitch.newAutoLayoutView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        addSubviews()
        configureSubviews()
        addConstraints()
    }
    
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let mode = defaults.objectForKey("copipe-isMultiMode") as? Bool {
            isMultiMode = mode
        }
        multiModeSwitch.on = isMultiMode
    }
    
    // MARK: Private
    private func addSubviews() {
        view.addSubview(multiModeSwitch)
    }
    
    private func configureSubviews() {
        multiModeSwitch.addTarget(
            self,
            action: #selector(didTapMultiModeSwitch(_:)),
            forControlEvents: .ValueChanged
        )
    }
    
    private func addConstraints() {
        multiModeSwitch.autoAlignAxisToSuperviewAxis(.Horizontal)
        multiModeSwitch.autoAlignAxisToSuperviewAxis(.Vertical)
    }
    
    @objc private func didTapMultiModeSwitch(sender: UISwitch) {
        if sender.on {
            isMultiMode = true
        } else {
            isMultiMode = false
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(isMultiMode, forKey: "copipe-isMultiMode")
    }
    
    private func setCombineString() {
    
    }
}
