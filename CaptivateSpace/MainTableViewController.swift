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

    var objects = [NearbyObject]()
    var dataController:DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getObjects()
    }

    private func getObjects() {
        let _ = SIClient.sharedInstance.getObjects() { (data, error) in
            if error == nil {
                self.objects = data as! [NearbyObject]
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                let alert = UIAlertController(title: "Alert", message: "There was a problem retrieving Nearby Object info!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CustomTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "objectCell", for: indexPath) as! CustomTableViewCell
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
            if let result = try? dataController.viewContext.fetch(fetchRequest)
            {
                if result.count == 0 {
                    let nearbyOjct = NearbyObjs(context: dataController.viewContext)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm"
                    let cd = dateFormatter.date(from:object.cd)
                    nearbyOjct.fullname = unwrapped
                    nearbyOjct.cd = cd! as NSDate
                    nearbyOjct.des = object.des
                    nearbyOjct.dist = (object.dist as NSString).floatValue
                    try? dataController.viewContext.save()
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
}
