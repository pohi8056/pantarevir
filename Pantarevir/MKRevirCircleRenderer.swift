

import Foundation
import MapKit

class MKRevirCircleRenderer: MKCircleRenderer{
    
    var overlayColor: UIColor?
    
    init(overlay:MKOverlay, color: UIColor) {
        self.overlayColor = color
        
        super.init(overlay: overlay)
    }
    
    
}