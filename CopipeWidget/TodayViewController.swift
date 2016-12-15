//
//  TodayViewController.swift
//  CopipeWidget
//
//  Created by shindyu on 2016/11/16.
//  Copyright © 2016年 shindyu. All rights reserved.
//

import UIKit
import PureLayout
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    // MARK: - property
    private var isMultiMode: Bool = false
    private var array = [String]()
    
    // MARK: - UI Elements
    let multiModeButton: UIButton
    let resetHistoryButton: UIButton
    let copipeStringLabel: UILabel
    let tableView: UITableView
    

    init() {
        multiModeButton = UIButton(type: .Custom)
        resetHistoryButton = UIButton(type: .Custom)
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
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .Expanded
        
        addSubviews()
        configureSubviews()
        addConstraints()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let copipeArray = defaults.objectForKey("copipe") as? [String] {
            array = copipeArray
        }
        
        // add array
        let pasteboard = UIPasteboard.generalPasteboard()
        if let copipeString = pasteboard.string {
            if !array.contains(copipeString) {
                array.append(copipeString)
            }
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(array, forKey: "copipe")
        defaults.setObject(isMultiMode, forKey: "copipe-isMultiMode")
    }
    
    private func addSubviews() {
        view.addSubview(multiModeButton)
        view.addSubview(resetHistoryButton)
        view.addSubview(copipeStringLabel)
        view.addSubview(tableView)
    }
    
    private func configureSubviews() {
        multiModeButton.setTitle("複数コピーOFF", forState: .Normal)
        multiModeButton.setTitle("複数コピーON", forState: .Selected)
        multiModeButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        multiModeButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        multiModeButton.titleLabel?.font = UIFont.systemFontOfSize(CGFloat(14))
        multiModeButton.addTarget(
            self,
            action: #selector(didTapMultiModeButton(_:)),
            forControlEvents: .TouchUpInside
        )

        resetHistoryButton.setTitle("履歴削除", forState: .Normal)
        resetHistoryButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        resetHistoryButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        resetHistoryButton.titleLabel?.font = UIFont.systemFontOfSize(CGFloat(14))
        resetHistoryButton.addTarget(
            self,
            action: #selector(didTapResetHistoryButton(_:)),
            forControlEvents: .TouchUpInside
        )
        
        copipeStringLabel.backgroundColor = UIColor.lightGrayColor()
        copipeStringLabel.numberOfLines = 0
        copipeStringLabel.font = UIFont.systemFontOfSize(CGFloat(14))
        if let pasteboardString = UIPasteboard.generalPasteboard().string {
            copipeStringLabel.text = pasteboardString
        } else {
            copipeStringLabel.text = "コピーしている内容が表示されます"
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(
            UITableViewCell.self,
            forCellReuseIdentifier: String(UITableViewCell)
        )
    }
    
    private func addConstraints() {
        multiModeButton.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        multiModeButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 20)
        
        resetHistoryButton.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        resetHistoryButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 20)
        
        copipeStringLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: multiModeButton)
        copipeStringLabel.autoPinEdgeToSuperviewEdge(.Left)
        copipeStringLabel.autoPinEdgeToSuperviewEdge(.Right)
        copipeStringLabel.autoSetDimension(.Height, toSize: 44, relation: .GreaterThanOrEqual)
        
        tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: copipeStringLabel)
        tableView.autoPinEdgeToSuperviewEdge(.Left)
        tableView.autoPinEdgeToSuperviewEdge(.Right)
        tableView.autoPinEdgeToSuperviewEdge(.Bottom)
    }

    func widgetActiveDisplayModeDidChange(activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == .Expanded) {
            self.preferredContentSize = maxSize
        } else {
            self.preferredContentSize = CGSize(
                width: 0,
                height: resetHistoryButton.bounds.height + copipeStringLabel.bounds.height
            )
        }
    }
    
    @objc private func update(notification: NSNotification)  {
        if let pasteboardString = UIPasteboard.generalPasteboard().string {
            copipeStringLabel.text = pasteboardString
            
        } else {
            copipeStringLabel.text = "コピーしている内容が表示されます"
        }
    }
    
    @objc private func didTapResetClipButton(sender: UIButton) {
        let pasteboard = UIPasteboard.generalPasteboard()
        pasteboard.strings = []
    }
    
    @objc private func didTapResetHistoryButton(sender: UIButton) {
        let pasteboard = UIPasteboard.generalPasteboard()
        pasteboard.strings = []
        array.removeAll()
        tableView.reloadData()
    }
    
    @objc private func didTapMultiModeButton(sender: UIButton) {
        let pasteboard = UIPasteboard.generalPasteboard()
        pasteboard.strings = []
        
        isMultiMode = !isMultiMode
        if isMultiMode {
            multiModeButton.backgroundColor = UIColor.orangeColor()
        } else {
            multiModeButton.backgroundColor = UIColor.clearColor()
        }
    }
}

extension TodayViewController: UITableViewDelegate {
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
}

extension TodayViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFontOfSize(CGFloat(14))
        cell.textLabel?.text = array[indexPath.row]
        if let image = UIPasteboard.generalPasteboard().image {
        }
        return cell
    }
}
