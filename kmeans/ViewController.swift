
import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {

    private var selectedImage : UIImage? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onChooseTap(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPretty" {
            guard let selectedImage = self.selectedImage, let destinationVC = segue.destination as? PrettyViewController else {
                return
            }
            destinationVC.mainImage = selectedImage
        }
    }
}
extension ViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        self.selectedImage = info[.originalImage] as? UIImage
        picker.dismiss(animated: false, completion: nil)
        performSegue(withIdentifier: "showPretty", sender: self)
    }
}
