//
//  QueMainCell.swift
//  ArtStation
//
//  Created by Apple on 25/06/2021.
//

import UIKit
protocol ProtocolReloadCellData {
    func reloadCell(dicObj:NSDictionary)
    func showPostView(dicObj:NSDictionary)
    func notifyForMainCellDimensionCHange(dicObj:NSDictionary)
}


class QueMainCell: UITableViewCell {

    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQue: UILabel!
    var delegateReload:ProtocolReloadCellData?
    var indexPath=IndexPath()
    
    @IBOutlet weak var viewPost: UIView!
    //sub section items
    @IBOutlet weak var tblSubComments: UITableView!
    
    
    var dataForComments = ["1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over? \n 3. What food have you never eaten but would really like to try? \n 4. What’s something you really resent paying for? \n 5. What would a world populated by clones of you be like? \n 6. Do you think that aliens exist? \n 7. What are you currently worried about? \n 8. Where are some unusual places you’ve been? \n 9. Where do you get your news? \n 10. What are some red flags to watch out for in daily life?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over? \n 3. What food have you never eaten but would really like to try? \n 4. What’s something you really resent paying for? \n 5. What would a world populated by clones of you be like? \n 6. Do you think that aliens exist? \n 7. What are you currently worried about? \n 8. Where are some unusual places you’ve been? \n 9. Where do you get your news? \n 10. What are some red flags to watch out for in daily life?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over? \n 3. What food have you never eaten but would really like to try?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over? \n 3. What food have you never eaten but would really like to try?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over? \n 3. What food have you never eaten but would really like to try? \n 4. What’s something you really resent paying for? \n 5. What would a world populated by clones of you be like? \n 6. Do you think that aliens exist?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over? \n 3. What food have you never eaten but would really like to try? \n 4. What’s something you really resent paying for? \n 5. What would a world populated by clones of you be like? \n 6. Do you think that aliens exist? \n 7. What are you currently worried about? \n 8. Where are some unusual places you’ve been? \n 9. Where do you get your news? \n 10. What are some red flags to watch out for in daily life?","1. What weird food combinations do you really enjoy? \n 2. What social stigma does society need to get over?","1. What weird food combinations do you really enjoy?"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCellNData()
    {
        tblSubComments.delegate=self
        tblSubComments.dataSource=self
        UIManager.makeShadow(view: viewShadow)
    }
    
    
    
    @IBAction func btnCLickQuestionExpansion(_ sender: Any)
    {
        debugPrint(lblQue.maxNumberOfLines)
        debugPrint(lblQue.numberOfVisibleLines)
        
        
        if lblQue.maxNumberOfLines == (lblQue.numberOfVisibleLines-1)
        {
            delegateReload?.reloadCell(dicObj: ["lblSize":lblQue.maxNumberOfLines.description,"index":indexPath])
        }
        else if lblQue.maxNumberOfLines > (lblQue.numberOfVisibleLines-1)
        {
            delegateReload?.reloadCell(dicObj: ["lblSize":lblQue.maxNumberOfLines.description,"index":indexPath])
            
        }
        else
        {
            delegateReload?.reloadCell(dicObj: ["lblSize":lblQue.maxNumberOfLines.description,"index":indexPath])
        }
    }
    
    @IBAction func btnAddCommentCLick(_ sender: Any)
    {
        if viewPost.isHidden==true
        {
            viewPost.isHidden=false
        }
        else
        {
            viewPost.isHidden=true
        }
        delegateReload?.showPostView(dicObj: ["viewStatus":viewPost.isHidden,"index":indexPath])
    }
    var numb = 0
    
    @IBAction func btnShowCommentsClick(_ sender: Any)
    {
        if tblSubComments.isHidden==true
        {
            numb = 4
            tblSubComments.isHidden=false
            tblSubComments.reloadData()
            delegateReload?.showPostView(dicObj: ["hide":tblSubComments.isHidden,"index":indexPath])
            
        }
        else
        {
            numb = 0
            tblSubComments.isHidden=true
            tblSubComments.reloadData()
            delegateReload?.showPostView(dicObj: ["hide":tblSubComments.isHidden,"index":indexPath])
    
        }
        
        
       
        
    }
    
    
    
    
}


extension QueMainCell:UITableViewDataSource,UITableViewDelegate,ProtocolShowLessComent
{
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return numb
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
           let cell = tableView.dequeueReusableCell(withIdentifier: "ShowLessMoreTableViewCell") as! ShowLessMoreTableViewCell
            cell.delegateHideComent=self
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubComentCell") as! SubComentCell
            return cell
        }
    }
    
    func hideAllComments() {
      numb = 0
        tblSubComments.reloadData()
        tblSubComments.isHidden=true
        
    }
    
    
    
}
