//
//  UpcomingEventTableViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/22/21.
//

import UIKit

class UpcomingEventTableViewController: UITableViewController {

    let resultsPerPage = 10
    var pageNum = 1

    let viewModel = UpcomingEventViewModel()
    let cellIdentifier = "upcoming_event_cell"
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageNum = 1
        viewModel.resetBookingsData()
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        viewModel.getUpcomingEventList(pagingParams: PaginationParams(page: pageNum, per_page: resultsPerPage), onCompletionHandler: {
            success,errorMessage in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                if self.viewModel.bookings.count == 0{
                    self.showAlert(title: "Alert", message: "No bookings found",alertType: .alert)
                }else{
                    self.tableView.reloadData()
                }
            }else{
                self.showAlert(title: "Error", message: errorMessage ?? "")
            }
        })
    }
    
    func setupUI(){
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.bookings.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        as! UpcomingEventTableViewCell
        let viewModel = UpcomingEventTableCellViewModel(booking : self.viewModel.bookings[indexPath.row])
        cell.viewModel =  viewModel
        cell.delegate = parent as! EventContainerViewController
        return cell
    }
    

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastVisibleCell = tableView.indexPathsForVisibleRows?.last
        
        if indexPath == lastVisibleCell  && indexPath.row == viewModel.bookings.count - 1 && pageNum < viewModel.pageCount ?? 0{
            UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
            pageNum += 1
            viewModel.getUpcomingEventList(pagingParams:
            PaginationParams(page: pageNum, per_page: resultsPerPage), onCompletionHandler: {
                success,failureMessage in
                UIManager.hideCustomActivityIndicator(controller: self)
                if success{
                    tableView.reloadData()
                }else{
                    self.showAlert(title: "Error", message: failureMessage ?? "")
                }
            })
        }
    }
}
