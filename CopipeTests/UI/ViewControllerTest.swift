import Quick
import Nimble
@testable import Copipe

class ViewControllerTest: QuickSpec {
    override func spec() {
        describe("the view layout") {
            it("has a textField") {
                let vc = ViewController()
                
                expect(vc.view.containTextField()).to(beTrue())
            }
        }
    }
}
