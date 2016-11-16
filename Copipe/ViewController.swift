import UIKit
import PureLayout

class ViewController: UIViewController {
    let button: UIButton
    let copyLabel: UILabel
    let textField: UITextField
    let tableView: UITableView
    var array = [String]()
    var tableArray = ["first", "second", "third"]
    
    init() {
        button = UIButton.newAutoLayoutView()
        copyLabel = UILabel.newAutoLayoutView()
        textField = UITextField.newAutoLayoutView()
        tableView = UITableView.newAutoLayoutView()
        
        super.init(nibName: nil, bundle: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(update(_:)),
            name: UIPasteboardChangedNotification,
            object: nil)

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
        tableView.reloadData()
    }
    
    // MARK: - private
    private func addSubviews() {
        view.addSubview(button)
        view.addSubview(copyLabel)
        view.addSubview(textField)
        view.addSubview(tableView)
    }
    
    private func configureSubviews() {
        button.setTitle("pasteboard", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.addTarget(
            self,
            action: #selector(didTapButton(_:)),
            forControlEvents: .TouchUpInside
        )
        
        copyLabel.text = "copy"
        
        textField.becomeFirstResponder()
        
        tableView.dataSource = self
        tableView.registerClass(
            UITableViewCell.self,
            forCellReuseIdentifier: String(UITableViewCell)
        )
    }
    
    private func addConstraints() {
        button.autoPinToTopLayoutGuideOfViewController(self, withInset: 10)
        button.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        
        copyLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: button, withOffset: 10)
        copyLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        
        textField.autoPinEdge(.Top, toEdge: .Bottom, ofView: copyLabel, withOffset: 10)
        textField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        textField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        
        tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: textField)
        tableView.autoPinEdgeToSuperviewEdge(.Left)
        tableView.autoPinEdgeToSuperviewEdge(.Right)
        tableView.autoPinEdgeToSuperviewEdge(.Bottom)
    }

    @objc private func didTapButton(sender: UIButton) {
        if UIPasteboard.generalPasteboard().hasStrings {
            print("paste")
        }
    }
    
    
    //関数で受け取った時のアクションを定義
    @objc private func update(notification: NSNotification)  {
        let board = UIPasteboard.generalPasteboard()
        array.append(board.string!)
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = tableArray[indexPath.row]
        return cell
    }
}
