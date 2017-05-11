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
        
        tableView.rowHeight = 44
//        tableView.register(ScheduleCell.classForCoder(), forCellReuseIdentifier: ScheduleCell.Identifier)
        tableView.register(ScheduleHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: ScheduleHeaderView.Identifer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.3) {
//            self.view.showHUD(.toast("something went wrong"))
//        }
//        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) { 
//            SwiftHUD(type: .progress(nil)).queueStyle(.concurrent).addTo(self.view).animate([]).show()
//        }
//        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.3) { 
//            SwiftHUD(type: .progress(nil)).queueStyle(.stack).position(.top).addTo(self.view).show()
//        }
    
        if APIService.default.namespace != nil { return }
        let setupVC = UIStoryboard(.Main).initiate(SetupViewController.self)
        present(setupVC, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func accountAction(with sender: Any) {
        if let _ = APIService.default.token {
            APIService.default.logout { _ in
                APIService.default.token = nil
            }
        }else {
            let login = UIStoryboard(.Main).initiate(LoginViewController.self)
            present(login, animated: true, completion: nil)
        }
    }
    
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ScheduleHeaderView.Identifer) as? ScheduleHeaderView else {
            return ScheduleHeaderView()
        }
        header.textLabel?.text = "Tuesday, 01:00 China Time"
        header.contentView.backgroundColor = Config.scheduleSectionColor
        return header
    }
    
    // MARK: Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.Identifier, for: indexPath) as? ScheduleCell else { return ScheduleCell() }
        cell.eventLabel?.text = "Keynote"
        cell.timeLabel?.text = "1:00-3:00 AM - Bill Graham Civic Auditorium"
//        cell.backgroundColor = Config.scheduleCellColor
        return cell
    }
}

class ScheduleCell: UITableViewCell {
    
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var colorSignView: UIView!
    
    static let Identifier = "ScheduleCellIdentifier"
    
    
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
