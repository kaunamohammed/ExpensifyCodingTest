//
//  TransactionListDatasource.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

// this can easily be put in the TransactionListViewController but incase of future development
final class TransactionListDatasource: GenericTableViewDatasource<TransactionList, TransactionListTableViewCell> {
  
  var dateFormatter = DateFormatter()
  
  private var transactionListGroupedByDate = [[TransactionList]]()
  
  private var groupedByDate: [Date: [TransactionList]] = .init()
  
  override init(dataList: [TransactionList], configure: @escaping ((TransactionListTableViewCell, TransactionList) -> Void)) {
    super.init(dataList: dataList, configure: configure)
    
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    groupedByDate = Dictionary(grouping: dataList) { (element) -> Date in
      let date = dateFormatter.date(from: element.created.orEmpty)
      return date!
    }
    groupedByDate.keys.sorted(by: { $0 > $1 }).forEach { key in
      let values = groupedByDate[key]
      transactionListGroupedByDate.append(values ?? [])
    }
    
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return transactionListGroupedByDate[section].first?.created
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return transactionListGroupedByDate.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return transactionListGroupedByDate[section].count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: TransactionListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    let item = transactionListGroupedByDate[indexPath.section][indexPath.row]
    configure(cell, item)
    return cell
  }
  
}
