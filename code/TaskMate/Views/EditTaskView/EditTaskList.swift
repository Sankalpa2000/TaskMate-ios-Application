//
//  EditTaskList.swift
//  TaskMate
//
//  Created by Macbook Pro 2018 on 2024-04-23.
//

import UIKit

class EditTaskList: UIViewController {
    var onDismiss: (() -> Void)?
    var taskToEdit: Task? // This will hold the task being edited
    var task:Task?
    var taskId:String
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDesc: UITextField!
    @IBOutlet weak var taskDate: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancleButtonUI: UIButton!
    @IBOutlet weak var completeButtonUI: UIButton!
    
    
    var viewModel = TaskViewModel()
    
    init(task: Task, taskId: String) {
        self.task = task
        self.taskId = taskId
        super.init(nibName: nil, bundle: nil)
    }
     
    required init?(coder: NSCoder) {
        self.task = Task(taskName: "", taskDesc: "", taskDate: "")
        self.taskId = ""
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        populateFields() // Populate fields with existing task data
        setupButtonUI()
        setupUI()
        if let backgroundImage = UIImage(named: "background") {
                // If available, set the background color with the pattern image
                self.view.backgroundColor = UIColor(patternImage: backgroundImage)
            } else {
                // If the image is not available, you may want to handle this case
                print("Background image not found.")
            }
    }
    func setupUI() {
        taskName.text = task?.taskName
        taskDesc.text = task?.taskDesc

    }

    func populateFields() {
        guard let task = taskToEdit else { return }
        taskName.text = task.taskName
        taskDesc.text = task.taskDesc
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        if let date = dateFormatter.date(from: task.taskDate) {
            taskDate.date = date
        }
    }
    @IBAction func completedOnTap(_ sender: Any) {
        viewModel.completeTask(taskId: taskId) { success, error in
            if success {
                print("Task marked as completed successfully.")
                self.dismiss(animated: true){
                    self.onDismiss?()
                }
                // You can perform any additional actions here, such as updating the UI
            } else if let error = error {
                print("Error marking task as completed: \(error.localizedDescription)")
            }
        }
    }

    
    
    func setupButtonUI() {
        saveButton.layer.cornerRadius = 15
        saveButton.layer.masksToBounds = true
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
        viewModel.editTask(taskId:taskId, updatedTask: task) { success, error in
            if success {
                self.dismiss(animated: true) { [weak self] in
                    self?.onDismiss?()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
//    @IBAction func saveButtonTapped(_ sender: Any) {
//        guard let taskName = taskName.text, !taskName.isEmpty,
//              let taskDesc = taskDesc.text,
//              let taskDate = taskDate.date,
//              let taskToEdit = taskToEdit else {
//            makeAlert(title: "Error", message: "Please enter valid data.")
//            return
//        }
//        
//        // Create an updated task object
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-dd-yyyy"
//        let taskDateString = dateFormatter.string(from: taskDate)
//        
//        let updatedTask = Task(taskName: taskName, taskDesc: taskDesc, taskDate: taskDateString)
//        
//        // Call the editTask function to update the task
//        viewModel.editTask(taskId: taskToEdit.taskId, updatedTask: updatedTask) { success, error in
//            if success {
//                self.dismiss(animated: true) { [weak self] in
//                    self?.onDismiss?()
//                }
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }
//    }


    func makeAlert(title: String, message: String, actionTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated:true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
           if let navigationController = navigationController {
               navigationController.popViewController(animated: true)
           } else {
               dismiss(animated: true, completion: nil)
           }
       }
}

