import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    var items = [NSDictionary]()
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    var passImage: UIImage = UIImage()
    var nowTableViewImage = UIImage()
    var nowTableViewUserName = String()
    var nowTableViewUserImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        if UserDefaults.standard.object(forKey: "check") == nil {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController!, animated: true, completion: nil)
        } else {

        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        items = [NSDictionary]()
        loadAllData()
        tableView.reloadData()
    }
    
    func refresh() {
        items = [NSDictionary]()
        loadAllData()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let dict = items[indexPath.row]
        
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        let decodedData2 = (base64Encoded: dict["photoBase64_2"])
        let decodededData2 = NSData(base64Encoded: decodedData2 as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage2 = UIImage(data: decodededData2! as Data)
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
        profileImageView.image = decodedImage2
        
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = dict["username"] as? String
        
        let postedImageView = cell.viewWithTag(3) as! UIImageView
        let decodedData = (base64Encoded: dict["photoBase64"])
        let decodededData = NSData(base64Encoded: decodedData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage = UIImage(data: decodededData! as Data)
        postedImageView.image = decodedImage
        
        let commentTextView = cell.viewWithTag(4) as! UITextView
        commentTextView.text = dict["comment"] as? String
        
        
        return cell
    }
    
    func loadAllData() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let firebase = FIRDatabase.database().reference(fromURL: "https://happystagram-9dde4.firebaseio.com/").child("Posts")
        
        firebase.queryLimited(toLast: 10).observe(.value) { (snapshot, error) in
            var tempItems = [NSDictionary]()
            
            for item in snapshot.children {
                let child = item as! FIRDataSnapshot
                let dict = child.value
                tempItems.append(dict as! NSDictionary)
            }
            
            self.items = tempItems
            self.items = self.items.reversed()
            self.tableView.reloadData()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = items[indexPath.row]
        
        let decodeData = (base64Encoded: dict["profileImage"])
        let decodedData = NSData(base64Encoded: decodeData as! String, options: .ignoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData! as Data)
        nowTableViewImage = decodedImage!
        
        nowTableViewUserName = (dict["username"] as? String)!
        
        let decodeData2 = (base64Encoded: dict["postImage"])
        let decodedData2 = NSData(base64Encoded: decodeData2 as! String, options: .ignoreUnknownCharacters)
        let decodedImage2 = UIImage(data: decodedData2! as Data)
        nowTableViewImage = decodedImage2!
        
        performSegue(withIdentifier: "sns", sender: nil)
    }
    
    @IBAction func showCamera(_ sender: Any) {
        openCamera()
    }
    
    @IBAction func showPhotos(_ sender: Any) {
        openPhoto()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            passImage = pickedImage
            performSegue(withIdentifier: "next", sender: nil)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "next") {
            let editVC: EditViewController = segue.destination as! EditViewController
            editVC.willEditImage = passImage
        }
        
        if (segue.identifier == "sns") {
            let snsVC: SnsViewController = segue.destination as! SnsViewController
            snsVC.detailImage = nowTableViewImage
            snsVC.detailProfileImage = nowTableViewUserImage
            snsVC.detailUserName = nowTableViewUserName
        }
    }
    
    func openCamera() {
        let sourceType: UIImagePickerControllerSourceType = .camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func openPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoPicker = UIImagePickerController()
            photoPicker.sourceType = .photoLibrary
            photoPicker.delegate = self
            self.present(photoPicker, animated: true, completion: nil)
        }
    }

}

