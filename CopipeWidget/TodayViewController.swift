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
    let tableView: UITableView
    var array = ["aaaaa","bbbbb","ccccc"]

    init() {
        tableView = UITableView.newAutoLayoutView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0)
        tableView.autoPinEdgeToSuperviewEdge(.Left)
        tableView.autoPinEdgeToSuperviewEdge(.Right)
        tableView.autoPinEdgeToSuperviewEdge(.Bottom)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(
            UITableViewCell.self,
            forCellReuseIdentifier: String(UITableViewCell)
        )
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .Expanded
        self.preferredContentSize.height = 200
        
        tableView.reloadData()
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: (NCUpdateResult) -> Void) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

    func widgetActiveDisplayModeDidChange(activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == .Compact) {
            self.preferredContentSize = maxSize;
        } else {
            self.preferredContentSize = CGSize(width: 0, height: 170);
        }
    }
}

extension TodayViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("tap")
    }
}

extension TodayViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
}
