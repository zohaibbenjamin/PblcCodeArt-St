//
//  AllReviewsTableViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 6/28/21.
//

import UIKit

class AllReviewsTableViewController: UITableViewController {

    var pageNum = 1
    let resultPerPage = 10
    let viewModel = AllReviewsViewModel()
    let cellIdentifier = "review_cell"
    var bookingId : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.resetData()
        if let bookingId = self.bookingId{
        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        
            viewModel.getAllReviewsForPackage(paginationParams: PaginationParams(page: pageNum, per_page: resultPerPage), packageId: bookingId, onCompletionHandler: {
            success,errorMessage in
            UIManager.hideCustomActivityIndicator(controller: self)
            if success{
                if self.viewModel.allReviewsList.count == 0{
                    self.showAlert(title: "Alert", message: "No reviews found",alertType: .alert)
                }else{
                self.tableView.reloadData()
                }
            }else{
                self.showAlert(title: "Error", message: errorMessage ?? "")
            }
        })
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.allReviewsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ReviewTableViewCell

        let viewModel = ReviewTableCellViewModel(review: self.viewModel.allReviewsList[indexPath.row])
        cell.viewModel = viewModel
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastVisibleCell = tableView.indexPathsForVisibleRows?.last
        
        if indexPath == lastVisibleCell  && indexPath.row == viewModel.allReviewsList.count - 1 && pageNum < viewModel.pageCount ?? 0{
            UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
            pageNum += 1
            viewModel.getAllReviewsForPackage(paginationParams: PaginationParams(page: pageNum, per_page: resultPerPage), packageId: self.bookingId!, onCompletionHandler: {
                success,failureMessage in
                UIManager.hideCustomActivityIndicator(controller: self)
                if success{
                    tableView.reloadData()
                }else{
                    self.showAlert(title: "Alert", message: failureMessage ?? "")
                }
            })
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
