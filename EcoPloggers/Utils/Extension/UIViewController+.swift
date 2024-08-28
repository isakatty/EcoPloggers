//
//  UIViewController+.swift
//  EcoPloggers
//
//  Created by Jisoo HAM on 8/15/24.
//

import UIKit

extension UIViewController {
    var safeArea: UILayoutGuide {
        return view.safeAreaLayoutGuide
    }
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func configureNavigationLeftBar(action: Selector?) {
        if action != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: action
            )
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(backBtnTapped)
            )
        }
        navigationController?.navigationBar.tintColor = Constant.Color.core
        navigationController?
            .interactivePopGestureRecognizer?.delegate = nil
    }
    func configureModalBackBtn() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(dismissBtnTapped)
        )
        navigationController?.navigationBar.tintColor = Constant.Color.core
    }
    @objc func dismissBtnTapped() {
        dismiss(animated: true)
    }
    @objc func backBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
    func setRootViewController<T: UIViewController>(_ rootViewController: T) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        sceneDelegate?.window?.rootViewController = rootViewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    func showAlert(
        title: String,
        message: String,
        ok: String,
        handler: @escaping (() -> Void)
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: ok, style: .default) { _ in
            handler()
        }
        let second = UIAlertAction(title: "취소", style: .destructive) { _ in }
        alert.addAction(ok)
        alert.addAction(second)
        present(alert, animated: true)
    }
}
