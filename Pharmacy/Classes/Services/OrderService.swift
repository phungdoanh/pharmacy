//
//  OrderService.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 9/1/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import Alamofire
class OrderService: NSObject {
    static let shared = OrderService()
    
    func getOrder(parameter: [String: Int], completionHandler: @escaping (_ isSuccess: Bool, _ order: OrderObject?, _ error: String?) -> Void)
    {
        
//        {
//            "orderNumber": 1,
//            "customerId": "4",
//            "date": "2016-08-30T00:00:00.000Z",
//            "totalPrice": 0,
//            "drugs": []
//        }
        
        Alamofire.request(OrderRouter.getOrder(parameter))
        .validate()
        .response { (res) in
            
            if let err = res.error {
                completionHandler(false, nil, NetworkManager.shared.handleError(response: res.response, error: err as NSError))
                return
            }
            
            if let data = res.data {
                if let json = (data as NSData).toDictionary() {
                    if let error = json["errors"] as? [String] {
                        print(error)
                        if error.count > 0 {
                            completionHandler(false, nil, error[0])
                            return
                        }
                    }
                    
                    guard let id = json["orderNumber"] as? Int, let date = json["date"] as? String, let totalPrice = json["totalPrice"] as? Int, let drugs = json["drugs"] as? [AnyObject] else {
                        completionHandler(false, nil, "Invalid data format")
                        return
                    }
                    
                    
                    var drugArray: [DrugObject] = []
                    
                    for drugData in drugs {
                        if let drugObject = Utilities.convertObjectToJson(object: drugData) {
                            
                            guard let id = drugObject["id"] as? Int, let name = drugObject["name"] as? String, let instructions = drugObject["instructions"] as? String, let formula = drugObject["formula"] as? String, let contraindication = drugObject["contraindication"] as? String, let sideEffect = drugObject["side_effect"] as? String, let howToUse = drugObject["how_to_use"] as? String, let price = drugObject["price"] as? Int else {
                                completionHandler(false, nil, "Invalid data format")
                                return
                            }
                            
                            drugArray.append(DrugObject(id: id, name: name, instructions: instructions, formula: formula, contraindication: contraindication, sideEffect: sideEffect, howToUse: howToUse, price: price))
                            
                        } else {
                            completionHandler(false, nil, "Invalid data format")
                            return
                        }
                    }
                    
                    completionHandler(true, OrderObject(id: id, date: date, totalPrice: totalPrice, drugs: drugArray), nil)
                    
                } else {
                    completionHandler(false, nil, "Invalid data format")
                    return
                }
                
            } else {
                completionHandler(false, nil, "Invalid data format")
                return
            }
        }
        
    }
    
    func getAllOrder(completionHandler: @escaping (_ isSuccess: Bool, _ order: [OrderObject?], _ error: String?) -> Void) {
        Alamofire.request(OrderRouter.getAllOrders())
        .validate()
        .response { (res) in
            completionHandler(false, [nil], "ERROR GET ALL OREDER")
        }
    }
    
    func newOrder(parameter: [String : AnyObject], completionHandler: @escaping (_ isSuccess: Bool, _ error: String?) -> Void) {
        Alamofire.request(OrderRouter.newOrder(parameter))
        .validate()
        .response { (res) in
            completionHandler(false, "NEW ORDER FAILED")
        }
        
    }
    
    func getOrderHistory(completionHandler: @escaping (_ isSuccess: Bool, _ order: [String: AnyObject?], _ error: String?) -> Void) {
        
    }
    
    func getDetailOrder(parameters: [String: Int], completionHandler: @escaping (_ isSuccess: Bool, _ order: OrderObject?, _ error: String?) -> Void) {
        Alamofire.request(OrderRouter.getDetailOrder(parameters))
        .validate()
        .response { (res) in
            
        }
    }
}