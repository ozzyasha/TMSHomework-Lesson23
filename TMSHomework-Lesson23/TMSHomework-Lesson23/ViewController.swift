//
//  ViewController.swift
//  TMSHomework-Lesson23
//
//  Created by Наталья Мазур on 16.02.24.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

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
        
        goButton.backgroundColor = #colorLiteral(red: 0, green: 0.461699307, blue: 1, alpha: 1)
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
    
    private func loadPage() {
        var url = URL(string: "")
        
        if !urlTextField.text!.contains("https://") && !urlTextField.text!.contains("http://") {
            url = URL(string: "https://\(urlTextField.text ?? "nil")")
        } else {
            url = URL(string: "\(urlTextField.text ?? "nil")")
        }
        
        let request = URLRequest(url: url ?? URL(fileURLWithPath: ""))
        webView.load(request)
    }
    
    @objc func goButtonTapped() {
        loadPage()
    }


}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            if !text.contains("https://") && !text.contains("http://") && !text.contains(".") && !text.isEmpty {
                let url = URL(string: "https://www.google.com/search?q=\(text)")
                let request = URLRequest(url: url ?? URL(fileURLWithPath: ""))
                webView.load(request)
            } else {
                loadPage()
            }
        }
        return true
    }
    
}

/* Создать простой браузер, используя фреймворк WebKit. Необходимо создать приложение, которое позволит пользователям просматривать веб-содержимое, выполнять базовую навигацию и сохранять закладки.
 
 Создайте пользовательский интерфейс, который включает в себя:

 - элементы управления для ввода URL-адреса +
 - кнопку "Перейти" +
 - кнопку "Добавить закладку"
 
 Добавьте веб-представление WKWebView, которое будет отображать веб-содержимое.

 Закладки можно отобразить в таблице снизу, при нажатии будет осуществляться переход по странице. */

