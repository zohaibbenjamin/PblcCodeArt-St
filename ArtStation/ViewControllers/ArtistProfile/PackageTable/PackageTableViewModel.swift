//
//  PackageTableViewModel.swift
//  ArtStation
//
//  Created by MamooN_ on 6/15/21.
//

import Foundation

class PackageTableCellViewModel{
    
    var tableData : Package?
    let rowId : Int
    
    init(cellData : Package?,rowId : Int){
        tableData = cellData
        self.rowId = rowId
    }
    
}
