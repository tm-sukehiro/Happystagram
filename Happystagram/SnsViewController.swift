import UIKit
import Social

class SnsViewController: UIViewController {
    
    var detailImage = UIImage()
    var detailProfileImage = UIImage()
    var detailUserName = String()
    var myComposeView: SLComposeViewController!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileImageView.image = detailProfileImage
        label.text = detailUserName
        imageView.image = detailImage
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func shareTwitter(_ sender: Any) {
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        let string = "#Happystagram" + " photo by " + label.text!
        myComposeView.setInitialText(string)
        
        myComposeView.add(imageView.image)
        
        self.present(myComposeView, animated: true, completion: nil)
    }
}
