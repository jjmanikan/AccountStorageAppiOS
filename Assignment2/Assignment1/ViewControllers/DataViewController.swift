//
//  DataViewController.swift
//  Assignment1
//
//  Created by Justine Manikan on 10/19/18.
//  Copyright © 2018 Justine Manikan. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainDelegate.readDataFromDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.pokemons.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiteCell ??
            SiteCell(style: .default, reuseIdentifier: "cell")
        
        let  rowNum = indexPath.row
        tableCell.primaryLabel.text = mainDelegate.pokemons[rowNum].name
        tableCell.secondaryLabel.text = mainDelegate.pokemons[rowNum].email
        
        if (mainDelegate.pokemons[rowNum].sprite == "Shinx"){
            tableCell.myImageView.loadGif(name:"shinx")
        }
        else if (mainDelegate.pokemons[rowNum].sprite == "Zorua"){
            tableCell.myImageView.loadGif(name : "zorua")
        }
        else {
            tableCell.myImageView.loadGif(name: "carbink")
        }
        
        tableCell.accessoryType = .disclosureIndicator
        
        return tableCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowNum = indexPath.row
        let alertController = UIAlertController(title: mainDelegate.pokemons[rowNum].name, message: mainDelegate.pokemons[rowNum].email, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
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
