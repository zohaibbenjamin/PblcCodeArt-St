//
//  PastEventsTableViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/22/21.
//

import UIKit

class PastEventsTableViewController: UITableViewController {

    let resultsPerPage = 10
    var pageNum = 1
    let cellIdentifier = "past_event_cell"
    let viewModel = PastEventViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        
        viewModel.getPastEventList(urlPaginationParams: PaginationParams(page: pageNum, per_page: resultsPerPage), onCompletionHandler: {
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
    
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PastEventTableViewCell
        let viewModel = PastEventTableCellViewModel(booking: self.viewModel.bookings[indexPath.row])
        cell.viewModel = viewModel
        cell.delegate = self.parent as! EventContainerViewController
        return cell
    }
    

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastVisibleCell = tableView.indexPathsForVisibleRows?.last
        
        if indexPath == lastVisibleCell  && indexPath.row == viewModel.bookings.count - 1 && pageNum < viewModel.pageCount ?? 0{
            UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
            pageNum += 1
            viewModel.getPastEventList(urlPaginationParams:
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
