
import UIKit
import Foundation

class PrettyViewController: UIViewController {
    
    @IBOutlet weak var paletteView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var colorViews: [UIView]!
    @IBOutlet weak var mainImageView: UIImageView!
    var mainImage : UIImage? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImageView.image = mainImage
        if let mainImage = mainImage {
           makePretty(image : mainImage)
        }
    }
    func makePretty(image : UIImage) {
        activityIndicator.isHidden = false
        mainImageView.isHidden = true
        label.isHidden = true
        paletteView.isHidden = true
        view.backgroundColor = UIColor.black
        DispatchQueue.global(qos: .userInitiated).async {
            let smallImage = image.resized(to: CGSize(width: 100, height: 100))
            let kMeans = KMeansClusterer()
            let points = smallImage.getPixels().map({KMeansClusterer.Point(from: $0)})
            let clusters = kMeans.cluster(points: points, into: 3).sorted(by: {$0.points.count > $1.points.count})
            let colors = clusters.map(({$0.center.toUIColor()}))
            guard let mainColor = colors.first else {
                return
            }

            let textColor = self.makeTextColor(from: mainColor)
            DispatchQueue.main.async {  [weak self] in
                guard let self = self else {
                    return
                }
                self.showMainImage()
                self.activityIndicator.isHidden = true
                self.showPalette(colors)
                self.setBackgroundColor(mainColor)
                self.showText(textColor)
            }
        }
    }
    func makeTextColor(from color : UIColor) -> UIColor {
        return color.hslColor.shiftHue(by: 0.5).shiftSaturation(by: -0.5).shiftBrightness(by: 0.5).uiColor
    }
    func showMainImage() {
        mainImageView.alpha = 0
        mainImageView.isHidden = false
        mainImageView.transform = mainImageView.transform.translatedBy(x: 0, y: -mainImageView.bounds.height)
        mainImageView.animate(duration: 0.2) { (mainImageView) in
            mainImageView.transform = CGAffineTransform.identity
        }
        mainImageView.animate(duration: 0.4) { (mainImageView) in
            mainImageView.alpha = 1
        }
    }
    func setBackgroundColor(_ color : UIColor) {
        view.backgroundColor = UIColor.black
        view.animate(duration: 0.3, { (view) in
            view.backgroundColor = color
        })
    }
    func showText(_ color : UIColor) {
        label.isHidden = false
        label.alpha = 0
        label.textColor = color
        label.animate(duration: 0.5) { (label) in
            label.alpha = 1
        }
    }
    func showPalette(_ colors : [UIColor]) {
        paletteView.isHidden = false
        paletteView.alpha = 0
        paletteView.transform = paletteView.transform.translatedBy(x: view.bounds.width, y: 0)
        for (i, view) in self.colorViews.enumerated() {
            if i >= colors.count {
                break
            }
            view.backgroundColor = colors[i]
        }
        paletteView.animate(duration: 0.3, delay: 0.4) {paletteView in
            paletteView.transform = CGAffineTransform.identity
        }
        paletteView.animate(duration: 0.5, delay: 0.4) {paletteView in
            paletteView.alpha = 1
        }
    }
    @IBAction func onRefreshTap(_ sender: Any) {
        if let mainImage = mainImage {
            makePretty(image : mainImage)
        }
    }
    
    override func viewDidLayoutSubviews() {
        createGradientMask()
    }
    
    func createGradientMask() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = mainImageView.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.locations = [0.6]
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        mainImageView.layer.mask = gradientLayer
    }
}

extension UIView {
    func animate(duration : TimeInterval, delay : TimeInterval = 0, _ animations : @escaping (UIView)->Void) {
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseOut], animations: {
            animations(self)
        })
    }
}
