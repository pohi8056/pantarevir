import Foundation
import UIKit
import MapKit

class RevirAnnotationView: MKAnnotationView {
    
    // Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Called when drawing the AttractionAnnotationView
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        let revirAnnotation = self.annotation as! MKRevirAnnotation
        switch (revirAnnotation.type) {
        case .free:
            image = UIImage(named: "icon_recyclestation_pin")
            let size = CGSize(width: 100, height: 100)
            UIGraphicsBeginImageContext(size)
            image!.drawInRect(CGRectMake(0, 0, size.width, size.height))
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        default:
            image = UIImage(named: "playermarker")
        }
    }
}