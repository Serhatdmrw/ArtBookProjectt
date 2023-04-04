//
//  ViewController.swift
//  ArtBookProject
//
//  Created by Serhat Demir on 3.04.2023.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let viewModel = HomeViewModel()
    var nameArray : [String] = []
    var idArray : [UUID] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDelegates()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
}

private extension HomeViewController {
    
    func addDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
    }
    
    @objc func getData() {
        viewModel.getData()
    }
    
    func makeAlert(tittleInput: String, messegaInput: String) {
        let alert = UIAlertController(title: tittleInput, message: messegaInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = self.nameArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        detailsViewController.chosenPainting = self.nameArray[indexPath.row]
        detailsViewController.chosenPaintingId = self.idArray[indexPath.row]
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func didGetDataSuccess(nameArray: [String], idArray: [UUID]) {
        self.nameArray = nameArray
        self.idArray = idArray
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func didGetDataFail(messega: String) {
        self.makeAlert(tittleInput: "Error", messegaInput: messega)
    }
    
    
}
