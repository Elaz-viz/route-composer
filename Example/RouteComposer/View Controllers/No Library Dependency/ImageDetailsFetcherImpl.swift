//
// Created by Eugene Kazaev on 25/02/2018.
//

import Foundation
import ImageDetailsController
import UIKit

class ImageDetailsFetcherImpl: ImageDetailsFetcher {

    func details(for imageID: String, completion: @escaping (UIImage?) -> Void) {
        guard let image = UIImage(named: imageID) else {
            completion(nil)
            return
        }

        completion(image)
    }

}
