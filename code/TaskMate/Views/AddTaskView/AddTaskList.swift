//
//  AddTaskList.swift
//  TaskMate
//
//  Created by Macbook Pro 2018 on 2024-04-23.
//

import UIKit

class AddTaskList: UIViewController {
    var onDismiss: (() -> Void)?
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDesc: UITextField!
    @IBOutlet weak var taskDate: UIDatePicker!
    @IBOutlet weak var AddButton: UIButton!
    var viewModel = TaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancleButton()
        if let backgroundImage = UIImage(named: "background") {
                // If available, set the background color with the pattern image
                self.view.backgroundColor = UIColor(patternImage: backgroundImage)
            } else {
                // If the image is not available, you may want to handle this case
                print("Background image not found.")
            }
    }
    func setupCancleButton(){
        let closeButton = UIButton(frame: CGRect(x: 20, y: 50, width: 80, height: 40))
        closeButton.setTitle("Cancel", for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        
        let bottomSpace = self.view.frame.size.height - (taskName.frame.origin.y + taskName.frame.size.height)
        
        
        if keyboardSize.height > bottomSpace {
            self.view.frame.origin.y = 0 - keyboardSize.height + bottomSpace
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y = 0
    }
    
    
    func setupButtonUI(){
        AddButton.layer.cornerRadius = 15
        AddButton.layer.masksToBounds = true
    }
    @objc func closeTapped() {
        self.dismiss(animated: true) { [weak self] in
            self?.onDismiss?()
        }
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let taskName = taskName.text, !taskName.isEmpty,
              let taskDesc = taskDesc.text else {
            makeAlert(title: "Error", message: "Please enter valid data.")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let taskDateString = dateFormatter.string(from: taskDate.date)
        let task = Task(taskName: taskName, taskDesc: taskDesc, taskDate: taskDateString)
        viewModel.addTask(task: task) { success, error in
            if success {
                self.dismiss(animated: true) { [weak self] in
                    self?.onDismiss?()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func makeAlert(title: String, message: String, actionTitle: String = "OK") {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
            self.present(alert, animated:true)
        }
        deinit {
            NotificationCenter.default.removeObserver(self)
        }

}
