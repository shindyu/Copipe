import UIKit
import PureLayout

class ViewController: UIViewController {
    // MARK: - Static
    let MaxArraySize: Int = 20
    
    // MARK: - Properties
    private let defaults = NSUserDefaults.standardUserDefaults()
    private var isMultiMode: Bool = false
    private var array = [String]()
    private var timer = NSTimer()
    
    // MARK: - UI Elements
    let copipeStringLabel: UILabel
    let tableView: UITableView
    
    
    init() {
        copipeStringLabel = UILabel.newAutoLayoutView()
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
        
        array = getArray()
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let mode = defaults.objectForKey("copipe-isMultiMode") as? Bool {
            isMultiMode = mode
        }
    }
    
    // MARK: - private
    private func addSubviews() {
        view.addSubview(copipeStringLabel)
        view.addSubview(tableView)
    }
    
    private func configureSubviews() {
        copipeStringLabel.backgroundColor = UIColor.greenColor()//UIColor(red: 46, green: 204, blue: 113, alpha: 0)
        copipeStringLabel.numberOfLines = 0
        copipeStringLabel.font = UIFont.systemFontOfSize(CGFloat(14))
        if let pasteboardString = UIPasteboard.generalPasteboard().string {
            copipeStringLabel.text = pasteboardString
        } else {
            copipeStringLabel.text = "コピーしている内容が表示されます"
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(
            UITableViewCell.self,
            forCellReuseIdentifier: String(UITableViewCell)
        )
    }
    
    private func addConstraints() {
        copipeStringLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        copipeStringLabel.autoPinEdgeToSuperviewEdge(.Left)
        copipeStringLabel.autoPinEdgeToSuperviewEdge(.Right)
        copipeStringLabel.autoSetDimension(.Height, toSize: 44, relation: .GreaterThanOrEqual)
        
        tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: copipeStringLabel)
        tableView.autoPinEdgeToSuperviewEdge(.Left)
        tableView.autoPinEdgeToSuperviewEdge(.Right)
        tableView.autoPinToBottomLayoutGuideOfViewController(self, withInset: 0)
    }
    
    private func getArray() -> [String] {
        var returnArray = [String]()
        if let savedArray = defaults.objectForKey("copipe") as? [String] {
            returnArray = savedArray
        }
        return returnArray
    }
    
    private func saveArray() {
        var tmpArray = [String]()
        
        for row in 0..<array.count {
            if row == MaxArraySize {
                break
            }
            tmpArray.append(array[row])
        }
        array = tmpArray
        defaults.setObject(array, forKey: "copipe")
        defaults.synchronize()
    }
    
    @objc private func update(notification: NSNotification)  {
        if let pasteboardString = UIPasteboard.generalPasteboard().string {
            copipeStringLabel.text = pasteboardString
            
        } else {
            copipeStringLabel.text = "コピーしている内容が表示されます"
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let pasteboard = UIPasteboard.generalPasteboard()
        
        if isMultiMode {
            if let pasteboardString = pasteboard.string {
                pasteboard.string = pasteboardString + "\n" + array[indexPath.row]
            } else {
                pasteboard.string = array[indexPath.row]
            }
        } else {
            pasteboard.string = array[indexPath.row]
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.editing = editing
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let pasteboard = UIPasteboard.generalPasteboard()
        if let pasteboardString = pasteboard.string {
            if array[indexPath.row] == pasteboardString {
                copipeStringLabel.text = "コピーしている内容が表示されます"
                pasteboard.strings = []
            }
        }
        array.removeAtIndex(indexPath.row)
        saveArray()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
