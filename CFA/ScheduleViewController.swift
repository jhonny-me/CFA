//
//  FirstViewController.swift
//  CFA
//
//  Created by Johnny Gu on 9/16/16.
//  Copyright © 2016 Johnny Gu. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(ScheduleCell.classForCoder(), forCellReuseIdentifier: ScheduleCell.Identifier)
        tableView.register(ScheduleHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: ScheduleHeaderView.Identifer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ScheduleHeaderView.Identifer) as? ScheduleHeaderView else {
            return ScheduleHeaderView()
        }
        header.textLabel?.text = "Tuesday, 01:00 China Time"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    // MARK: Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.Identifier, for: indexPath) as? ScheduleCell else { return ScheduleCell() }
        cell.textLabel?.text = "Keynote"
        cell.detailTextLabel?.text = "1:00-3:00 AM - Bill Graham Civic Auditorium"
        
        return cell
    }
    
}

class ScheduleCell: UITableViewCell {
    
    static let Identifier = "ScheduleCellIdentifier"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: ScheduleCell.Identifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class ScheduleHeaderView: UITableViewHeaderFooterView {
    
    static let Identifer = "ScheduleHeaderIdentifier"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: ScheduleHeaderView.Identifer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
