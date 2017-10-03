//
//  DemoTableViewController.swift
//  SyncFiddle
//
//  Created by Pavel Peroutka on 02/10/2017.
//  Copyright © 2017 Pavel Peroutka. All rights reserved.
//

import UIKit
import Alamofire
import Sync
import CoreData

class DemoTableViewController: UITableViewController {
    
    var dataStack = AppDelegate.sharedDataStack
    var skills = [Skill]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "skillCell")
        
        fetchCurrentObjects()
        fetchNewData()
    }
    
    public func fetchNewData() {
        // TODO: kterou queue pouzit? podle toho, jestli budu brat data pro table view rovnou z odpovedi serveru, nebo z core data
        // datastack asi stejnak bezi mimo main queue, takze jde jen o parsovani, to je asi v pohode
        let queue = DispatchQueue.global(qos: .userInitiated)
        Alamofire.request(APIRouter.Skills).responseJSON(queue: queue) { (response) in
            if let json = response.result.value as? [[String: Any]] {
                self.dataStack.sync(json, inEntityNamed: String(describing: Skill.self), completion: { (error) in
                    print("fetched new data")
                    if error != nil {
                        print("there was an error")
                    }
                    self.createCoreDataRelationships()
                    self.fetchCurrentObjects()
                })
            }
        }
    }

    func createCoreDataRelationships() {
        let request = NSFetchRequest<Skill>(entityName: String(describing: Skill.self))
        let skills = try! dataStack.mainContext.fetch(request)
        for skill in skills {
            if skill.superSkillID != 0 {
                let superSkill = skills.filter({
                    return $0.skillID == skill.superSkillID
                }).first
                skill.superSkill = superSkill
            }
        }
    }
    
    func fetchCurrentObjects() {
        let request = NSFetchRequest<Skill>(entityName: String(describing: Skill.self))
        self.skills = try! dataStack.mainContext.fetch(request)
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath)
        let skill = skills[indexPath.row]
        cell.textLabel?.text = "\(skill.title ?? "N/A") [parent:\(skill.superSkill?.title ?? "N/A")]"
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
