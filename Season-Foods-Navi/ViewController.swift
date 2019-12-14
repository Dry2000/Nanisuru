//
//  ViewController.swift
//  Season-Foods-Navi
//
//  Created by 洞井僚太 on 2019/08/22.
//  Copyright © 2019 洞井僚太. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import CoreLocation
import WebKit

var menujson:JSON!
var results:[recipilist]=[]
var locationmaneger:CLLocationManager!
var rakutenResults:[rakutenResult]=[]
var tapped_path:Int!
var id = 10
var timer:Timer?
class ViewController: UIViewController,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate{
    
    // let CELLID = "menu"
    // var statusBarHidden = true
    @IBOutlet var menucollection: UICollectionView!
    let SERVER:String! = "http://t3.intern.jigd.info/api/v1/menu"
    //    let SERVER:String! = "http://localhost:3000/api/v1/menu"
    //
    var datas:recipilist?
    //var food_datas:foodlsit?
    // var users:Users?
    var menutable:UITableView!
    override func viewWillAppear(_ animated: Bool) {
        //   menucollection.frame = CGRect(x:0,y:100,width:self.view.frame.width,height:self.view.frame.height)
        super.viewWillAppear(animated)
        //     self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // let textView = UITextView()
        // textView.text = "https://www.google.com"
        
        self.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.tintColor = .gray
        self.automaticallyAdjustsScrollViewInsets = false
        let LAYOUT = UICollectionViewFlowLayout()
        LAYOUT.minimumLineSpacing = 0
        LAYOUT.itemSize = CGSize(width:self.view.frame.width/2-CGFloat(5),height:self.view.frame.height/3)
        //  LAYOUT.minimumInteritemSpacing = 0.1
        //  self.menucollection.dataSource = nil
        self.menucollection.collectionViewLayout = LAYOUT
        self.menucollection.delegate = self
        self.menucollection.dataSource = self
        /*     if let data = myjson.data(using:.utf8){
         let decoder:JSONDecoder = JSONDecoder()
         do{
         let result:recipilist = try decoder.decode(recipilist.self,from:data)
         //   print(result,result.recipilist[0].id)
         results.append(result)
         }catch{
         print("JSON convert failed",error.localizedDescription)
         }
         }*/
        //  print(results)
        /*switch response.result{
         case .success:
         print("result",response.data)
         self.menujson = JSON(response.result.value ?? kill)
         break
         case .failure(let ERROR):
         print(ERROR)
         break
         }
         }*/
        /*    if let data = rakutenDummyjson.data(using: .utf8){
         // var str = String(data: rakutenDummyjson, encoding: .utf8)!
         //  let encoder:JSONEncoder = JSONEncoder()
         let decoder:JSONDecoder = JSONDecoder()
         do{
         let result:rakutenResult = try decoder.decode(rakutenResult.self,from:data)
         print(result)
         rakutenResults.append(result)
         //  print("temp",results)
         }catch{
         print("JSON convert failed",error.localizedDescription)
         }
         }
         */
        // view.addSubview(menucollection)
        Setuplocationmanager()
       // getArticle()
        timer = Timer.scheduledTimer(withTimeInterval:2,repeats:true,block:{_ in self.searchCategoryRanking()})
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // print("\(indexPath.row)番目の画像が選択されました。")
        // print(results[0].recipilist[indexPath.row].name)
        tapped_path = indexPath.row
        let nextvc = RecipeViewController()
        let next = self.storyboard!.instantiateViewController(withIdentifier: "recipeview") as? RecipeViewController
        //   next?.recipename = rakutenResults[0].result[indexPath.row].recipeTitle
        nextvc.view.backgroundColor = UIColor.blue
        print(indexPath.row)
        performSegue(withIdentifier: "toRecipe", sender: nil)
        // self.navigationController?.pushViewController(nextvc, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipe" {
            //  let nc = segue.destination as! UINavigationController
            let nextView = segue.destination as! RecipeViewController
            //print(rakutenResults[0].result[tapped_path])
            
            
         //   nextView.recipename = results[0].result[tapped_path].name
          //  nextView.recipiInfo = results[0].result[tapped_path]
            
             nextView.recipename = rakutenResults[0].result[tapped_path].recipeTitle
              nextView.recipeInfo = rakutenResults[0].result[tapped_path]
        }
    }
    func Setuplocationmanager(){
        locationmaneger = CLLocationManager()
        locationmaneger.requestWhenInUseAuthorization()
        var status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.notDetermined || status == CLAuthorizationStatus.denied{
            locationmaneger.requestWhenInUseAuthorization()
            status = CLLocationManager.authorizationStatus()
        }else if status == CLAuthorizationStatus.authorizedWhenInUse{
            locationmaneger.delegate = self
            locationmaneger.distanceFilter = 10
            locationmaneger.startUpdatingLocation()
        }
        //  print(status)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude:Double = Double((location?.coordinate.latitude)!)
        let longitude:Double = Double((location?.coordinate.longitude)!)
        let locate :[String:Double] = ["lat": latitude,"long": longitude]
           print("latitude: \(latitude)\nlongitude: \(longitude)")
        let encoder:JSONEncoder = JSONEncoder()
        let urlstring = "http://t3.intern.jigd.info/api/v1/menu"
        //  let parameter = try? encoder.encode(locate)
 /*       Alamofire.request(urlstring,method: .get,parameters: locate).responseString{response in
            switch response.result{
            case .success:
                print("YEAAAA",response)
                /* print("result",response)
                 menujson = JSON(response.result.value ?? kill)
                 guard let json = response.data else{return}*/
                if let data = myjson.data(using:.utf8){
                    let decoder:JSONDecoder = JSONDecoder()
                    do{
                        let result:recipilist = try decoder.decode(recipilist.self,from:response.data!)
                        //  print(result)
                        results.append(result)
                        //  print("temp",results)
                    }catch{
                        print("JSON convert failed",error.localizedDescription)
                    }
                }
                break
            case .failure(let ERROR):
                print(ERROR)
                break
            }
        }
            let LAYOUT = UICollectionViewFlowLayout()
            LAYOUT.minimumLineSpacing = 0
            LAYOUT.itemSize = CGSize(width:self.view.frame.width/2-CGFloat(5),height:self.view.frame.height/3)
            //  LAYOUT.minimumInteritemSpacing = 0.1
            //  self.menucollection.dataSource = nil
            self.menucollection.collectionViewLayout = LAYOUT
            //  self.menucollection.dataSource = self
            self.menucollection.reloadData()
           locationmaneger.stopUpdatingLocation()*/
    }
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // print(results.count)
        if rakutenResults.count == 0 {
            return 6
        }
        return rakutenResults[0].result.count//results[0].result.count//
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if rakutenResults.count == 0{
            // print("first")
            let LAYOUT = UICollectionViewFlowLayout()
            LAYOUT.minimumLineSpacing = 0
            LAYOUT.itemSize = CGSize(width:self.view.frame.width/2,height:self.view.frame.height)
            LAYOUT.minimumInteritemSpacing = 0.1
            //self.menucollection.dataSource = nil
         //           self.menucollection.collectionViewLayout = LAYOUT
            //   self.menucollection.dataSource = self
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath)as! LoadingCell
            cell.backgroundColor = .white
            cell.loading.frame = CGRect(x:0,y:0,width:cell.frame.width,height:cell.frame.height)
            cell.loading.startAnimating()
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCustomCell", for: indexPath)as! MyCustomCell
        //     print("second")
        cell.backgroundColor = .white
        cell.imageview = UIImageView(frame:cell.frame)
        //  print(indexPath.row)
        var imagepath = rakutenResults[0].result[indexPath.row].foodImageUrl//results[0].result[indexPath.row].picture//
        
        
        var imageurl:String!
        /*if imagepath.hasPrefix("h"){
            if results[0].result[indexPath.row].picture.isEmpty{
                cell.imageview.image = UIImage(named:"notfound.png")
            }else{
                imageurl = "\(imagepath)"
                cell.imageview.sd_setImage(with: URL(string:imageurl), placeholderImage:UIImage(named:"loading.png"))
            }
        }else{
            imagepath.removeFirst()
            imageurl = "http://t3.intern.jigd.info/\(imagepath)"
        }*/
        
        //print(imageurl)
        imageurl = "\(imagepath)"
        cell.imageview.sd_setImage(with: URL(string:imageurl), placeholderImage:UIImage(named:"loading.png"))
        cell.needminute.text = rakutenResults[0].result[indexPath.row].recipeIndication//results[0].result[indexPath.row].time//
        cell.needminute.font = UIFont.systemFont(ofSize: 20)
        /*     let LAYOUT = UICollectionViewFlowLayout()
         LAYOUT.minimumLineSpacing = 0
         LAYOUT.itemSize = CGSize(width:self.view.frame.width/2-CGFloat(5),height:self.view.frame.height/3)
         //  LAYOUT.minimumInteritemSpacing = 0.1
         //  self.menucollection.dataSource = nil
         self.menucollection.collectionViewLayout = LAYOUT*/
        //print(cell.needminute.text)
        //print(cell.needminute.text)
        collectionView.addSubview(cell.imageview)
        // if indexPath.row == 3{
        // collectionView.addSubview(cell.needminute)
        //}
        
        self.view.bringSubviewToFront(cell.needminute)
        // self.view.sendSubviewToBack(cell.imageview)
        //self.view.sendSubviewToBack(collectionView)
        // self.view.bringSubviewToFront(cell.imageview)
        //
        //print(cell.needminute.frame)
        
        return cell
    }
}
extension ViewController{
    func getArticle(){
        Alamofire.request(SERVER,method: .get).responseString{response in
            switch response.result{
            case .success:
               // print("YEAAAA",response)
                /* print("result",response)
                 menujson = JSON(response.result.value ?? kill)
                 guard let json = response.data else{return}*/
                if let data = myjson.data(using:.utf8){
                    let decoder:JSONDecoder = JSONDecoder()
                    do{
                        let result:recipilist = try decoder.decode(recipilist.self,from:response.data!)
                        //  print(result)
                        results.append(result)
                        //print("temp",results)
                    }catch{
                        print("JSON convert failed",error.localizedDescription)
                    }
                }
                break
            case .failure(let ERROR):
                print(ERROR)
                break
            }
            let LAYOUT = UICollectionViewFlowLayout()
            LAYOUT.minimumLineSpacing = 0
            LAYOUT.itemSize = CGSize(width:self.view.frame.width/2-CGFloat(5),height:self.view.frame.height/3)
            //  LAYOUT.minimumInteritemSpacing = 0.1
          //    self.menucollection.dataSource = nil
            self.menucollection.collectionViewLayout = LAYOUT
           //  self.menucollection.dataSource = self
            self.menucollection.reloadData()
        }
    }
       func searchCategoryRanking(){
        let apiKey = Key();
     var today = "\(Date())"
     today = today.replacingOccurrences(of:"-", with:"")
     today = String(today.prefix(8))
     //     print(today)
        
        var rakutenurl = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?applicationId=\(apiKey.key!)&categoryType=large&categoryId=\(id)"
     Alamofire.request(rakutenurl,method: .get).responseString{response in
     switch response.result{
     case .success:
          //print("result",response)
     //  menujson = JSON(response.result.value ?? kill)
     guard let json = response.data else{return}
     if let data = myjson.data(using: .utf8){
     let decoder:JSONDecoder = JSONDecoder()
     do{
     let result:rakutenResult = try decoder.decode(rakutenResult.self,from:json)
     //         print(result)
     rakutenResults.append(result)
     //  print("temp",results)
     }catch{
     print("JSON convert failed",error.localizedDescription)
     }
     }
     break
     case .failure(let ERROR):
     print(ERROR)
     break
     }
        
     //     print(rakutenDummyjson)
        id += 1
        if id > 20{
            timer?.invalidate()
            self.menucollection.reloadData()
        }
     }
     }
     override var prefersStatusBarHidden: Bool {
     return false
     }
}
class MyCustomCell:UICollectionViewCell{
    @IBOutlet var imageview: UIImageView!
    @IBOutlet weak var needminute: UILabel!
    //  @IBOutlet weak var needminute: UILabel!
    var image:UIImage!
    
}
class LoadingCell:UICollectionViewCell{
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
}

