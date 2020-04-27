//
//  NoteTCC.swift
//  OrgApp_V2
//
//  Created by Jan Manuel Brenner on 20.04.20.
//  Copyright © 2020 Jan Manuel Brenner. All rights reserved.
//

import UIKit

class NoteTCC: UITableViewCell {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contentPreviewLabel: UILabel!
	@IBOutlet weak var textContainer: UIView!
	
	var thisNote: Note!
	
    override func awakeFromNib() {
        super.awakeFromNib()
//		titleLabel.text = thisNote.title
//		contentPreviewLabel.text = thisNote.content
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
