import UIKit
import Firebase

class EditViewController: UIViewController, UITextViewDelegate {
    
    var willEditImage: UIImage = UIImage()

    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var myProfileLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    
    var usernameString: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = willEditImage
        commentTextView.delegate = self
        myProfileImageView.layer.cornerRadius = 8.0
        myProfileImageView.clipsToBounds = true
        
        if UserDefaults.standard.object(forKey: "profileImage") != nil {
            let decodeData = UserDefaults.standard.object(forKey: "profileImage")
            let decodedData = NSData(base64Encoded: decodeData as! String, options: .ignoreUnknownCharacters)
            let decodedImage = UIImage(data: decodedData! as Data)
            myProfileImageView.image = decodedImage
            
            usernameString = UserDefaults.standard.object(forKey: "userName") as! String
            myProfileLabel.text = usernameString
        } else {
            myProfileImageView.image = UIImage(named: "logo.png")
            myProfileLabel.text = "匿名"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func post(_ sender: Any) {
    }
    
    func postAll() {
        
        let databaseRef = FIRDatabase.database().reference()
        let username = myProfileLabel.text!
        let message = commentTextView.text!
        
        var data: NSData = NSData()
        if let image = imageView.image {
           data = UIImageJPEGRepresentation(image, 0.1)! as NSData
        }
        let base64String = data.base64EncodedString(options: .lineLength64Characters) as String

        var data2: NSData = NSData()
        if let image2 = myProfileImageView.image {
            data2 = UIImageJPEGRepresentation(image2, 0.1)! as NSData
        }
        let base64String2 = data2.base64EncodedString(options: .lineLength64Characters) as String

        let user: NSDictionary = [
            "username":username,
            "comment":message,
            "postImage":base64String,
            "profileImage":base64String2
        ]
        
        databaseRef.child("Posts").childByAutoId().setValue(user)
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }


}
