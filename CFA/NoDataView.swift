//
//  NoDataView.swift
//  CFA
//
//  Created by Johnny Gu on 03/05/2017.
//  Copyright © 2017 Johnny Gu. All rights reserved.
//

import UIKit
import SnapKit

class NoDataView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let logo = UIImageView(image: UIImage(named: "tabbar_videos"))
        addSubview(logo)
        logo.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(50)
            maker.center.equalToSuperview()
        }
        let titleLabel = UILabel()
        titleLabel.text = "no data available"
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(logo.snp.bottom)
            maker.centerX.equalToSuperview()
        }
        let tapLabel = UILabel()
        tapLabel.text = "tap to reload"
        addSubview(tapLabel)
        tapLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.centerX.equalToSuperview()
        }
    }
}
