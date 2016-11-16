import Quick
import Nimble
@testable import Copipe

class ViewControllerTest: QuickSpec {
    override func spec() {
        describe("the view layout") {
            it("has a textField") {
                let vc = ViewController()
                
                expect(vc.view.containButtonWithText("pasteboard")).to(beTrue())
                
                expect(vc.view.containLabelWithText("copy")).to(beTrue())
                
                expect(vc.view.containTextField()).to(beTrue())
            }
        }
    }
}
