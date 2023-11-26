//
//  ReadingCell.swift
//  GeneralElectricCalculator
//
//  Created by Yarkın Gazibaba on 3.06.2023.
//

import Foundation
import UIKit
import SnapKit

class ReadingTableViewCell: UITableViewCell {
    
    static let identifier = "ReadingTableViewCell"
    let infoFont = UIFont(name: "Quicksand-Bold", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .bold)
    
    private let readingLabel: UILabel = {
        let label = UILabel()
        label.text = "reading value counter"
        label.backgroundColor = .systemPink
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let calculatedCostLabel: UILabel = {
        let label = UILabel()
        label.text = "cost counter"
        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        calculatedCostLabel.text = ""
        readingLabel.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(readingLabel)
        contentView.addSubview(calculatedCostLabel)
        readingLabel.font = infoFont
        calculatedCostLabel.font = infoFont
        setUI()
        contentView.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    func setData(consumption: String, cost: String){
        
        readingLabel.text = "Read Consumption: \(consumption)"
        // calculate with the generic fonksiyon
        calculatedCostLabel.text = "Calculated cost \(cost)"
    }
    
    
    
    func setUI() {
        readingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1)
            make.leading.equalToSuperview().offset(8)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.5)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.8)
        }
        
        calculatedCostLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-1)
            make.leading.equalToSuperview().offset(8)
            make.height.equalTo(readingLabel.snp.height)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

