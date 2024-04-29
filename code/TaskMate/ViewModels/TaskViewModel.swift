//
//  TaskViewModel.swift
//  TaskMate
//
//  Created by Macbook Pro 2018 on 2024-04-20.
//

import Foundation
import Firebase

class TaskViewModel {
    
    var bindTasksToView: (() -> Void) = {}
    var tasks: [Task] = [] {
        didSet {
            self.bindTasksToView()
        }
    }
    func fetchTask() {
        fetchTasks { [weak self] (tasks, error) in
            if let tasks = tasks {
                self?.tasks = tasks
            } else {
                print(error?.localizedDescription ?? "An error occurred")
            }
        }
    }
    func fetchTaskCompleted() {
        fetchCompletedTasks { [weak self] (tasks, error) in
            if let tasks = tasks {
                self?.tasks = tasks
            } else {
                print(error?.localizedDescription ?? "An error occurred")
            }
        }
    }
    
    func addTask(task: Task, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("tasks").addDocument(data: [
            "taskName": task.taskName,
            "taskDesc": task.taskDesc,
            "taskDate": task.taskDate,
            "taskState": "Not Completed" // Set taskState to "Not Completed" initially
        ]) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    
    func fetchTasks(completion: @escaping ([Task]?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("tasks").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                var tasks = [Task]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let taskName = data["taskName"] as? String ?? ""
                    let taskDesc = data["taskDesc"] as? String ?? ""
                    let taskDate = data["taskDate"] as? String ?? ""
                    let taskState = data["taskState"] as? String ?? ""
                    let task = Task(taskName: taskName, taskDesc: taskDesc, taskDate: taskDate, taskState: taskState)
                    tasks.append(task)
                }
                completion(tasks, nil)
            }
        }
    }
    func fetchCompletedTasks(completion: @escaping ([Task]?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("tasks").whereField("taskState", isEqualTo: "Completed").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                var tasks = [Task]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let taskName = data["taskName"] as? String ?? ""
                    let taskDesc = data["taskDesc"] as? String ?? ""
                    let taskDate = data["taskDate"] as? String ?? ""
                    let taskState = data["taskState"] as? String ?? ""
                    let task = Task(taskName: taskName, taskDesc: taskDesc, taskDate: taskDate, taskState: taskState)
                    tasks.append(task)
                }
                completion(tasks, nil)
            }
        }
    }
    
    func editTask(taskId: String, updatedTask: Task, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        let taskRef = db.collection("tasks").document(taskId)

        taskRef.updateData([
            "taskName": updatedTask.taskName,
            "taskDesc": updatedTask.taskDesc,
            "taskDate": updatedTask.taskDate,
            "taskState": "Not Completed" // Set taskState to "Not Completed" during edit
        ]) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func completeTask(taskId: String, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        let taskRef = db.collection("tasks").document(taskId)

        taskRef.updateData([
            "taskState": "Completed" // Set taskState to "Completed" when completing task
        ]) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func deleteTask(taskId: String, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        let taskRef = db.collection("tasks").document(taskId)
        
        taskRef.delete { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    func fetchTaskIdForTask(task: Task, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        db.collection("tasks")
            .whereField("taskName", isEqualTo: task.taskName)
            .whereField("taskDesc", isEqualTo: task.taskDesc)
            .whereField("taskDate", isEqualTo: task.taskDate)
            .whereField("taskState", isEqualTo: task.taskState)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching task ID: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    if let document = querySnapshot?.documents.first {
                        let taskId = document.documentID
                        completion(taskId)
                    } else {
                        print("Task not found.")
                        completion(nil)
                    }
                }
            }
    }
}
