//Copyright (c) 2021 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import UIKit

public protocol OtherAppDelegate: class {
    func otherApp(_ viewController: OtherAppViewController)
    func otherAppTitle(_ viewController: OtherAppViewController)
    func otherAppTableView(_ viewController: OtherAppViewController, tableView: UITableView, cellForRowAt: UITableViewCell)
    func otherAppOpen(_ viewController: OtherAppViewController, url: URL)
}

public extension OtherAppDelegate {
    func otherApp(_ viewController: OtherAppViewController) {
        
    }
    
    func otherAppTitle(_ viewController: OtherAppViewController) {
        viewController.title = "Other App"
    }
    
    func otherAppTableView(_ viewController: OtherAppViewController, tableView: UITableView, cellForRowAt: UITableViewCell) {
        
    }
    
    func otherAppOpen(_ viewController: OtherAppViewController, url: URL) {
        
    }
}

open class OtherAppViewController: UIViewController {
    public var delegate: OtherAppDelegate?

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(OtherAppCell.self, forCellReuseIdentifier: OtherAppCell.identifer)
        tableView.clipsToBounds = true
        return tableView
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    public var url: URL?
    public var languageCode = ""

    private var array = [OtherApp]()

    public var backBarButtonItem: UIBarButtonItem?

    public init(languageCode: String, url: URL?) {
        super.init(nibName: nil, bundle: nil)
        self.languageCode = languageCode
        self.url = url
    }

    public convenience init(languageCode: String, urlPath: String) {
        self.init(languageCode: languageCode, url: URL(string: urlPath))
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor(dynamicProvider: { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return UIColor(white: 255/255, alpha: 1)
                } else {
                    return UIColor(white: 0/255, alpha: 1)
                }
            })
            self.activityIndicatorView.color = UIColor(dynamicProvider: { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return .gray
                } else {
                    return UIColor(white: 255/255, alpha: 1)
                }
            })
        } else {
            self.view.backgroundColor = UIColor(white: 255/255, alpha: 1)
            self.activityIndicatorView.color = .gray
        }
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.activityIndicatorView)
        
        guard let view = self.view else { return }
        
        self.view.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.tableView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.tableView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.tableView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.tableView, attribute: .bottom, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self.activityIndicatorView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self.activityIndicatorView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.restore()
        
        if self.backBarButtonItem == nil && self.navigationController?.viewControllers.first == self {
            self.backBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.backTap(_:)))
        }
        self.delegate?.otherAppTitle(self)
        if self.delegate == nil {
            self.title = "Other App"
        }
        self.delegate?.otherApp(self)
    }
    
    open func restore() {
        self.array = [OtherApp]()
        self.tableView.reloadData()
        self.tableView.isHidden = true
        self.activityIndicatorView.startAnimating()
        self.reloadData()
    }
    
    open func reloadData() {
        guard let url = self.url else { return }
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let json = data, let dict = try? JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [[String: AnyObject]] else{
                    return
                }
                DispatchQueue.main.async {
                    self.array = OtherApp.list(dict, languageCode: self.languageCode)
                    self.tableView.isHidden = false
                    self.activityIndicatorView.stopAnimating()
                    self.tableView.reloadData()
                }
            }
            task.resume()
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.leftBarButtonItem = self.backBarButtonItem
    }

    @objc open func backTap(_ sender: UIBarButtonItem) {
        if self.navigationController?.viewControllers.first == self {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    open func openURL(url: URL?) {
        guard let url = url else { return }
        self.delegate?.otherAppOpen(self, url: url)
        if !UIApplication.shared.canOpenURL(url) { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    open func openURL(urlPath: String?) {
        guard let urlPath = urlPath else { return }
        self.openURL(url: URL(string: urlPath))
    }
}

// MARK: OtherAppViewController: UITableViewDelegate
extension OtherAppViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openURL(urlPath: self.array[indexPath.row].url)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}

// MARK: OtherAppViewController: UITableViewDataSource
extension OtherAppViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherAppCell.identifer, for: indexPath) as? OtherAppCell else { fatalError() }
        cell.delegate = self
        cell.item = self.array[indexPath.row]
        self.delegate?.otherAppTableView(self, tableView: tableView, cellForRowAt: cell)
        return cell
    }
}

// MARK: OtherAppViewController: OtherAppCellDelegate
extension OtherAppViewController: OtherAppCellDelegate {
    func otherAppCellDelegate(_ cell: UITableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        self.openURL(urlPath: self.array[indexPath.row].url)
    }
}

