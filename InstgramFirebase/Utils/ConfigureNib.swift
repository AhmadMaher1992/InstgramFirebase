//
//  ConfigureNib.swift
//  InstgramFirebase
//
//  Created by Ahmad Eisa on 24/12/2020.
//  Copyright © 2020 Ahmad Eisa. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func configureNibs(nibName: String, identifier: String) {
        let cellNib = UINib(nibName: nibName, bundle: nil)
        
        register(cellNib, forCellWithReuseIdentifier: identifier)
        reloadData()
    }
}




extension UITableView {
    
    func configureNibs(nibName: String, identifier: String) {
        let cellNib = UINib(nibName: nibName, bundle: nil)
        
        register(cellNib, forCellReuseIdentifier: identifier)
        //reloadData()
    }
}
