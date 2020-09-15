//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class WeatherViewController: UIViewController {

    @IBOutlet weak var txtFieldEmail: MDCTextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    var txtFieldEmailController:MDCTextInputControllerUnderline!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtFieldEmailController = MDCTextInputControllerUnderline(textInput: txtFieldEmail)
        txtFieldEmailController.isFloatingEnabled = true
        
        searchTextField.delegate = self
    }

    @IBAction func searchPressed(_ sender: Any?) {
        searchTextField.endEditing(true)
        print(searchTextField.text ?? "")
    }
    
}

extension WeatherViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something!"
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
}

