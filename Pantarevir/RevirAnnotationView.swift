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
            image = UIImage(named: "locationmarker")
        default:
            image = UIImage(named: "playermarker")
        }
    }
}