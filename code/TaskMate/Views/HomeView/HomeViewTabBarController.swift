import UIKit

class HomeViewTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundImage = UIImage(named: "background") {
                // If available, set the background color with the pattern image
                self.view.backgroundColor = UIColor(patternImage: backgroundImage)
            } else {
                // If the image is not available, you may want to handle this case
                print("Background image not found.")
            }
    
        if let navigationController = self.navigationController {
            var viewControllers = navigationController.viewControllers
            viewControllers.remove(at: viewControllers.count - 2)
            navigationController.setViewControllers(viewControllers, animated: true)
        }
    }
}



