//
//  PublicacionWebService.swift
//  WebServices in iOS
//
//  Created by Admin on 3/28/17.
//  Copyright © 2017 Jorge Luis Limo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PublicacionWebService: NSObject {
    
    
    static  func listarTodo(completion: @escaping (_ result: Array<publicacion>) -> Void) {
        
        var resultado = Array<publicacion>()
    
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/")
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding.httpBody , headers: nil).responseJSON { (response) in
            let json = JSON(response.result.value)
        
            for i in 0...json.count {
                
                let publi =  publicacion()
                publi.titulo = json[i]["title"].string
                publi.contenido = json[i]["body"].string
                resultado.append(publi)
                
                
            }
            
            completion(resultado)
            
        }
        
        
    }

}
