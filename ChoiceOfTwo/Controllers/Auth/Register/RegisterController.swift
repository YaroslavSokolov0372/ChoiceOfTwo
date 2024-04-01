//
//  RegisterController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 07/02/2024.
//

import UIKit
import Combine

class RegisterController: UIViewController {
    
    
    
    //MARK: - Variabels
    var vm = RegisterVM()
    private let authService = AuthService()
    var madeBindingForUsername = false
    var madeBindingForEmail = false
    var madeBindingForPassword = false
    
    //MARK: - UI Components
     let scrollView: UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.backgroundColor = .white
         scrollV.contentInsetAdjustmentBehavior = .never
         scrollV.isScrollEnabled = false
        return scrollV
    }()
     let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let headerView = AuthHeaderView(title: "Register Now", subTitle: "Register to continue")
    private let usernameIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.transform = CGAffineTransformMakeScale(1.1, 1.1)
        return indicator
    }()

    let usernameField = CustomTextField(textFieldType: .username, strokeColor: .mainPurple, backgroundColor: .white)
    let usernameError: UILabel = {
        let label = UILabel()
        label.textColor = .mainRed
        label.textAlignment = .left
        label.alpha = 0.0
        label.font = .nunitoFont(size: 14, type: .regular)
        return label
    }()
    private let usernameErrorIndicator = CustomCircleButton(
        customImage: "Plus",
        rotate: 4,
        resized: CGSize(width: 20, height: 20),
        imageColor: .mainRed,
        stroke: true,
        cornerRadius: 28
    )
    private let usernameSuccessInd = CustomCircleButton(
        customImage: "CheckMark",
        imageColor: .mainPurple,
        stroke: true,
        cornerRadius: 28
    )
    
     let emailField = CustomTextField(textFieldType: .email, strokeColor: .mainPurple, backgroundColor: .white)
     let emailError: UILabel = {
        let label = UILabel()
        label.textColor = .mainRed
        label.textAlignment = .left
        label.alpha = 0.0
        label.font = .nunitoFont(size: 14, type: .regular)
        return label
    }()
    private let emailErrorIndicator = CustomCircleButton(
        customImage: "Plus",
        rotate: 4,
        resized: CGSize(width: 20, height: 20),
        imageColor: .mainRed,
        stroke: true,
        cornerRadius: 28
    )
    private let emailSuccessInd = CustomCircleButton(
        customImage: "CheckMark",
        imageColor: .mainPurple,
        stroke: true,
        cornerRadius: 28
    )
    private let emailIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.transform = CGAffineTransformMakeScale(1.1, 1.1)
        return indicator
    }()
    
     let passwordField = CustomTextField(textFieldType: .password, strokeColor: .mainPurple, backgroundColor: .white)
     let passwordError: UILabel = {
        let label = UILabel()
        label.textColor = .mainRed
        label.textAlignment = .left
        label.alpha = 0.0
        label.font = .nunitoFont(size: 14, type: .regular)
        return label
    }()
    private let passwordErrorIndicator = CustomCircleButton(
        customImage: "Plus",
        rotate: 4,
        resized: CGSize(width: 20, height: 20),
        imageColor: .mainRed,
        stroke: true,
        cornerRadius: 28
    )
    private let passwordSuccessInd = CustomCircleButton(
        customImage: "CheckMark",
        imageColor: .mainPurple,
        stroke: true,
        cornerRadius: 28
    )
    private let passwordIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.transform = CGAffineTransformMakeScale(1.1, 1.1)
        return indicator
    }()
    
    private let continueButton = CustomButton(text: "Continue", type: .medium, strokeColor: .mainPurple)
    private let backButton = CustomCircleButton(rotate: 1, stroke: true)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
        view.backgroundColor = .white
        setupUI()
        
        usernameField.delegate = self
        usernameErrorIndicator.alpha = 0.0
        usernameSuccessInd.alpha = 0.0
        
        emailField.delegate = self
        emailErrorIndicator.alpha = 0.0
        emailSuccessInd.alpha = 0.0
        
        passwordField.delegate = self
        passwordErrorIndicator.alpha = 0.0
        passwordSuccessInd.alpha = 0.0
        backButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        registerKeyboardNotifications()
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(usernameField)
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(usernameError)
        usernameError.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(usernameIndicator)
        usernameIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(usernameErrorIndicator)
        usernameErrorIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(usernameSuccessInd)
        usernameSuccessInd.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(emailError)
        emailError.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(emailIndicator)
        emailIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(emailSuccessInd)
        emailSuccessInd.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(emailErrorIndicator)
        emailErrorIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(passwordError)
        passwordError.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(passwordIndicator)
        passwordIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(passwordErrorIndicator)
        passwordErrorIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(passwordSuccessInd)
        passwordSuccessInd.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            self.contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            self.contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            self.contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
//            self.backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            self.backButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 10),
            self.backButton.heightAnchor.constraint(equalToConstant: 50),
            self.backButton.widthAnchor.constraint(equalToConstant: 50),
//            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            self.headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 210),
            self.headerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -165),
            
            
            
            
            self.usernameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
//            self.usernameField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.usernameField.heightAnchor.constraint(equalToConstant: 55),
            self.usernameField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
//            self.usernameField.leadingAnchor.constraint(equalTo: signUpButton.leadingAnchor),
            self.usernameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: (view.frame.width * 0.075)),
//            self.usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            self.usernameError.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 5),
            self.usernameError.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor, constant: 3),
            self.usernameError.heightAnchor.constraint(equalToConstant: 17),
            
            self.usernameIndicator.leadingAnchor.constraint(equalTo: usernameField.trailingAnchor, constant: 20),
            self.usernameIndicator.topAnchor.constraint(equalTo: usernameField.topAnchor),
            self.usernameIndicator.widthAnchor.constraint(equalToConstant: 50),
            self.usernameIndicator.bottomAnchor.constraint(equalTo: usernameField.bottomAnchor),
            
            self.usernameErrorIndicator.leadingAnchor.constraint(equalTo: usernameField.trailingAnchor, constant: 20),
            self.usernameErrorIndicator.topAnchor.constraint(equalTo: usernameField.topAnchor),
            self.usernameErrorIndicator.widthAnchor.constraint(equalToConstant: 55),
            self.usernameErrorIndicator.bottomAnchor.constraint(equalTo: usernameField.bottomAnchor),
            
            self.usernameSuccessInd.leadingAnchor.constraint(equalTo: usernameField.trailingAnchor, constant: 20),
            self.usernameSuccessInd.topAnchor.constraint(equalTo: usernameField.topAnchor),
            self.usernameSuccessInd.widthAnchor.constraint(equalToConstant: 55),
            self.usernameSuccessInd.bottomAnchor.constraint(equalTo: usernameField.bottomAnchor),
            
            
            
            self.emailField.topAnchor.constraint(equalTo: usernameError.bottomAnchor, constant: 15),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            self.emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (view.frame.width * 0.075)),
            
            self.emailError.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 5),
            self.emailError.leadingAnchor.constraint(equalTo: emailField.leadingAnchor, constant: 3),
            self.emailError.heightAnchor.constraint(equalToConstant: 17),
            
            self.emailIndicator.leadingAnchor.constraint(equalTo: emailField.trailingAnchor, constant: 20),
            self.emailIndicator.widthAnchor.constraint(equalToConstant: 50),
            self.emailIndicator.topAnchor.constraint(equalTo: emailField.topAnchor),
            self.emailIndicator.bottomAnchor.constraint(equalTo: emailField.bottomAnchor),
            
            self.emailErrorIndicator.leadingAnchor.constraint(equalTo: emailField.trailingAnchor, constant: 20),
            self.emailErrorIndicator.topAnchor.constraint(equalTo: emailField.topAnchor),
            self.emailErrorIndicator.widthAnchor.constraint(equalToConstant: 55),
            self.emailErrorIndicator.bottomAnchor.constraint(equalTo: emailField.bottomAnchor),
            
            self.emailSuccessInd.leadingAnchor.constraint(equalTo: emailField.trailingAnchor, constant: 20),
            self.emailSuccessInd.topAnchor.constraint(equalTo: emailField.topAnchor),
            self.emailSuccessInd.widthAnchor.constraint(equalToConstant: 55),
            self.emailSuccessInd.bottomAnchor.constraint(equalTo: emailField.bottomAnchor),
            
            
            self.passwordField.topAnchor.constraint(equalTo: emailError.bottomAnchor, constant: 15),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            self.passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (view.frame.width * 0.075)),
            
            self.passwordError.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 5),
            self.passwordError.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor, constant: 3),
            self.passwordError.heightAnchor.constraint(equalToConstant: 17),
            
            self.passwordIndicator.leadingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: 20),
            self.passwordIndicator.widthAnchor.constraint(equalToConstant: 50),
            self.passwordIndicator.topAnchor.constraint(equalTo: passwordField.topAnchor),
            self.passwordIndicator.bottomAnchor.constraint(equalTo: passwordField.bottomAnchor),
            
            self.passwordErrorIndicator.leadingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: 20),
            self.passwordErrorIndicator.topAnchor.constraint(equalTo: passwordField.topAnchor),
            self.passwordErrorIndicator.widthAnchor.constraint(equalToConstant: 55),
            self.passwordErrorIndicator.bottomAnchor.constraint(equalTo: passwordField.bottomAnchor),
            
            self.passwordSuccessInd.leadingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: 20),
            self.passwordSuccessInd.topAnchor.constraint(equalTo: passwordField.topAnchor),
            self.passwordSuccessInd.widthAnchor.constraint(equalToConstant: 55),
            self.passwordSuccessInd.bottomAnchor.constraint(equalTo: passwordField.bottomAnchor),
            
             
            self.continueButton.topAnchor.constraint(equalTo: passwordError.bottomAnchor, constant: 20),
            self.continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.continueButton.heightAnchor.constraint(equalToConstant: 55),
            self.continueButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    //MARK: - Binding
    func bindUsername() {
        vm.username.$textState
            .debounce(for: 1.7, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.usernameField.validationStateChanged(state: state) { hasError, error in
                    if hasError {
                        self?.usernameIndicator.stopAnimating()
                        self?.showErrorWith(label: self?.usernameError, text: error?.description)
                        self?.showIndicator(circleImage: self?.usernameErrorIndicator)
                        self?.showStrokeErrorOn(textField: self?.usernameField)
                        self?.hideIndicator(circleImage: self?.usernameSuccessInd)
                        
                    } else {
                        self?.usernameIndicator.stopAnimating()
                        self?.hideIndicator(circleImage: self?.usernameErrorIndicator)
                        self?.hideErrorWith(label: self?.usernameError)
                        self?.hideStrokeErrorOn(textField: self?.usernameField)
                        self?.showIndicator(circleImage: self?.usernameSuccessInd)
                    }
                }
            }.store(in: &vm.subscriptions)
    }
    
    func bindUsernameForIndicator() {
        usernameField.textPublisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                if !(self?.usernameIndicator.isAnimating)! {
                    self?.usernameIndicator.startAnimating()
                    self?.hideIndicator(circleImage: self?.usernameErrorIndicator)
                    self?.hideErrorWith(label: self?.usernameError)
                    self?.hideStrokeErrorOn(textField: self?.usernameField)
                    self?.hideIndicator(circleImage: self?.usernameSuccessInd)
                }
//                print(text)
            }.store(in: &vm.subscriptions)
    }
    
     func usernameListener() {
        vm.username.validate(publisher: usernameField.textPublisher())
            .assign(to: \.username.textState, on: vm)
            .store(in: &vm.subscriptions)
        
//        NotificationCenter.default.post(
//            name:UITextField.textDidChangeNotification, object: usernameField)
    }
    
     func bindEmail() {
        vm.email.$textState
             .debounce(for: 1.7, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.emailField.validationStateChanged(state: state, completion: { hasError, error in
                    if hasError {
                        self?.emailIndicator.stopAnimating()
                        self?.showErrorWith(label: self?.emailError, text: error?.description)
                        self?.showIndicator(circleImage: self?.emailErrorIndicator)
                        self?.showStrokeErrorOn(textField: self?.emailField)
                        self?.hideIndicator(circleImage: self?.emailSuccessInd)
                    } else {
                        self?.emailIndicator.stopAnimating()
                        self?.hideIndicator(circleImage: self?.emailErrorIndicator)
                        self?.hideErrorWith(label: self?.emailError)
                        self?.hideStrokeErrorOn(textField: self?.emailField)
                        self?.showIndicator(circleImage: self?.emailSuccessInd)
                    }
                })
            }.store(in: &vm.subscriptions)
    }
    
    func bindEmailForIndicator() {
        emailField.textPublisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                if !(self?.emailIndicator.isAnimating)! {
                    self?.emailIndicator.startAnimating()
                    self?.hideIndicator(circleImage: self?.emailErrorIndicator)
                    self?.hideErrorWith(label: self?.emailError)
                    self?.hideStrokeErrorOn(textField: self?.emailField)
                    self?.hideIndicator(circleImage: self?.emailSuccessInd)
                }
//                print(text)
            }.store(in: &vm.subscriptions)
    }
    
     func emailListener() {
        vm.email.validate(publisher: emailField.textPublisher())
            .assign(to: \.email.textState, on: vm)
            .store(in: &vm.subscriptions)
    }
    
    func bindPassword() {
        vm.password.validate(publisher: passwordField.textPublisher())
            .debounce(for: 1.7, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.passwordField.validationStateChanged(state: state, completion: { hasError, error in
                    if hasError {
                        self?.passwordIndicator.stopAnimating()
                        self?.showErrorWith(label: self?.passwordError, text: error?.description)
                        self?.showIndicator(circleImage: self?.passwordErrorIndicator)
                        self?.showStrokeErrorOn(textField: self?.passwordField)
                        self?.hideIndicator(circleImage: self?.passwordSuccessInd)
                    } else {
                        self?.passwordIndicator.stopAnimating()
                        self?.hideIndicator(circleImage: self?.passwordErrorIndicator)
                        self?.hideErrorWith(label: self?.passwordError)
                        self?.hideStrokeErrorOn(textField: self?.passwordField)
                        self?.showIndicator(circleImage: self?.passwordSuccessInd)
                    }
                })
            }.store(in: &vm.subscriptions)
    }
    
    func bindPasswordForIndicator() {
        passwordField.textPublisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                if !(self?.passwordIndicator.isAnimating)! {
                    self?.passwordIndicator.startAnimating()
                    self?.hideIndicator(circleImage: self?.passwordErrorIndicator)
                    self?.hideErrorWith(label: self?.passwordError)
                    self?.hideStrokeErrorOn(textField: self?.passwordField)
                    self?.hideIndicator(circleImage: self?.passwordSuccessInd)
                }
//                print(text)
            }.store(in: &vm.subscriptions)
    }
    
     func passwordListener() {
         vm.email.validate(publisher: passwordField.textPublisher())
            .receive(on: RunLoop.main)
            .assign(to: \.password.textState, on: vm)
            .store(in: &vm.subscriptions)
    }
     
    //MARK: Selectors
    @objc private func dismissButtonTapped() {
        vm.dismiss()
    }
    
    @objc private func signUpButtonTapped() {
        print(vm.email.textState)
        print(vm.username.textState)
        print(vm.password.textState)
        if vm.email.textState == .success
        && vm.username.textState == .success
        && vm.password.textState == .success {
            vm.signUp { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                self.vm.goToRegisterProImage()
            }
        }
    }
     
    //MARK: - Animations
    private func showErrorWith(label: UILabel?, text: String?) {
        label?.text = text
        UIView.animate(withDuration: 0.2) {
            label?.alpha = 1.0
        }
    }
    
    private func hideErrorWith(label: UILabel?) {
        UIView.animate(withDuration: 0.2) {
            label?.alpha = 0.0
        }
    }
    
    private func hideStrokeErrorOn(textField: UITextField?) {
        textField?.layer.borderColor = UIColor.mainPurple.cgColor
    }
    
    private func showStrokeErrorOn(textField: UITextField?) {
        
        UIView.animate(withDuration: 0.3) {
            textField?.layer.borderColor = UIColor.mainRed.cgColor
        }
    }
    
    private func showIndicator(circleImage: CustomCircleButton?) {
        UIView.animate(withDuration: 0.3) {
            circleImage?.alpha = 1.0
        }
    }
    
    private func hideIndicator(circleImage: CustomCircleButton?) {
        UIView.animate(withDuration: 0.3) {
            circleImage?.alpha = 0.0
        }
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}

