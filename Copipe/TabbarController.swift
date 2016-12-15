import UIKit
import FontAwesome

class TabBarController: UITabBarController {
    var firstView: ViewController!
    var secondView: SettingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstView = ViewController()
        secondView = SettingViewController()
        
        //表示するtabItemを指定（今回はデフォルトのItemを使用）
        let listImage = UIImage.fontAwesomeIconWithName(.ListUL, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
        firstView.tabBarItem = UITabBarItem(title: "リスト", image: listImage, tag: 1)
        let gearImage = UIImage.fontAwesomeIconWithName(.Gear, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
        secondView.tabBarItem = UITabBarItem(title: "設定", image: gearImage, tag: 2)
        
        // タブで表示するViewControllerを配列に格納します。
        let myTabs = NSArray(objects: firstView!, secondView!)
        
        // 配列をTabにセットします。
        self.setViewControllers(myTabs as? [UIViewController], animated: false)
        
        navigationItem.title = "Copipe"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
