//
//  PublicacionCelda.swift
//  WebServices in iOS
//
//  Created by Alumno on 23/03/17.
//  Copyright © 2017 Jorge Luis Limo. All rights reserved.
//

import UIKit

class PublicacionCelda: UITableViewCell {
    
    
    @IBOutlet weak var lbltitulo: UILabel!
    
    @IBOutlet weak var txtcontenido: UITextView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
