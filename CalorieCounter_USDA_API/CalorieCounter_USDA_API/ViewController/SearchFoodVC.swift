//
//  SearchFoodVC.swift
//  CalorieCounter_USDA_API
//
//  Created by mallikarjun on 26/08/19.
//  Copyright © 2019 Mallikarjun H. All rights reserved.

/*
 
 Nutrient Database API (USDA Database)
 https://ndb.nal.usda.gov/ndb/doc/index
 
 API Key= qlpKRK9aLDnY9gRs58Wk47NUhEILw7RiCs8qFrYr
 for email = mallikarjun…iPhone9
 
 Sample API Request: https://developer.nrel.gov/api/alt-fuel-stations/v1/nearest.json?api_key=qlpKRK9aLDnY9gRs58Wk47NUhEILw7RiCs8qFrYr&location=Denver+CO
 
 For more contact/support:
 For additional support, please contact us. When contacting us, please tell us what API you're accessing and provide the following account details so we can quickly find you:
 Account Email: mallikarjun.iphone9@gmail.com
 Account ID: 542d075f-5aba-4e7f-bbe4-ef372063f6b1
 
 Search Food
 https://api.nal.usda.gov/ndb/search/?format=json&q=butter&sort=n&max=25&offset=0&api_key=DEMO_KEY

 Search Food - with Specific Database ( ds = Standard Reference or Branded Food Products)
 https://api.nal.usda.gov/ndb/search/?format=json&q=orange&sort=n&max=25&offset=0&ds=Standard%20Reference&api_key=DEMO_KEY

 Search Example = search for bread - wihtout group id
 
 https://api.nal.usda.gov/ndb/search/?format=json&q=bread&sort=r&max=25&offset=0&api_key=DEMO_KEY
 
 With group id search - gives specific search results (e.g fg=Baked Products)
 https://api.nal.usda.gov/ndb/search/?format=json&q=bread&sort=r&fg=Baked%20Products&max=25&offset=0&api_key=DEMO_KEY
 
 Nutrient Search + Food Group
 https://ndb.nal.usda.gov/ndb/nutrients/index
 
 Food Details
 
 V1 API's : Single food details
 Basic Report =  https://api.nal.usda.gov/ndb/reports/?ndbno=18028&type=b&format=json&api_key=DEMO_KEY
 Full Details = https://api.nal.usda.gov/ndb/reports/?ndbno=18028&type=f&format=json&api_key=DEMO_KEY
 (It will give full details with all types of nutrients reports)
 
 Getting Nutrients = Proteins, Carbohydrates, Fat from specific food using ndbno
 https://api.nal.usda.gov/ndb/nutrients/?ndbno=01009&format=json&api_key=qlpKRK9aLDnY9gRs58Wk47NUhEILw7RiCs8qFrYr&nutrients=203&nutrients=204&nutrients=205
 
 V2 API's : 1+ food details
 https://api.nal.usda.gov/ndb/V2/reports?ndbno=01009&ndbno=01009&ndbno=45202763&ndbno=35193&type=b&format=json&api_key=DEMO_KEY
 
 */

import UIKit
import Alamofire

class SearchFoodVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var searchFoodTableView: UITableView!
    @IBOutlet weak var searchFoodTextField: UITextField!

    @IBOutlet weak var searchBGView: UIView!
    
    @IBOutlet weak var searchDummyTextData: UILabel!
    @IBOutlet weak var searchDummyImage: UIImageView!
  
    var selectedFood:String = ""
    var sampleFoodArray = ["Apple", "Banana", "Eggs", "Watermelon", "Chicken", "Water", "Vegetables"]
    
    var searchResultArray1:[String] = []
    var searchResultArray = [" "]
    
    var ndbnoArray:[String] = []
    var ndbnoArray1:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchFoodTableView.isHidden = true
        searchBGView.layer.cornerRadius = 3
        searchDummyImage.isHidden = false
        searchDummyTextData.isHidden = false
        searchDummyTextData.isHidden = false
        searchDummyTextData.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 0.70)
    }
    
    //MARK: TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodSearchTableViewCell", for: indexPath) as! FoodSearchTableViewCell
        
        cell.foodNameLabel.text = self.searchResultArray[indexPath.row]
      //  cell.foodSubLabel.text = "1 Whole (35g)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedFood = searchResultArray[indexPath.row] //food name
      //  GlobalVariables.sharedManager.foodNdbno = ndbnoArray[indexPath.row]   //food id
        
        if !selectedFood.isEmpty{
            
            reloadView()
        }
        else{
            
        }
    }
    
    func reloadView(){
        
        DispatchQueue.main.async {
            self.searchFoodTextField.text = self.selectedFood
            self.searchFoodTableView.isHidden = true
            self.searchDummyTextData.isHidden = true
            self.searchDummyImage.isHidden = true
        }
    }
    
    //MARK: TextFeild Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.searchFoodTableView.isHidden = true
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        searchDummyTextData.isHidden = true
        searchDummyImage.isHidden = true
        
        /*   if searchTextField.text!.count > 2{
         self.searchTableView.isHidden = false
         }else
         {
         self.searchTableView.isHidden = true
         } */
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            //print("Backspace was pressed")
            return true
        }
        
        if searchFoodTextField.text!.count < 2{
        }
        else{
            // DispatchQueue.main.async {
            self.searchFoodItemAPICall(searchItem: self.searchFoodTextField.text!)
            self.searchFoodTableView.isHidden = false
            // }
        }
        
        
        return true
    }
    
    
    //MARK: Seach Food item API call
    func searchFoodItemAPICall(searchItem:String){
        
        //        if searchTextField.text!.count < 3{
        //            showAlert(message: "Please enter more than 2 characters", title: "Alert")
        //        }else{
        
        //api call
        let searchSting2:String = searchFoodTextField.text!
        let searchString = searchSting2.replacingOccurrences(of: " ", with: "%20")
        
        let url = "https://api.nal.usda.gov/ndb/search/"
        let params: [String: Any] = [
            "format": "json",
            "sort": "r",
            "max": 25,
            "offset": 0,
            "ds":"Standard Reference",
            "api_key": "qlpKRK9aLDnY9gRs58Wk47NUhEILw7RiCs8qFrYr",
            "q": searchString,
        ]
        
       /* let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ] */
        
        AF.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let JSON):
                debugPrint(JSON)
                //parse your response here
                
            case .failure(let error):
                debugPrint(error)
            }
        }
        
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
  
    }
    
   
}
