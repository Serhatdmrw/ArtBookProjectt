//
//  DetailsViewController.swift
//  ArtBookProject
//
//  Created by Serhat Demir on 3.04.2023.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {

    // MARK: - Outles
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameText: UITextField!
    @IBOutlet private weak var artistText: UITextField!
    @IBOutlet private weak var yearText: UITextField!
    
    // MARK: - Properties
    private let viewModel = DetailsViewModel()
    var chosenPainting = ""
    var chosenPaintingId = UUID()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDelegates()
        addGestureRecognizer()
        if chosenPainting != "" {
            viewModel.filteringData(id: chosenPaintingId, selectedName: &nameText.text!, selectedArtist: &artistText.text!, selectedYear: &yearText.text!, selectedImage: imageView)
        } else {
            nameText.text = ""
            yearText.text = ""
            artistText.text = ""
        }
    }
    
    // MARK: - Actions
    @IBAction func saveButton(_ sender: Any) {
        DetailsViewModel().saveData(name: nameText.text!, artist: artistText.text!, year: yearText.text!, image: imageView)
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Helpers
private extension DetailsViewController {
    
    func addDelegates() {
        viewModel.delegate = self
    }
    
    func makeAlert(tittleInput: String, messegaInput: String) {
        let alert = UIAlertController(title: tittleInput, message: messegaInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func addGestureRecognizer() {
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension DetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
}

// MARK: - DetailsViewModelDelegate
extension DetailsViewController: DetailsViewModelDelegate {
    func didFilteringData(messega: String) {
        self.makeAlert(tittleInput: "Error", messegaInput: messega)
    }
    
    func didSaveDataFail(messega: String) {
        self.makeAlert(tittleInput: "Error", messegaInput: messega)
    }
}
