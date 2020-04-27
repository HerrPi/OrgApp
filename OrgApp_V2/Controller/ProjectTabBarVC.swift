//
//  ProjectTabBarVC.swift
//  OrgApp_V2
//
//  Created by Jan Manuel Brenner on 25.04.20.
//  Copyright © 2020 Jan Manuel Brenner. All rights reserved.
//

import UIKit

class ProjectTabBarVC: UITabBarController {
	var projectsVC: ProjectsVC!
	var thisProject: Project!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = thisProject.name

        // Do any additional setup after loading the view.
    }


}
