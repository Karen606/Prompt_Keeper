//
//  SettingsViewController.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 19.11.24.
//

import UIKit
import TTSwitch

class SettingsViewController: UIViewController {

    @IBOutlet var settingsButton: [UIButton]!
    @IBOutlet weak var interfaceModeSwitch: TTSwitch!
    @IBOutlet weak var modeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interfaceModeSwitch.isOn = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
    }
    
    func setupUI() {
        interfaceModeSwitch.backgroundColor = .content
        interfaceModeSwitch.thumbImage = .switch
        interfaceModeSwitch.thumbImageView.backgroundColor = .clear
        interfaceModeSwitch.thumbImageView.layer.cornerRadius = interfaceModeSwitch.thumbImageView.frame.height / 2
        interfaceModeSwitch.layer.cornerRadius = interfaceModeSwitch.frame.height / 2
        interfaceModeSwitch.thumbInsetX = 4
        interfaceModeSwitch.thumbOffsetY = (interfaceModeSwitch.frame.size.height - interfaceModeSwitch.thumbImageView.frame.size.height) / 2
        settingsButton.forEach({ $0.titleLabel?.font = .regular(size: 24); $0.addShadow() })
        modeLabel.font = .medium(size: 20)
    }

    @IBAction func chooseInterfaceMode(_ sender: TTSwitch) {
        interfaceModeSwitch.isOn = sender.isOn
        let interfaceMode = sender.isOn ? UIUserInterfaceStyle.dark : .light
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkModeEnabled")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = interfaceMode
            }
        }
    }

    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }
}
