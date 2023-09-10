import UIKit

//MARK: - tableview cell setup
class MyPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usedKick: UILabel!
    
    func setupCell(number: Int) {
        usedKick.text = "\(String(number)) 번 킥보드"
    }
    
}
