//
//  QuestionsViewController.swift
//  ArtStation
//
//  Created by Apple on 25/06/2021.
//

import UIKit

class QuestionsViewController: UIViewController,ProtocolReloadCellData {
  
  
    
   
    
    @IBOutlet weak var tblMain: UITableView!
    var numberOfLines=3
    var ifButtonCLicked=false
    var indexPth = IndexPath.init(index: 0)
    var PostViewHidden = true
    var queList = ["1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over? \n 3. What food have you never eaten but would really like to try? \n 4. What’s something you really resent paying for? \n 5. What would a world populated by clones of you be like? \n 6. Do you think that aliens exist? \n 7. What are you currently worried about? \n 8. Where are some unusual places you’ve been? \n 9. Where do you get your news? \n 10. What are some red flags to watch out for in daily life?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over? \n 3. What food have you never eaten but would really like to try? \n 4. What’s something you really resent paying for? \n 5. What would a world populated by clones of you be like? \n 6. Do you think that aliens exist? \n 7. What are you currently worried about? \n 8. Where are some unusual places you’ve been? \n 9. Where do you get your news? \n 10. What are some red flags to watch out for in daily life?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over? \n 3. What food have you never eaten but would really like to try?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over? \n 3. What food have you never eaten but would really like to try?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over? \n 3. What food have you never eaten but would really like to try? \n 4. What’s something you really resent paying for? \n 5. What would a world populated by clones of you be like? \n 6. Do you think that aliens exist?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over? \n 3. What food have you never eaten but would really like to try? \n 4. What’s something you really resent paying for? \n 5. What would a world populated by clones of you be like? \n 6. Do you think that aliens exist? \n 7. What are you currently worried about? \n 8. Where are some unusual places you’ve been? \n 9. Where do you get your news? \n 10. What are some red flags to watch out for in daily life?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over?","1. What weird food combinations do you really enjoy?"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMain.dataSource=self
        tblMain.delegate=self
        // Do any additional setup after loading the view.
    }
}

extension QuestionsViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        if indexPath.row==0
        {
            return 90
        }
        else
        {
            return  UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row==0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QueTittleTableViewCell") as! QueTittleTableViewCell
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QueMainCell") as! QueMainCell
            cell.delegateReload = self
            cell.configureCellNData()
            cell.lblName.text="Hassan Aqmal"
            cell.indexPath = indexPath
            cell.lblQue.text=queList[indexPath.row]
            cell.viewPost.isHidden = PostViewHidden
            
            if ifButtonCLicked
            {
                cell.lblQue.numberOfLines = cell.lblQue.maxNumberOfLines
            }
            else
            {
                cell.lblQue.numberOfLines = 3
            }
            return cell
        }
    }
    
    func reloadCell(dicObj: NSDictionary) {
        if ifButtonCLicked
        {
            ifButtonCLicked=false
        }
        else
        {
            ifButtonCLicked=true
        }
       
        indexPth = dicObj["index"] as? IndexPath ?? IndexPath.init()
        numberOfLines = Int(dicObj["lblSize"] as? String ?? "1")!
        
        tblMain.beginUpdates()

        tblMain.reloadRows(at: [dicObj["index"] as? IndexPath ?? IndexPath.init()], with: .none)
        
        tblMain.endUpdates()
        
    }
    
    func showPostView(dicObj: NSDictionary) {
        
         indexPth = dicObj["index"] as? IndexPath ?? IndexPath.init()
         PostViewHidden = dicObj["viewStatus"] as? Bool ?? true
         
         tblMain.beginUpdates()

         tblMain.reloadRows(at: [dicObj["index"] as? IndexPath ?? IndexPath.init()], with: .none)
         
         tblMain.endUpdates()
    }
    
    func notifyForMainCellDimensionCHange(dicObj: NSDictionary) {
        tblMain.beginUpdates()

        tblMain.reloadRows(at: [dicObj["index"] as? IndexPath ?? IndexPath.init()], with: .none)
        
        tblMain.endUpdates()
    }
    
    
    
}
