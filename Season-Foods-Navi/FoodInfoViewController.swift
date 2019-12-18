//
//  FoodInfoViewController.swift
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
import Charts
import WebKit
let needs = [2650.0,60.0,20.0,250.0,3149.0,2500.0,650.0,340.0,0.0,7.0]
class FoodInfoViewController:UIViewController,UIScrollViewDelegate, WKNavigationDelegate,WKUIDelegate{
 //   var scrollView:UIScrollView!
    var lineDataSet: LineChartDataSet!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var graphView: LineChartView!
   // var barView: LineChartView!
    var foodName = "食材"
    @IBOutlet weak var eiyouTableView: UITableView!
    @IBOutlet weak var foodNameLabel: UILabel!
    //var foodInfo:food_info!
    var food_info:Recipe!
    var webView = WKWebView()
    //let foodInfoSERVER = "storings"
    var foodid = 1
    var foodvalues:[String] = []
    var targetUrl = "食材"
    var keyname:[String] = []
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
   
      //  print(foodInfo)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       /* eiyouTableView.delegate = self
        eiyouTableView.dataSource = self*/
       /* if food_info.prices.count != 0{
            setchart()
        }
        foodImageView.sd_setImage(with: URL(string:"\(food_info.foodInfo.picture)"), placeholderImage:UIImage(named:"loading.png"))
        foodNameLabel!.text = "\(foodName) \nグラフの価格が0である箇所はデータがありません"
        if food_info.foodInfo.picture != nil{
            print()
            foodImageView.sd_setImage(with: URL(string:"\(food_info.foodInfo.picture)"), placeholderImage:UIImage(named:"loading.png"))
        }else{
            foodImageView.sd_setImage(with: URL(string:"https://img.hachimenroppi.com/image.php?f=CZB5ApsB&adir=topic&id=100"), placeholderImage:UIImage(named:"loading.png"))
            //foodImageView.image = UIImage(named:"notfound.png")
        }*/
        setchart()
    }
    func setchart(){
       //if foodInfo == nil{return}
    //foodInfo.name
        var entries:[BarChartDataEntry] = []
        /*if food_info.prices == nil{
            return
        }*/
        if targetUrl == nil{
            return
        }
        let urlRequest = URLRequest(url:URL(string:targetUrl)!)
               webView.load(urlRequest)
               self.view.addSubview(webView)
       /* for key in food_info.prices.keys{
            let value = food_info.prices[key]?.highPrice
       //     let mediumvalue = food_info.prices[key]?.mediumPrice
            foodvalues += value!
       //     foodvalues += mediumvalue!
            keyname.append("\(key)の最高値")
        //    keyname.append("\(key)の平均値")
        }
        print(foodvalues)
        let set = LineChartDataSet(entries:entries,label:"価格")
        graphView.data = generateData()
        
        self.view.addSubview(graphView)*/
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if food_info == nil {
            return 0
        }
        return 10
       // return foodInfo.eiyou.info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if food_info.nutritional == nil{
         //   print("yes")
            cell.textLabel?.text = "データがありません"
            return cell
        }
        if indexPath.row == 0{
            cell.textLabel?.text = "材料の栄養価(100gあたり)\t 成人男性の目標摂取量との割合"
            return cell
        }
        
        if food_info.nutritional.info[indexPath.row-1].value == ""{
            cell.textLabel?.text = "\((food_info.nutritional.info[indexPath.row-1].name)!):\t0\((food_info.nutritional.info[indexPath.row-1].unit)!)"
        }
        else{
            if needs[indexPath.row-1] == 0{
            cell.textLabel?.text = "\((food_info.nutritional.info[indexPath.row-1].name)!):\((food_info.nutritional.info[indexPath.row-1].value)!)\((food_info.nutritional.info[indexPath.row-1].unit)!)"
            }
            var value = food_info.nutritional.info[indexPath.row-1].value
            value = value?.replacingOccurrences(of: ",", with: "")
            var val = atof(value)
            let persent = 10000*val/needs[indexPath.row-1]
            cell.textLabel?.text = "\((food_info.nutritional.info[indexPath.row-1].name)!):\t\((food_info.nutritional.info[indexPath.row-1].value)!)\((food_info.nutritional.info[indexPath.row-1].unit)!)\t\(round(persent)/100)%"
        }
       // var value = atof(foodInfo.eiyou.info[indexPath.row]*/
        return cell
    }
    func generateData() -> LineChartData{
        var value:[Int]=[]
        var mvalue:[Int]=[]
        let date = Date()
        let calendar = Calendar.current
        var month = calendar.component(.month, from: date)
        
        for i in 0..<12{
            //if i<8{
                if foodvalues[i] == "-"{
                    value.append(0)
                }else{
                   // var range:Range!
                    //for i in 0..foodvalues[i].{
                        
                  //  }
                    var tmp = ""
                    if (foodvalues[i].utf8.count > 3){
                        let tmpArray = foodvalues[i].components(separatedBy:  ",")
                        
                        for i in 0..<tmpArray.count{
                            tmp+=tmpArray[i]
                        }
                    }else{
                         tmp = foodvalues[i]
                    }
                    print(i,foodvalues[i])
                value.append(Int(tmp)!)
                }
                continue
            }
          /*  if foodvalues[i] == "-"{
                mvalue.append(0)
            }else{
                mvalue.append(Int(foodvalues[i])!)
            }*/
       // }
        var entries: [ChartDataEntry] = Array()
        for (i, value) in value.enumerated(){
          //  if i<5{
                entries.append(ChartDataEntry(x: Double(i), y: Double(value), icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))
          //  }else{
           //     entries.append(ChartDataEntry(x: Double(i-4), y: Double(value), icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))
         //   }
            
            var comps = DateComponents(month:1)
            calendar.date(byAdding: comps, to: date)
            month = calendar.component(.month, from: date)
        }
        var entries2: [ChartDataEntry] = Array()
        for (i, value) in value.enumerated(){
            entries2.append(ChartDataEntry(x: Double(month), y: Double(value), icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))
            var comps = DateComponents(month:1)
            calendar.date(byAdding: comps, to: date)
            month = calendar.component(.month, from: date)
        }
        var linedata:  [LineChartDataSet] = Array()
        lineDataSet = LineChartDataSet(entries: entries2, label: "")
        lineDataSet.drawIconsEnabled = false
        lineDataSet.colors = [NSUIColor.white]
        lineDataSet.circleColors = [NSUIColor.white]
        linedata.append(lineDataSet)
        lineDataSet = LineChartDataSet(entries: entries, label: "\(keyname[0])")
        lineDataSet.drawIconsEnabled = false
        lineDataSet.colors = [NSUIColor.red]
        lineDataSet.circleColors = [NSUIColor.red]
        linedata.append(lineDataSet)
        return LineChartData(dataSets: linedata)
    }
}
   /* extension ViewController: WKNavigationDelegate {
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
}*/

