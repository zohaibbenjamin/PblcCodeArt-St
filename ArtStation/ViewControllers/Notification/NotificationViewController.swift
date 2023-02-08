//
//  NotificationViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 7/7/21.
//

import UIKit

class NotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
 
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "notification_cell"
    var pageNum = 1
    let resultPerPage = 10
    let viewModel = NotifiacationListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pageNum = 1
        viewModel.resetViewModelData()
        
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        viewModel.getAllNotifications(paginationParams: PaginationParams(page: pageNum, per_page: resultPerPage), onCompletionHandler: {
            success,message in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                if self.viewModel.notificationList.count == 0{
                    self.showAlert(title: "Alert", message: "No notifications found",alertType: .alert)
                }else{
                    // reload tableview
                    self.tableView.reloadData()
                }
            }else{
                self.showAlert(title: "Error", message: message ?? "")
            }
            
        })
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NotificationTableViewCell
        let viewModel = NotificationTableCellViewModel(notification: self.viewModel.notificationList[indexPath.row])
        cell.viewModel = viewModel
        return cell
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastVisibleCell = tableView.indexPathsForVisibleRows?.last
     
        if indexPath == lastVisibleCell  && indexPath.row == viewModel.notificationList.count - 2 && pageNum < viewModel.pageCount ?? 0{
            UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
            pageNum += 1
            viewModel.getAllNotifications(paginationParams: PaginationParams(page: pageNum, per_page: resultPerPage), onCompletionHandler: {
                success,message in
                UIManager.hideCustomActivityIndicator(controller: self)
                if success{
                    self.tableView.reloadData()
                        // reload tableview
                }
                else{
                    self.showAlert(title: "Error", message: message ?? "")
                }
                
            })
          
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

