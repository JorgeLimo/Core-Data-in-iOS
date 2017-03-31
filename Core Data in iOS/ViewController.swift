//
//  ViewController.swift
//  Core Data in iOS
//
//  Created by Admin on 3/30/17.
//  Copyright © 2017 Jorge Luis Limo. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData
import ReachabilitySwift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tvpublicaciones: UITableView!
    
    
    var publicaciones = Array<publicacion>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listarCoreData()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicaciones.count
    }
    
    func deleteCoreData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "PublicacionCore")

        do{
            
            let resultado = try context.fetch(fetchRequest)
            
            for item in resultado{
                context.delete(item)
            }

            try context.save()
        
        }catch let error as NSError{
            print(error.userInfo)
        }
        
        
        
    }
    
    func listarCoreData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "PublicacionCore")
        do{
            
          let resultado = try context.fetch(fetchRequest)
            for item in resultado {
                let publi = publicacion()

                publi.titulo = item.value(forKey: "titulo") as! String!
                publi.contenido = item.value(forKey: "contenido") as! String!
                
                self.publicaciones.append(publi)
                
            }
        }catch let error as NSError {
            print("Error al listar la data core : \(error.userInfo)")
        }
        
        
    }
    
    func registrarEnCoreData(listado : Array<publicacion>){
        
        for item in listado {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "PublicacionCore", in: context)
            
            let publicacion = NSManagedObject(entity: entity!, insertInto: context)
            
            publicacion.setValue(item.titulo , forKey: "titulo")
            publicacion.setValue(item.contenido , forKey: "contenido")
            
            do{
               try context.save()
            
            }catch let error as NSError {
                print("Error al grabar el contexto data core \(error.userInfo)" )
            }
                
            
        }
        
        
        
        
        
        
    }
    
    func obtenerPublicaciones(){
        
        
        let reachability = Reachability()
        
        if (reachability?.isReachableViaWiFi)! {
            print("es wifi")
        }
        
        if (reachability?.isReachableViaWWAN)! {
            print("es movil")
        }
        
        reachability?.whenReachable = { rechability in
        
        self.publicaciones.removeAll()
        let hub  = MBProgressHUD(view : self.view)
        hub.show(animated: true)
        hub.label.text = "Cargando..."
        
        
        self.view.addSubview(hub)
        
        PublicacionWebService.listarTodo { (jsonResultado) in
            
            self.deleteCoreData()
            
            self.registrarEnCoreData(listado: jsonResultado)
            
            //self.publicaciones = jsonResultado
            self.listarCoreData()

            
            self.tvpublicaciones.reloadData()
            hub.hide(animated: true)
            
        }
        
        /**for i in 1...8{
         
         let publi =  publicacion()
         publi.titulo = "publicacion \(i)"
         publi.contenido = "contenido \(i)"
         publicaciones.append(publi)
         }
         **/
            
        }

        
        reachability?.whenUnreachable = {reachability in
         
            var alertController:UIAlertController

            alertController = UIAlertController(title: "Aviso", message: "No hay internet disponible", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alertController,animated : true,completion:{})
        }
        
        do{
            try reachability?.startNotifier()
        }catch let error as NSError {
            print(error.userInfo)
        }
        
        reachability?.stopNotifier()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let publi = publicaciones[indexPath.row]
        
        self.performSegue(withIdentifier: "detalle", sender: publi)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier == "detalle"{
            
            //let detallecontroler = segue.destination as! DetalleViewController
            
            //detallecontroler.publi = sender as! publicacion
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! PublicacionCelda
        
        let indice = indexPath.row
        
        let publi = publicaciones[indice]
        
        cell.lbltitulo.text = publi.titulo
        cell.txtcontenido.text = publi.contenido
        
        return cell
    }
    
    @IBAction func cargarpublicaciones(_ sender: UIBarButtonItem) {
        self.obtenerPublicaciones()
    }
    
    
    
}
