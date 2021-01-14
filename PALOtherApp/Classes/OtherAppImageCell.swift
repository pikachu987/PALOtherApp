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

class OtherAppImageCell: UICollectionViewCell {
    static let identifier = "OtherAppImageCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var item: String? {
        didSet {
            self.imageView.image = nil
            guard let urlPath = self.item,
                let url = URL(string: urlPath) else { return }
            DispatchQueue.global().async {
                URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                    guard error == nil,
                        let data = data else { return }
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                    }.resume()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.imageView)
        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.contentView, attribute: .leading, relatedBy: .equal, toItem: self.imageView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.contentView, attribute: .trailing, relatedBy: .equal, toItem: self.imageView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.contentView, attribute: .top, relatedBy: .equal, toItem: self.imageView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.contentView, attribute: .bottom, relatedBy: .equal, toItem: self.imageView, attribute: .bottom, multiplier: 1, constant: 0)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
