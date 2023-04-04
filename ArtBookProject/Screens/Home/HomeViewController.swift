//
//  ViewController.swift
//  ArtBookProject
//
//  Created by Serhat Demir on 3.04.2023.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Outles
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let viewModel = HomeViewModel()
    var nameArray : [String] = []
    var idArray : [UUID] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDelegates()
        getData()
        navigationBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
}

// MARK: - Helpers
private extension HomeViewController {
    
    func navigationBarButton() {
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
    }
    
    @objc func addButtonClicked() {
        
        navigationController?.pushViewController(DetailsViewController(), animated: true)
    }
    
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

// MARK: - UITableViewDelegate, UITableViewDataSource
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.commitData(idS: idArray[indexPath.row])
            nameArray.remove(at: indexPath.row)
            idArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

// MARK: -  HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    
    func didCommitDataFail(messega: String) {
        self.makeAlert(tittleInput: "Error", messegaInput: messega)
    }
    
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
