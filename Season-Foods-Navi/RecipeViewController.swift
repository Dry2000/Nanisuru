//
//  RecipeViewController.swift
//  Season-Foods-Navi
//
//  Created by 洞井僚太 on 2019/08/27.
//  Copyright © 2019 洞井僚太. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import CoreLocation
import WebKit
import Hydra
var check:[Bool] = []
var tapped_row = 0
class RecipeViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    let webView = WKWebView()
    var recipename = ""
    var recipeScrollView:UIScrollView!
    var recipeInfo:rakuten!
    var recipiInfo:recipi!
    var foods:foods!
    var foodInfo:Recipe!
    var foodsInfo:[Recipe] = []
    var foodsServer:String!
    var names:[String] = []
    var counter = 0
    let dummy = """
{"food_info":{"id":0,"name":"あおとうがらし","base_food":null,"picture":null,"months":"","pref_id":0,"post":0},"prices":{},"nutritional":null}
"""/*"""
{"food_info":{"id":12,"name":"かぼちゃ","base_food":null,"picture":https://img.hachimenroppi.com/image.php?f=CZB5ApsB&adir=topic&id=100,"months":"7,8,9,10,11,12","pref_id":0,"post":0},"prices":{"長崎県":{"HighPrice":["350","-","-","-","-","-","280","-"],"MediumPrice":["350","-","-","-","-","-","200","-"]},"ﾒｷｼｺ合衆国":{"HighPrice":["180","-","-","-","-","-","-","-"],"MediumPrice":["130","-","-","-","-","-","-","-"]},"ﾆｭｰｼﾞｰﾗﾝﾄﾞ":{"HighPrice":["-","140","160","120","160","-","-","-"],"MediumPrice":["-","-","100","110","140","-","-","-"]},"福井県":{"HighPrice":["-","-","-","-","-","-","-","220"],"MediumPrice":["-","-","-","-","-","-","-","220"]}},"nutritional":{"food":"種実類/かぼちゃ/いり、味付け","info":[{"name":"エネルギー","value":"575","unit":"kcal"},{"name":"たんぱく質","value":"26.5","unit":"g"},{"name":"脂質","value":"51.8","unit":"g"},{"name":"炭水化物","value":"12.0","unit":"g"},{"name":"ナトリウム","value":"47","unit":"mg"},{"name":"カリウム","value":"840","unit":"mg"},{"name":"カルシウム","value":"44","unit":"mg"},{"name":"マグネシウム","value":"530","unit":"mg"},{"name":"コレステロール","value":"","unit":"mg"},{"name":"食塩相当量","value":"0.1","unit":"g"}]}}
 """:*/
//    @IBOutlet weak var howtomake: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBOutlet weak var recipeimageview: UIImageView!
    
    @IBOutlet weak var recipematerial: UITableView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  print(recipeInfo)
      //  recipeScrollView = UIScrollView()
      /*  recipeScrollView.bounces = false
        recipeScrollView.contentSize = CGSize(width:self.view.frame.width,height:self.view.frame.height)
        recipeScrollView.center = self.view.center
        recipeScrollView.frame = CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.height)
        recipeScrollView.indicatorStyle = .default
        recipeScrollView.delegate = self*/
    //    self.view.addSubview(recipeScrollView)
        recipematerial?.frame = view.bounds
        recipematerial?.rowHeight = view.frame.height/6
        recipematerial?.delegate = self
        recipematerial?.dataSource = self
  //      howtomake?.delegate = self
  //      howtomake?.dataSource = self
        
        webView.frame = self.view.frame
      //  setRecipeView()
        setRecipeTable()
     //   recipematerial.reloadData()
       // webView.navigationDelegate = self as! WKNavigationDelegate
        //webView.uiDelegate = self as! WKUIDelegate
    }
    func setRecipeTable(){
     /*   if recipiInfo == nil{return}
        for i in 0..<recipiInfo.foods.count{
            if let data = dummy.data(using:.utf8){
                let decoder:JSONDecoder = JSONDecoder()
                do{
                    self.foodInfo = try decoder.decode(Recipe.self,from:data)
                    self.foodsInfo.append(self.foodInfo)
                }catch{
                    print("JSONconvertfailed",error)
                }
                //  let dummydata = dummy.data(using: .utf8
            }
        }
        for i in 0..<recipiInfo.foods.count{
          /*  dispatchGroup.enter()
            dispatchQueue.async(group:dispatchGroup,
                                [weak, self], in
                self?.asyncProcess(number :i){
                
            }*/
          /*  if recipiInfo.foods[i].id == 0{
                names.append(recipiInfo.foods[i].name)
                print(names)
            }*/
        }
        //print("count",recipiInfo.foods.count)
        for i in 0..<recipiInfo.foods.count{
            if self.recipiInfo.foods[i].id == 0{
               /* if let data = dummy.data(using:.utf8){
                let decoder:JSONDecoder = JSONDecoder()
                    do{
                        self.foodInfo = try decoder.decode(Recipe.self,from:data)
                        self.foodsInfo.append(self.foodInfo)
                    }catch{
                        print("JSONconvertfailed",error)
                    }
              //  let dummydata = dummy.data(using: .utf8
                }*/
                foodsInfo[i].foodInfo.name = recipiInfo.foods[i].name
               // self.foodsServer = "http://t3.intern.jigd.info/api/v1/food/1"
                self.recipematerial.reloadData()
                continue
            }else{
             //   print(recipiInfo.foods[i].id)
                self.foodsServer = "http://t3.intern.jigd.info/api/v1/food/\(recipiInfo.foods[i].id)"
                //self.foodsServer = "http://localhost:3000/api/v1/food/\(recipiInfo.foods[i].id)"
               // Promise<Any>{resolve,reject,foodInfo   in
              //  async(in: .main, token:nil){_ in
                    Alamofire.request(self.foodsServer,method: .get).responseString{response in
                        switch response.result{
                        case .success:
                            /* print("result",response)
                             guard let json = response.data else{return}*/
                            //if let data = json.data(using:.utf8){
                            let decoder:JSONDecoder = JSONDecoder()
                            do{
                                self.foodInfo = try decoder.decode(Recipe.self,from:response.data!)
                                self.foodsInfo[i] = self.foodInfo//self.foodsInfo.append(self.foodInfo)
                                //DispatchQueue
                                // print(self.foodsInfo)
                                
                            }catch{
                                print(response)
                                print("JSON convert failed",error.localizedDescription)
                            }
                            break
                        case .failure(let ERROR):
                            print(ERROR)
                            break
                        }
                        self.recipeNameLabel.text = self.recipename
                        print(self.foodsInfo)
                        self.recipematerial.reloadData()
                    }
                //    }.then{ _ in
                  //      print("OK")
                //}
                    
                  /*  }.then{ result in
                    print(result)
                }.catch{ error in
                    print(error)
                }*/
        }
    }
        // print(self.foodsInfo)*/
        if recipeInfo == nil{
            return
        }
        //    recipeimageview = UIImageView()
        // var image = UIImage()
        recipeimageview.frame = CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.width)
        print(recipename)
        recipeimageview.sd_setImage(with:URL(string: recipeInfo.foodImageUrl),placeholderImage: UIImage(named:"loading.png"))
        // recipeScrollView.addSubview(recipeimageview)
        //     var recipeNameLabel = UILabel()
        //   recipeNameLabel.frame =  CGRect(x:0,y:recipeimageview.frame.maxY,width:self.view.frame.width,height:20)
        recipeNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        recipeNameLabel.numberOfLines = 2
        recipeNameLabel.text = recipename
        recipeNameLabel.font = UIFont.systemFont(ofSize: 20.0)
        recipematerial.isUserInteractionEnabled = true
        recipematerial.allowsSelection = true
    }
    func setRecipeView(){
        if recipiInfo == nil{
            return
        }
    //    recipeimageview = UIImageView()
       // var image = UIImage()
        recipeimageview.frame = CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.width)
    //  print(recipename)
      //  print(recipeInfo)
//        recipeimageview.sd_setImage(with:URL(string: recipiInfo.picture),placeholderImage: UIImage(named:"loading.png"))
        recipeimageview.sd_setImage(with:URL(string: recipiInfo.picture),placeholderImage: UIImage(named:"loading.png"))
       // recipeScrollView.addSubview(recipeimageview)
   //     var recipeNameLabel = UILabel()
     //   recipeNameLabel.frame =  CGRect(x:0,y:recipeimageview.frame.maxY,width:self.view.frame.width,height:20)
        recipeNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        recipeNameLabel.numberOfLines = 2
        recipeNameLabel.text = recipename
        recipeNameLabel.font = UIFont.systemFont(ofSize: 20.0)
        recipematerial.isUserInteractionEnabled = true
        recipematerial.allowsSelection = true
  //      recipematerial.tag = 1
  //      howtomake.tag = 2
        //recipeScrollView.addSubview(recipeNameLabel)
        // material_table = UITableView()
        //material_table.frame = CGRect(x:,y:,width:view.,height:)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  print(recipeInfo)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCustomCell", for: indexPath)as! RecipeCustomCell
        cell.materialName.text = "Loading..."
        cell.checkbox.setImage(UIImage(named:"check.png"), for: .normal)
        cell.syun.setImage(UIImage(named:"syun"), for: .normal)
     //   cell.syun.isHidden = true
     //   cell.checkbox.isHidden = true
        if recipeInfo.recipeMaterial.count == 0 {
            return cell
        }
      //  print(recipeInfo.recipeMaterial.count)
        if indexPath.row == 0{
            check.removeAll()
            counter = 0
        }
        if indexPath.row > 0 && indexPath.row <= recipeInfo.recipeMaterial.count{
          /*  if foodsInfo[indexPath.row-1].foodInfo.id == 1 && counter < names.count{
                print(counter)
                print(names[counter])
                cell.materialName.text = names[counter]
                counter += 1
                
                //names.remove(at:0)
            }else{
                cell.materialName.text = recipiInfo.foods[indexPath.row-1].name//foodsInfo[indexPath.row-1].foodInfo.name
            }*///recipeInfo.recipeMaterial[indexPath.row-1]//
       // var image = UIImage(named:"check.png")
     //   image?.scaleImage(scaleSize:image!.size.width/CGFloat(self.view.frame.width/12))
            cell.materialName.text = recipeInfo.recipeMaterial[indexPath.row-1]
        check.append(false)
     //   print(recipeInfo.recipeMaterial[indexPath.row-1])
     //   print(check)
        cell.checkbox.setImage(UIImage(named:"check.png"), for: .normal)
        cell.checkbox.tag = indexPath.row-1
        cell.checkbox.isUserInteractionEnabled = true
        cell.checkbox.addTarget(self, action: #selector(checked(_ :)), for: .touchUpInside)
        //cell.syun.image = UIImage(named:"syun")
            /*  cell.syun.setImage(UIImage(named:"syun"), for: .normal)
        cell.syun.setTitleColor(.red, for: .normal)
            cell.checkbox.isHidden = false
            cell.syun.isHidden = true
            cell.checkbox.isEnabled = true
            cell.syun.isEnabled = true
            if recipiInfo.foods[indexPath.row-1].syun != nil && recipiInfo.foods[indexPath.row-1].syun /*&& recipiInfo.foods[indexPath.row-1].id != 0*/{
                cell.syun.isHidden = false
                cell.syun.isEnabled = true
            }*/
          /* if foodsInfo[indexPath.row-1].foodInfo.months != "" && foodsInfo[indexPath.row-1].foodInfo.id != 1{
                
        let months = foodsInfo[indexPath.row-1].foodInfo.months.components(separatedBy:  ",")
        let dat = Date()
        let calend = Calendar.current
        let mont = calend.component(.month, from: dat)
            for i in 0..<months.count{
                if months[i] == "\(mont)"{
             
                    print("yes")
                }
            }
            }*/
     //   checked(cell.checkbox)
        //cell.materialName.isUserInteractionEnabled = false
        }else if indexPath.row == 0{
            //cell.materialName.text = "Loading..."
            cell.materialName?.text = "制作時間:\(recipeInfo.recipeIndication)\n材料一覧(タップして詳細を確認)"
            cell.syun.isHidden = true
            cell.checkbox.isHidden = true
            cell.syun.isEnabled = false
            cell.checkbox.isEnabled = false
            cell.selectionStyle = .none
            //return cell
        }else if indexPath.row == recipeInfo.recipeMaterial.count+1{//recipeInfo.recipeMaterial.count+1{//
            cell.materialName?.text = "作り方"
            cell.syun.isHidden = true
            cell.checkbox.isHidden = true
            cell.syun.isEnabled = false
            cell.checkbox.isEnabled = false
            cell.selectionStyle = .none
        }else if indexPath.row == recipeInfo.recipeMaterial.count+2{
            cell.materialName?.text = "ここをタップすると詳細なレシピのベージにジャンプします"
          //   cell.materialName?.text = recipeInfo.howto
            cell.syun.isHidden = true
            cell.checkbox.isHidden = true
            cell.syun.isEnabled = false
            cell.checkbox.isEnabled = false
            cell.materialName?.numberOfLines = 10
            cell.selectionStyle = .none
        }
        cell.syun.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == recipeInfo.recipeMaterial.count+2 {
            let targetUrl = recipeInfo.recipeUrl
            let urlRequest = URLRequest(url:URL(string:targetUrl)!)
            webView.load(urlRequest)
            self.view.addSubview(webView)
         //   performSegue(withIdentifier: "toWebView", sender: nil)
        }
        if indexPath.row > recipeInfo.recipeMaterial.count||indexPath.row == 0{
            return
        }

        tapped_row = indexPath.row-1
         //print("\(indexPath.row)番目の行が選択されました。\(recipiInfo.foods[tapped_row].name)\(foodsInfo[tapped_row].foodInfo.id)")
        performSegue(withIdentifier: "toFoodInfo", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFoodInfo" {
            //  let nc = segue.destination as! UINavigationController
            var next = 1
            let nextView = segue.destination as! FoodInfoViewController
          /*  let id = foodsInfo[tapped_row].foodInfo.id
            for i in 0..<foodsInfo.count{
                print(foodsInfo[i].foodInfo.id,id)
                if foodsInfo[i].foodInfo.id == id{
                    next = i
                    print(next)
                    break
                }
            }*/
          //  nextView.food_info = foodsInfo[next]
         //   nextView.foodName = recipiInfo.foods[tapped_row].name
            //print(rakutenResults[0].result[tapped_path])
            nextView.foodName = recipeInfo.recipeMaterial[tapped_row]
   //         nextView.foodid = 
         //    nextView.foodInfo =
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/15
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recipeInfo.recipeMaterial == nil{ return 1}
       //print(recipeInfo.recipeMaterial.count)
   /*    if !recipiInfo.post{
            return recipiInfo.foods.count+3
        }*/
        
        return recipeInfo.recipeMaterial.count+3
    //return recipeInfo.recipeMaterial.count+10
        
            
    }
    @objc func checked(_ sender: UIButton) {
//        print("tapped!!")
//        print(check)
        check[sender.tag] = !check[sender.tag]
        if check[sender.tag]{
            sender.setBackgroundImage(UIImage(named:"checked.png"), for: .normal)
        }else{
            sender.setBackgroundImage(UIImage(named:"check.png"), for: .normal)
        }
    }
    class MyScrollView: UIScrollView {
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            superview?.touchesBegan(touches, with: event)
        }
        
    }

}
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
}
extension ViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        
        return nil
    }
    
}
class RecipeCustomCell:UITableViewCell{
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var materialName: UILabel!
    
   // @IBOutlet weak var syun: UIImageView!
    
    @IBOutlet weak var syun: UIButton!
}
