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
    func showToast(
        message : String
    ) {
        let toastLabel = UILabel()
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.sizeToFit()
        
        let padding: CGFloat = 20.0
        let labelWidth = toastLabel.frame.width + padding * 2
        let labelHeight = toastLabel.frame.height + padding
        toastLabel.frame = CGRect(
            x: (self.view.frame.size.width - labelWidth) / 2,
            y: self.view.frame.size.height - 180,
            width: labelWidth,
            height: labelHeight
        )
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 7.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
