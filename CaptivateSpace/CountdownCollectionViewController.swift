//
//  CountdownCollectionViewController.swift
//  CaptivateSpace
//
//  Created by Joshua Schindler on 5/2/18.
//  Copyright © 2018 Joshua Schindler. All rights reserved.
//

import CoreData
import UIKit

private let reuseIdentifier = "Cell"

class CountdownCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var dataController:DataController!
    var nearbyObjs:[NearbyObjs?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getSavedObjects()
   }

    private func getSavedObjects() {
        let fetchRequest:NSFetchRequest<NearbyObjs> = NearbyObjs.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "cd", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "cd > %@", NSDate())
        fetchRequest.predicate = predicate
        if let result = try? dataController.viewContext.fetch(fetchRequest)
        {
            nearbyObjs = result
            collectionView.reloadData()
        }
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearbyObjs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        let calendar = NSCalendar.current
        let date1 = calendar.startOfDay(for: NSDate() as Date)
        if let approachDate = nearbyObjs[indexPath.row]?.cd! {
            let date2 = calendar.startOfDay(for: approachDate as Date)
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            if let numberOfDays = components.day {
                if numberOfDays < 8 {
                    cell.backgroundColor = UIColor.red
                } else if numberOfDays > 7 && numberOfDays < 14 {
                    cell.backgroundColor = UIColor.yellow
                }
                cell.lblCount.text = String(numberOfDays)
            }
        }
        cell.lblName.text = nearbyObjs[indexPath.row]?.fullname
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 18
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objectToDelete = nearbyObjs[indexPath.row]
        dataController.viewContext.delete(objectToDelete!)
        try? dataController.viewContext.save()
        nearbyObjs.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
}
