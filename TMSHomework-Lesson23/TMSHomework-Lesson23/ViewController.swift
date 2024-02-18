//
//  ViewController.swift
//  TMSHomework-Lesson23
//
//  Created by Наталья Мазур on 16.02.24.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var url = URL(string: "")
    
    var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    let urlTextField = UITextField()
    let goButton = UIButton()
    
    let textFieldHeight: CGFloat = 35
    let textFieldAndButtonSpace: CGFloat = 10
    
    let buttonsStack = UIStackView()
    let backButton = UIButton(type: .custom)
    let forwardButton = UIButton()
    let reloadButton = UIButton()
    let favoritesButton = UIButton()
    let favoritesTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var urlArray: [SavedURL] = []
    
    let favoritesView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 200))
    let greyView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    let addToFavoritesButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.setTitle(" Добавить закладку", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        setupUrlTextField()
        setupGoButton()
        setupButtonsStack()
        setupWebView()
    }
    
    private func setupUrlTextField() {
        let textFieldWidth: CGFloat = UIScreen.main.bounds.width/4*3 - textFieldAndButtonSpace
        
        urlTextField.delegate = self
        urlTextField.borderStyle = .roundedRect
        urlTextField.autocapitalizationType = .none
        urlTextField.placeholder = "Введите URL-адрес"
        urlTextField.autocorrectionType = .no
        
        view.addSubview(urlTextField)
        
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            urlTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: textFieldAndButtonSpace),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: textFieldAndButtonSpace),
            urlTextField.widthAnchor.constraint(equalToConstant: textFieldWidth),
            urlTextField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        ])
        
    }
    
    private func setupGoButton() {
        let goButtonWidth: CGFloat = UIScreen.main.bounds.width/4 - textFieldAndButtonSpace * 2
        let goButtonHeight = textFieldHeight
        
        goButton.backgroundColor = .systemBlue
        goButton.layer.cornerRadius = goButtonHeight / 5
        goButton.setTitle("Перейти", for: .normal)
        goButton.setTitleColor(.white, for: .normal)
        goButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        view.addSubview(goButton)
        
        goButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goButton.leadingAnchor.constraint(equalTo: urlTextField.trailingAnchor, constant: textFieldAndButtonSpace),
            goButton.topAnchor.constraint(equalTo: urlTextField.topAnchor),
            goButton.widthAnchor.constraint(equalToConstant: goButtonWidth),
            goButton.heightAnchor.constraint(equalTo: urlTextField.heightAnchor)
        ])
        
        goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
    }
    
    private func setupButtonsStack() {
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .center
        buttonsStack.distribution = .fillEqually
        buttonsStack.backgroundColor = .systemGray
        
        view.addSubview(buttonsStack)
        setupButton(button: backButton)
        setupButton(button: forwardButton)
        setupButton(button: reloadButton)
        setupButton(button: favoritesButton)
        
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupButton(button: UIButton) {
        
        if button == backButton {
            button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        } else if button == forwardButton {
            button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        } else if button == reloadButton {
            button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        } else if button == favoritesButton {
            button.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        button.addTarget(self, action: #selector(stackButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        buttonsStack.addArrangedSubview(button)
    }
    
    @objc func stackButtonTapped(_ sender: UIButton) {
        if sender == backButton {
            if webView.canGoBack {
                webView.goBack()
            }
        } else if sender == forwardButton {
            if webView.canGoForward {
                webView.goForward()
            }
        } else if sender == reloadButton {
            webView.reload()
        } else if sender == favoritesButton {
            setupFavoritesView()
        }
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: textFieldAndButtonSpace),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.widthAnchor.constraint(equalTo: view.widthAnchor),
            webView.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor)
        ])
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
    }
    
    private func setupGreyView() {
        greyView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(processTap(_:)))
        greyView.addGestureRecognizer(gesture)
        
        view.addSubview(greyView)
    }
    
    private func setupFavoritesTable() {
        favoritesTable.layer.cornerRadius = 15
        favoritesTable.delegate = self
        favoritesTable.dataSource = self
        favoritesTable.reloadData()
        favoritesTable.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "FavoritesTableViewCell")
        
        favoritesView.addSubview(favoritesTable)
        
        NSLayoutConstraint.activate([
            favoritesTable.topAnchor.constraint(equalTo: addToFavoritesButton.bottomAnchor, constant: 20),
            favoritesTable.leadingAnchor.constraint(equalTo: favoritesView.leadingAnchor, constant: 20),
            favoritesTable.widthAnchor.constraint(equalTo: favoritesView.widthAnchor, constant: -40),
            favoritesTable.heightAnchor.constraint(equalTo: favoritesView.heightAnchor, constant: -120)
        ])
    }
    
    @objc func processTap(_ gesture: UITapGestureRecognizer) {
        favoritesView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 250)
        favoritesView.removeFromSuperview()
        greyView.removeFromSuperview()
    }
    
    private func setupFavoritesView() {
        setupGreyView()
        
        favoritesView.backgroundColor = .darkGray
        favoritesView.layer.cornerRadius = 25
        favoritesView.addSubview(addToFavoritesButton)
        addToFavoritesButton.addTarget(self, action: #selector(addToFavoritesButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(self.favoritesView)
        
        UIView.animate(withDuration: 0.5) {
            self.favoritesView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 250, width: UIScreen.main.bounds.width, height: 250)
        }
        
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addToFavoritesButton.topAnchor.constraint(equalTo: favoritesView.topAnchor, constant: 20),
            addToFavoritesButton.leadingAnchor.constraint(equalTo: favoritesView.leadingAnchor, constant: 20),
            addToFavoritesButton.widthAnchor.constraint(equalToConstant: 200),
            addToFavoritesButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        setupFavoritesTable()
    }
    
    private func loadPage() {
        if let text = urlTextField.text {
            
            if text.contains("https://") && text.contains(".") {
                url = URL(string: text)
            } else if text.contains(".") && !text.contains("https://") {
                url = URL(string: "https://\(text)")
            } else {
                url = URL(string: "https://www.google.com/search?q=\(text)")
            }
        }
        
        let request = URLRequest(url: url ?? URL(fileURLWithPath: ""))
        webView.load(request)
    }
    
    @objc func goButtonTapped() {
        loadPage()
        urlTextField.resignFirstResponder()
    }
    
    @objc func addToFavoritesButtonTapped() {
        if let currentURL = webView.url {
            urlArray.append(SavedURL(savedURL: currentURL))
        }
        favoritesTable.reloadData()
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loadPage()
        return true
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTable.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        cell.configure(savedURL: urlArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FavoritesTableViewCell {
            if let text = cell.urlLabel.text {
                url = URL(string: "\(text)")
                urlTextField.text = text
            }
            let request = URLRequest(url: url ?? URL(fileURLWithPath: ""))
            webView.load(request)
        }
        
        favoritesView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 250)
        favoritesView.removeFromSuperview()
        greyView.removeFromSuperview()
    }
    
}

/* Создать простой браузер, используя фреймворк WebKit. Необходимо создать приложение, которое позволит пользователям просматривать веб-содержимое, выполнять базовую навигацию и сохранять закладки.
 
 Создайте пользовательский интерфейс, который включает в себя:

 - элементы управления для ввода URL-адреса +
 - кнопку "Перейти" +
 - кнопку "Добавить закладку" +
 
 Добавьте веб-представление WKWebView, которое будет отображать веб-содержимое. +

 Закладки можно отобразить в таблице снизу, при нажатии будет осуществляться переход по странице. */

