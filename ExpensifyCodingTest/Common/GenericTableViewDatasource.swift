//
//  GenericTableViewDatasource.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit.UITableView

class GenericTableViewDatasource<Model: Decodable, Cell: UITableViewCell>: NSObject, UITableViewDataSource {
  
  var dataList: [Model] = []
  
  private let configure: (Cell, Model) -> Void
  init(configure: @escaping ((Cell, Model) -> Void)) {
    self.configure = configure
    super.init() 
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: Cell = tableView.dequeueReusableCell(for: indexPath)
    let item = dataList[indexPath.row]
    configure(cell, item)
    return cell
  }
  
}
