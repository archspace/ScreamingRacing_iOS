//
//  CheckedTableViewCell.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/11/21.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import UIKit
import PinLayout

enum CheckCellStatus {
    case uncheck
    case checked
    case loading
}

class CheckedTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let checkImageView = UIImageView(image: UIImage(named:"checkmark"))
    let uncheckMessageLabel = UILabel()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    var status:CheckCellStatus = .uncheck {
        didSet(oldVal){
            switch status {
            case .uncheck:
                indicator.stopAnimating()
                checkImageView.isHidden = true
                uncheckMessageLabel.isHidden = false
                break
            case .checked:
                indicator.stopAnimating()
                checkImageView.isHidden = false
                uncheckMessageLabel.isHidden = true
                break
            case .loading:
                indicator.startAnimating()
                checkImageView.isHidden = true
                uncheckMessageLabel.isHidden = true
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if status == .loading{
            indicator.startAnimating()
        }
    }
    
    func setupUI() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = AppColor.ConnectCellText
        contentView.addSubview(checkImageView)
        checkImageView.isHidden = true
        checkImageView.tintColor = AppColor.ConnectCellText
        contentView.addSubview(uncheckMessageLabel)
        uncheckMessageLabel.text = NSLocalizedString("pCell.not.connected", comment: "")
        uncheckMessageLabel.textColor = AppColor.ConnectCellText
        uncheckMessageLabel.textAlignment = .right
        contentView.addSubview(indicator)
        indicator.hidesWhenStopped = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.pin.vCenter().left(20).height(30).width(140)
        checkImageView.pin.vCenter().right(20).width(20).height(20)
        uncheckMessageLabel.pin.vCenter().right(20).width(80).height(30)
        indicator.pin.vCenter().right(20)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
