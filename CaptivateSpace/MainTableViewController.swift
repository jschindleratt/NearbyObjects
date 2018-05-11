//
//  MainTableViewController.swift
//  CaptivateSpace
//
//  Created by Joshua Schindler on 4/22/18.
//  Copyright © 2018 Joshua Schindler. All rights reserved.
//

import CoreData
import UIKit

class MainTableViewController: UITableViewController, OptionButtonsDelegate {
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    var objects = [NearbyObject]()
    var dataController:DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getObjects()
    }

    private func getObjects() {
        activityIndicator.startAnimating()
        let _ = SIClient.sharedInstance.getObjects() { (data, error) in
            if error == nil {
                self.objects = data as! [NearbyObject]
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            } else {
                var sMessage: String = ""
                switch error?.code {
                case 1  :
                    sMessage = "Network error."
                case 2  :
                    sMessage = "Response code other then 2xx"
                case 3  :
                    sMessage = "No data was returned by request"
                case 4  :
                    sMessage = "Could not parse JSON"
                case 5  :
                    sMessage = "No matches"
                case 6  :
                    sMessage = "Could not find key is results."
                default :
                    sMessage = ""
                }
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    let alert = UIAlertController(title: "Alert", message: "There was a problem retrieving Nearby Object info! \(sMessage)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CustomTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "objectCell", for: indexPath) as! CustomTableViewCell
        cell.favoriteBtn.setAttributedTitle(nil, for: .normal)
        let object = objects[(indexPath as NSIndexPath).row]
        cell.lblDistance?.text = "Distance: \(object.dist)"
        if let unwrapped = object.fullname {
            cell.lblFullName?.text = "Name: \(unwrapped)"
        }
        cell.lblTime?.text = "Date/Time: \(object.cd)"
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }

    func favoriteTapped(at index: IndexPath) {
        var message: String = "Object added to Countdown!"
        let object = objects[(index as NSIndexPath).row]
        if let unwrapped = object.fullname {
            let fetchRequest:NSFetchRequest<NearbyObjs> = NearbyObjs.fetchRequest()
            let predicate = NSPredicate(format: "fullname = %@", unwrapped)
            fetchRequest.predicate = predicate
            if let result = try? dataController.viewContext.fetch(fetchRequest) {
                if result.count == 0 {
                    let nearbyOjct = NearbyObjs(context: dataController.viewContext)
                    let cd = dateFormatter.date(from: object.cd)
                    nearbyOjct.fullname = unwrapped
                    nearbyOjct.cd = cd! as NSDate
                    nearbyOjct.des = object.des
                    nearbyOjct.dist = (object.dist as NSString).floatValue
                    do {
                        try dataController.viewContext.save()
                    } catch {
                        message = "Pin was not saved (\(error))!"
                    }
                } else {
                    message = "Object already in Countdown!"
                }
                let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CountdownCollectionViewController {
            vc.dataController = dataController
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MMM-dd HH:mm"
        return df
    }()
}
