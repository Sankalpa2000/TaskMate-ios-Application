//
//  DeleteTaskList.swift
//  TaskMate
//
//  Created by Macbook Pro 2018 on 2024-04-23.
//

import UIKit

class DeleteTask: UIViewController ,UITabBarControllerDelegate{
    var onDismiss: (() -> Void)?
    var taskToEdit: Task?
    var task:Task?
    var taskId:String
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDesc: UITextField!
    @IBOutlet weak var taskDate: UIDatePicker!
    @IBOutlet weak var deleteTask: UIButton!
    @IBOutlet weak var cancleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateFields()
        if let tabBarController = self.tabBarController {             tabBarController.delegate = self
        }
        if let backgroundImage = UIImage(named: "background") {
                
                self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        } else {
            
            print("Background image not found.")
        }
    }
    var viewModel = TaskViewModel()
    
    init(task: Task, taskId: String) {
        self.task = task
        self.taskId = taskId
        super.init(nibName: nil, bundle: nil)
    }
     
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is TaskList {
            viewModel.fetchTask()
        }
    }
    required init?(coder: NSCoder) {
        self.task = Task(taskName: "", taskDesc: "", taskDate: "")
        self.taskId = ""
        super.init(coder: coder)
    }
    func setupUI() {
        taskName.text = task?.taskName
        taskDesc.text = task?.taskDesc

    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
//        viewModel.deleteTask(taskId: taskId) { success, error in
//            if success {
//                self.dismiss(animated: true) {
//                    self.onDismiss?()
//                }
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }
        makeDeleteTaskAlert()
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
            if let navigationController = navigationController {
                navigationController.popViewController(animated: true)
            } else {
                dismiss(animated: true, completion: nil)
            }
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

    func makeDeleteTaskAlert() {
        
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.viewModel.deleteTask(taskId: self.taskId) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.dismiss(animated: true) {
                            self.navigateToWelcomeView()
                        }
                    } else if let error = error {
                        self.makeAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    func makeAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.cancel, handler: { alert in
                self.navigateToWelcomeView()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
            func navigateToWelcomeView() {

            if let welcomeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeView") {
              
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first else {
                    return
                }
                
               
                window.rootViewController = welcomeViewController
                let options: UIView.AnimationOptions = .transitionCrossDissolve
                let duration: TimeInterval = 0.3
                UIView.transition(with: window, duration: duration, options: options, animations: nil, completion: nil)
            }
        }

}
