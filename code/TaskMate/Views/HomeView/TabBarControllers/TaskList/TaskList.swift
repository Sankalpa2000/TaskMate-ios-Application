import UIKit

class TaskList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskButtonUI: UIButton!
    var viewModel = TaskViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonsUI()
        setupTableUI()
        viewModel.bindTasksToView = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.fetchTask()
        print(viewModel.tasks)
        if let backgroundImage = UIImage(named: "background") {
                // If available, set the background color with the pattern image
                self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        } else {
            // If the image is not available, you may want to handle this case
            print("Background image not found.")
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVC = segue.destination as? EditTaskList, let taskDetails = sender as? (task: Task, taskId: String) {
            editVC.task = taskDetails.task
            editVC.taskId = taskDetails.taskId
            editVC.onDismiss = { [weak self] in
                self?.viewModel.fetchTask()
                
            }
        }
    }
    

    @IBAction func addTaskButtonTapped(_ sender: Any) {
        // Present add task view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addTaskVC = storyboard.instantiateViewController(withIdentifier: "AddTaskView") as? AddTaskList {
            addTaskVC.modalPresentationStyle = .overFullScreen
            addTaskVC.modalTransitionStyle = .crossDissolve
            addTaskVC.onDismiss = { [weak self] in
                self?.viewModel.fetchTask()
            }
            self.present(addTaskVC, animated: true, completion: nil)
        }
    }

    func setButtonsUI() {
        addTaskButtonUI.layer.cornerRadius = 0
//        addTaskButtonUI.layer.masksToBounds = true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = viewModel.tasks[indexPath.row]
        

        viewModel.fetchTaskIdForTask(task: selectedTask) { [weak self] taskId in
            guard let self = self, let taskId = taskId else {
                print("Weak reference to self is nil or failed to fetch task ID.")
                return
            }

            let taskInfo = (task: selectedTask, taskId: taskId)

            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "editTaskSegue", sender: taskInfo)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        let task = viewModel.tasks[indexPath.row]
        content.text = "Task Name: \(task.taskName)"
        content.secondaryText = "Description : \(task.taskDesc)\nDate : \(task.taskDate) \nStatus : \(task.taskState)"
        content.imageProperties.maximumSize = CGSize(width: 30, height: 30)
        content.imageProperties.cornerRadius = 30
     
        
        if task.taskState == "Completed" {
            content.image = UIImage(named: "tick")
        } else {
            content.image = UIImage(named: "remove")
        }
     
        cell.contentConfiguration = content
        
        cell.backgroundColor = .clear
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.5)
        backgroundView.layer.cornerRadius = 0
        backgroundView.layer.masksToBounds = true
        cell.backgroundView = backgroundView
        
        cell.selectionStyle = .none
        return cell
    }


    func setupTableUI(){
            tableView.tintColor = .white
            tableView.delegate = self
            tableView.dataSource = self
        }

}

