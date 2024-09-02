//
//  WritingToolsViewController.swift
//  ITHelloWorld_2024
//
//  Created by Marvin on 2024/9/1.
//

#if canImport(UIKit)
import UIKit

class WritingToolsViewController: UIViewController {
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.allowedWritingToolsResultOptions = [.list, .plainText, .richText, .table]
        textView.delegate = self
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupWritingTools()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemPink
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false  // Disable autoresizing mask
        // Set constraints
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func setupWritingTools() {
        textView.writingToolsBehavior = .complete
    }
}

extension WritingToolsViewController: UITextViewDelegate {
    
    func textViewWritingToolsWillBegin(_ textView: UITextView) {
        print("text view writing tools will begin: \(textView.text)")
    }
    
    func textViewWritingToolsDidEnd(_ textView: UITextView) {
        print("text view writing tools did end: \(textView.text)")
    }
}
#endif
