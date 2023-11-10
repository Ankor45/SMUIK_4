//
//  ViewController.swift
//  SMUIK_4
//
//  Created by Andrei Kovryzhenko on 10.11.2023.
//

import UIKit

struct CellData {
    let cellNumber: Int
    var isSelected: Bool
}

class ViewController: UIViewController {
    
    private var tableView: UITableView!
    private var cellDataArray: [CellData] = (1...45).map { CellData(cellNumber: $0, isSelected: false) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    // MARK: SetUpTableView
    private func setUpTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpTableViewHeader()
        
        view.addSubview(tableView)
    }
    
    private func setUpTableViewHeader() {
        tableView.tableHeaderView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: tableView.frame.width,
            height: 50))
        
        let headerView = tableView.tableHeaderView!
        
        let titleLabel = UILabel()
        titleLabel.text = "Lesson 4"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let shuffleButton = UIButton()
        shuffleButton.setTitle("Shuffle", for: .normal)
        shuffleButton.setTitleColor(.blue, for: .normal)
        shuffleButton.translatesAutoresizingMaskIntoConstraints = false
        shuffleButton.addTarget(self, action: #selector(shuffleCells), for: .touchUpInside)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(shuffleButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            shuffleButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -30),
            shuffleButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        tableView.tableHeaderView = headerView
    }
    
    //MARK: Animate
    @objc func shuffleCells() {
        cellDataArray.shuffle()
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let height = tableView.bounds.height/4
        var delay: Double = 1.0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: height)
            
            UIView.animate(
                withDuration: 0.5,
                delay: delay * 0.05,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                animations: {
                    cell.transform = CGAffineTransform.identity
                })
            delay += 1.0
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(cellDataArray[indexPath.row].cellNumber)"
        
        if cellDataArray[indexPath.row].isSelected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellDataArray[indexPath.row].isSelected.toggle()
        tableView.reloadRows(at: [indexPath], with: .none)
        if cellDataArray[indexPath.row].isSelected {
            let selectedCell = cellDataArray.remove(at: indexPath.row)
            cellDataArray.insert(selectedCell, at: 0)
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        }
    }
}
