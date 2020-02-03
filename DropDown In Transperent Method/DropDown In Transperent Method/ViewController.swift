//
//  ViewController.swift
//  DropDown In Transperent Method
//
//  Created by sarath kumar on 02/02/20.
//  Copyright © 2020 sarath kumar. All rights reserved.
//

import UIKit

class CellClass: UITableViewCell {
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    
    var transperantView = UIView()
    var tableView = UITableView()
    
    var dataSource = [String]()
    var selectedButton = UIButton()
    var cityAndStateDictionay = [String:[String]]()
    var selectedKey = String()
    
    var bigString = "TamilNadu@Chennai,Covai,Madurai/Andra@tirupathi,qwerty/Kerala@kollam,alape"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        let state = bigString.components(separatedBy: "/")
        for index in state {
            let stateAndCity = index.components(separatedBy: "@")
            cityAndStateDictionay.updateValue(stateAndCity[1].components(separatedBy: ","), forKey: stateAndCity[0])
        }
        print(cityAndStateDictionay)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "cell")
    }
    
    func addtransperantView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transperantView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transperantView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        tableView.reloadData()
        
        transperantView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransperantView))
        transperantView.addGestureRecognizer(tapGesture)
        transperantView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.transperantView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransperantView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.transperantView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }

    @IBAction func stateButtonAction(_ sender: Any) {
        dataSource = Array(cityAndStateDictionay.keys)
        
        selectedButton = stateButton
        addtransperantView(frames: stateButton.frame)
    }

    @IBAction func cityButtonAction(_ sender: Any) {
        let selectedState = stateButton.titleLabel?.text
        if selectedState != "Select State" {
            dataSource = Array((cityAndStateDictionay["\(selectedState!)"] ?? [""])!)
            print(dataSource)
            selectedButton = cityButton
            addtransperantView(frames: cityButton.frame)
        }
        
    }
    
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        
        removeTransperantView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

