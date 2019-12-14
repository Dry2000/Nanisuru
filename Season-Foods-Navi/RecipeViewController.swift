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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBOutlet weak var recipeimageview: UIImageView!
    
    @IBOutlet weak var recipematerial: UITableView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        recipematerial?.frame = view.bounds
        recipematerial?.rowHeight = view.frame.height/6
        recipematerial?.delegate = self
        recipematerial?.dataSource = self
        webView.frame = self.view.frame
        setRecipeTable()
    }
    func setRecipeTable(){
        if recipeInfo == nil{
            return
        }
        recipeimageview.frame = CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.width)
        print(recipename)
        recipeimageview.sd_setImage(with:URL(string: recipeInfo.foodImageUrl),placeholderImage: UIImage(named:"loading.png"))
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
        recipeimageview.frame = CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.width)
        recipeimageview.sd_setImage(with:URL(string: recipiInfo.picture),placeholderImage: UIImage(named:"loading.png"))
        recipeNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        recipeNameLabel.numberOfLines = 2
        recipeNameLabel.text = recipename
        recipeNameLabel.font = UIFont.systemFont(ofSize: 20.0)
        recipematerial.isUserInteractionEnabled = true
        recipematerial.allowsSelection = true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCustomCell", for: indexPath)as! RecipeCustomCell
        cell.materialName.text = "Loading..."
        cell.checkbox.setImage(UIImage(named:"check.png"), for: .normal)
        cell.syun.setImage(UIImage(named:"syun"), for: .normal)
        if recipeInfo.recipeMaterial.count == 0 {
            return cell
        }
        if indexPath.row == 0{
            check.removeAll()
            counter = 0
        }
        if indexPath.row > 0 && indexPath.row <= recipeInfo.recipeMaterial.count{
            cell.materialName.text = recipeInfo.recipeMaterial[indexPath.row-1]
        check.append(false)
       cell.checkbox.setImage(UIImage(named:"check.png"), for: .normal)
        cell.checkbox.tag = indexPath.row-1
        cell.checkbox.isUserInteractionEnabled = true
        cell.checkbox.addTarget(self, action: #selector(checked(_ :)), for: .touchUpInside)
            
        }else if indexPath.row == 0{
            cell.materialName?.text = "制作時間:\(recipeInfo.recipeIndication)\n材料一覧(タップして詳細を確認)"
            cell.syun.isHidden = true
            cell.checkbox.isHidden = true
            cell.syun.isEnabled = false
            cell.checkbox.isEnabled = false
            cell.selectionStyle = .none
        }else if indexPath.row == recipeInfo.recipeMaterial.count+1{
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
        }
        /*if indexPath.row > recipeInfo.recipeMaterial.count||indexPath.row == 0{
            return
        }

        tapped_row = indexPath.row-1
        performSegue(withIdentifier: "toFoodInfo", sender: nil)*/
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFoodInfo" {
            var next = 1
            let nextView = segue.destination as! FoodInfoViewController
            nextView.foodName = recipeInfo.recipeMaterial[tapped_row]
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/15
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recipeInfo.recipeMaterial == nil{ return 1}
      return recipeInfo.recipeMaterial.count+3
    }
    @objc func checked(_ sender: UIButton) {
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
    @IBOutlet weak var syun: UIButton!
}
