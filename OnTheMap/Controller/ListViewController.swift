//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Fabio Italiano on 8/2/20.
//  Copyright © 2020 Fabio Italiano. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    @IBOutlet weak var studentTableView: UITableView!
    
    var students = [StudentAttributes]()
    var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        indicator = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.gray)
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.center = self.view.center
        handleActivityIndicator(isRunning: true)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentsList()
    }
    
    // MARK: - Log Out
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        handleActivityIndicator(isRunning: true)
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.handleActivityIndicator(isRunning: false)
            }
        }
    }
    
    
    @IBAction func refreshList(_ sender: UIBarButtonItem) {
        getStudentsList()
    }
    
    // MARK: - Get Student List
    
    func getStudentsList() {
        handleActivityIndicator(isRunning: true)
        UdacityClient.getStudentLocations() {students, error in
            self.students = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.handleActivityIndicator(isRunning: false)
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath)
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        openLink(student.mediaURL ?? "")
    }
    
    // MARK: - Manage the Indicator
    
    func handleActivityIndicator(isRunning: Bool) {
        isRunning ? indicator.startAnimating() : indicator.stopAnimating()
        indicator.isHidden = isRunning
    }
    
//    func showActivityIndicator() {
//        indicator.isHidden = false
//        indicator.startAnimating()
//    }
//
//    func hideActivityIndicator() {
//        indicator.stopAnimating()
//        indicator.isHidden = true
//    }
    
}
