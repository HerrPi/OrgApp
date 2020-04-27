//
//  ProjectHeaderCHC.swift
//  OrgApp_V2
//
//  Created by Jan Manuel Brenner on 20.04.20.
//  Copyright © 2020 Jan Manuel Brenner. All rights reserved.
//

import UIKit

class ProjectHeaderCHC: UICollectionReusableView {
	@IBOutlet weak var headerLabel: UILabel!
	@IBOutlet weak var deleteCategory: UIButton!

	var thisCategory: Category!
	var projectsVC: ProjectsVC!

    override func awakeFromNib() {
        super.awakeFromNib()
		deleteCategory.isHidden = true
        // Initialization code
    }

	@IBAction func deleteCategory(_ sender: UIButton) {
		if thisCategory.projects.count == 0 {
			RealmFuncs.Edit.deleteObject(thisCategory)

			if projectsVC.allCategorys.count == 0 {
				projectsVC.changeEditMode(to: false)
			}
			projectsVC.projectsCollectionView.reloadData()
		}
	}

    
}
