//
//  Corona+TableView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/05/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit

extension CoronaController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataCovid.count == 0 {
            tableView.setViewForEmptyData(image: UIImage(named: "img_empty_table"), message: "I lost somethinng")
            return 0
        } else {
            tableView.backgroundView = nil
            return dataCovid.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoronaCell") as! CoronaCell
        cell.data = dataCovid[indexPath.row].attributes
        return cell
    }
}
