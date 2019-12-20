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
var results:[rakuten]=[]
var locationmaneger:CLLocationManager!
var rakutenResults:[rakutenResult]=[]
//var result:[rakuten]=[]
var tapped_path:Int!
var id = 10
var count = 0
var count_result = 0
var timer:Timer?
class ViewController: UIViewController,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate{
    @IBOutlet var menucollection: UICollectionView!
    var datas:recipilist?

    var menutable:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.tintColor = .gray
        self.automaticallyAdjustsScrollViewInsets = false
        let LAYOUT = UICollectionViewFlowLayout()
        LAYOUT.minimumLineSpacing = 0
        LAYOUT.itemSize = CGSize(width:self.view.frame.width/2-CGFloat(5),height:self.view.frame.height/3)
        self.menucollection.collectionViewLayout = LAYOUT
        self.menucollection.delegate = self
        self.menucollection.dataSource = self
        timer = Timer.scheduledTimer(withTimeInterval:2,repeats:true,block:{_ in self.searchCategoryRanking()})
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapped_path = indexPath.row
        let nextvc = RecipeViewController()
        let next = self.storyboard!.instantiateViewController(withIdentifier: "recipeview") as? RecipeViewController
        nextvc.view.backgroundColor = UIColor.blue
        print(indexPath.row)
        performSegue(withIdentifier: "toRecipe", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipe" {
            let nextView = segue.destination as! RecipeViewController
            var ind = 0
            var tmp = Double(tapped_path!)
           // var tapped = tapped_path!
            for i in 0..<100{
                if tmp/4.0 >= 1{
                    ind += 1
                    tmp /= 4.0
                }else{
                    break
                }
            }
              nextView.recipename = results[tapped_path].recipeTitle
              nextView.recipeInfo = results[tapped_path]
        }
    }
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // print(results.count)
        if rakutenResults.count == 0 {
            return 6
        }
        return results.count
        //results[0].result.count//
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
       //print(indexPath.row)
        /*if indexPath.row != 0 && indexPath.row%4 == 0{
            count += 1
            count_result = 0
            print(count)
        }*/
        //print(count_result)
      //  print(rakutenResults[count].result[count_result].recipeTitle)
        cell.backgroundColor = .white
        cell.imageview = UIImageView(frame:cell.frame)
        var imagepath = results[indexPath.row].foodImageUrl//results[0].result[indexPath.row].picture//
        var imageurl:String!
        imageurl = "\(imagepath)"
        cell.imageview.sd_setImage(with: URL(string:imageurl), placeholderImage:UIImage(named:"loading.png"))
        cell.needminute.text = results[indexPath.row].recipeIndication//results[0].result[indexPath.row].time//
        cell.needminute.font = UIFont.systemFont(ofSize: 20)
        collectionView.addSubview(cell.imageview)
        self.view.bringSubviewToFront(cell.needminute)
        count_result += 1
        return cell
    }
}
extension ViewController{
    func searchCategoryRanking(){
        let apiKey = Key()
        var rakutenurl = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?applicationId=\(apiKey.key!)&categoryType=large&categoryId=\(id)"
     Alamofire.request(rakutenurl,method: .get).responseString{response in
     switch response.result{
        case .success:
                guard let json = response.data else{return}
                let decoder:JSONDecoder = JSONDecoder()
                do{
                    let result:rakutenResult = try decoder.decode(rakutenResult.self,from:json)
                    rakutenResults.append(result)

                }catch{
                    print("JSON convert failed",error.localizedDescription)
                }

                break
        case .failure(let ERROR):
            print(ERROR)
            break
    }

        id += 1
        if id > 15{
            timer?.invalidate()
           // print(rakutenResults[1])
            for i in 0..<rakutenResults.count{
                for j in 0..<rakutenResults[i].result.count{
                    results.append(rakutenResults[i].result[j])
                }
            }
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

