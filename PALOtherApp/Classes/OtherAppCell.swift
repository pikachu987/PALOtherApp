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

protocol OtherAppCellDelegate: class {
    func otherAppCellDelegate(_ cell: UITableViewCell)
}

class OtherAppCell: UITableViewCell {
    static let identifer = "OtherAppCell"
    
    weak var delegate: OtherAppCellDelegate?
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.1
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let appDescLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor(white: 155/255, alpha: 1)
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let height: CGFloat = 160 - 24 - 1
        
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        flow.itemSize = CGSize(width: 200*height/433, height: height)
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 4
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(OtherAppImageCell.self, forCellWithReuseIdentifier: OtherAppImageCell.identifier)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var originURL: String?
    
    var item: OtherApp? {
        didSet {
            if self.item?.url != self.originURL {
                if let urlPath = self.item?.icon,
                    let url = URL(string: urlPath) {
                    self.iconImageView.image = nil
                    DispatchQueue.global().async {
                        URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                            guard error == nil,
                                let data = data else { return }
                            DispatchQueue.main.async {
                                self.iconImageView.image = UIImage(data: data)
                            }
                        }.resume()
                    }
                }
                
                self.collectionView.reloadData()
                if !(self.item?.images.isEmpty ?? true) {
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
                }
            }
            
            self.appNameLabel.text = self.item?.name
            self.appDescLabel.text = self.item?.desc
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.appNameLabel)
        self.contentView.addSubview(self.appDescLabel)
        self.contentView.addSubview(self.collectionView)
        
        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.contentView, attribute: .leading, relatedBy: .equal, toItem: self.iconImageView, attribute: .leading, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: self.contentView, attribute: .top, relatedBy: .equal, toItem: self.iconImageView, attribute: .top, multiplier: 1, constant: -12)
            ])
        
        self.iconImageView.addConstraints([
            NSLayoutConstraint(item: self.iconImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 70),
            NSLayoutConstraint(item: self.iconImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 70)
            ])
        
        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.iconImageView, attribute: .leading, relatedBy: .equal, toItem: self.appNameLabel, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.iconImageView, attribute: .trailing, relatedBy: .equal, toItem: self.appNameLabel, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.iconImageView, attribute: .bottom, relatedBy: .equal, toItem: self.appNameLabel, attribute: .top, multiplier: 1, constant: -4)
            ])
        
        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.iconImageView, attribute: .leading, relatedBy: .equal, toItem: self.appDescLabel, attribute: .leading, multiplier: 1, constant: 14),
            NSLayoutConstraint(item: self.iconImageView, attribute: .trailing, relatedBy: .equal, toItem: self.appDescLabel, attribute: .trailing, multiplier: 1, constant: -14),
            NSLayoutConstraint(item: self.appNameLabel, attribute: .bottom, relatedBy: .equal, toItem: self.appDescLabel, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.contentView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self.appDescLabel, attribute: .bottom, multiplier: 1, constant: 2)
            ])
        
        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.iconImageView, attribute: .trailing, relatedBy: .equal, toItem: self.collectionView, attribute: .leading, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: self.contentView, attribute: .trailing, relatedBy: .equal, toItem: self.collectionView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.contentView, attribute: .top, relatedBy: .equal, toItem: self.collectionView, attribute: .top, multiplier: 1, constant: -12),
            NSLayoutConstraint(item: self.contentView, attribute: .bottom, relatedBy: .equal, toItem: self.collectionView, attribute: .bottom, multiplier: 1, constant: 12)
            ])
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: OtherAppCell: UICollectionViewDelegate
extension OtherAppCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.otherAppCellDelegate(self)
    }
}

// MARK: OtherAppCell: UICollectionViewDataSource
extension OtherAppCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.item?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherAppImageCell.identifier, for: indexPath) as? OtherAppImageCell else { fatalError() }
        cell.item = self.item?.images[indexPath.row]
        return cell
    }
}
