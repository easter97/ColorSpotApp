//
//  ViewController.swift
//  ColorSpot App
//
//  Created by Amanda on 4/24/19.
//  Copyright © 2019 Amanda. All rights reserved.
//

import UIKit

//On the top of your swift
extension UIImage {
    func getPixelColor(atLocation location: CGPoint, withFrameSize size: CGSize) -> UIColor {
        let x: CGFloat = (self.size.width) * location.x / size.width
        let y: CGFloat = (self.size.height) * location.y / size.height
        
        let pixelPoint: CGPoint = CGPoint(x: x, y: y)
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelIndex: Int = ((Int(self.size.width) * Int(pixelPoint.y)) + Int(pixelPoint.x)) * 4
        
        let r = CGFloat(data[pixelIndex]) / CGFloat(255.0)
        let g = CGFloat(data[pixelIndex+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelIndex+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelIndex+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var debugBox: UIView!
    /// Takes the screenshot of the screen and returns the corresponding image
    ///
    /// - Parameter shouldSave: Boolean flag asking if the image needs to be saved to user's photo library. Default set to 'true'
    /// - Returns: (Optional)image captured as a screenshot
    open func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            print(position)
            //let screenshot = takeScreenshot(true)
            let color = imageView.image!.getPixelColor(atLocation: position, withFrameSize: imageView.frame.size)
            print(color)
            debugBox.backgroundColor = color
            print(getColorName(color))
        }
    }

    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        debugBox.layer.borderWidth = 5
        debugBox.layer.borderColor = UIColor.black.cgColor
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
    }
    func getColorName(_ color: UIColor) -> String
    {
        var colorName :String = "White"
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        let rgDif: CGFloat = abs(red - green) * 256
        let gbDif: CGFloat = abs(green - blue) * 256
        let brDif: CGFloat = abs(blue - red) * 256
        
        if (hue == 0 || saturation <= 0.01 ||
            (rgDif < 15 && gbDif < 15 && brDif < 15)
            ) {
            let redValue: CGFloat = red * 256;
            if (redValue < 22) {
                colorName = "Black";
            } else if (redValue >= 22 && redValue < 241) {
                colorName = "Gray";
            } else {
                colorName = "White";
            }
        } else if (0 < hue && hue <= 18) {
            colorName = "Red";
        } else if (19 <= hue && hue <= 42) {
            colorName = "Orange";
        } else if (42 <= hue && hue <= 70) {
            colorName = "Yellow";
        } else if (71 <= hue && hue <= 79) {
            colorName = "Lime";
        } else if (80 <= hue && hue <= 163) {
            colorName = "Green";
        } else if (164 <= hue && hue <= 193) {
            colorName = "Cyan";
        } else if (194 <= hue && hue <= 240) {
            colorName = "Blue";
        } else if (241 <= hue && hue <= 260) {
            colorName = "Indigo";
        } else if (261 <= hue && hue <= 270) {
            colorName = "Violet";
        } else if (271 <= hue && hue <= 291) {
            colorName = "Purple";
        } else if (292 <= hue && hue <= 327) {
            colorName = "Magenta";
        } else if (328 <= hue && hue <= 344) {
            colorName = "Rose";
        } else if (345 <= hue && hue <= 360) {
            colorName = "Red";
        }
        return colorName;
    }
    
}

