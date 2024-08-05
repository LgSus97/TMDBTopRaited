//
//  TMDBModal.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 05/08/24.
//

import UIKit

class TMDBModal: UIView {
  
  var backgroundView : UIView = {
    var view = UIView()
    view.backgroundColor = STColors.lightBreeze
    view.alpha = 0.5
    return view
  }()
  
  var alertView : UIView = {
    var view = UIView()
    view.backgroundColor = STColors.cleanWhite
    view.layer.cornerRadius = 20
    return view
  }()
  
  var iconImage : UIImageView = {
    var image = UIImageView()
    image.image = UIImage(systemName: "popcorn.circle")
    image.tintColor = STColors.mistyBlue
    image.contentMode = .scaleAspectFit
    return image
  }()
  
  var titleLabel : UILabel = {
    LabelFactory(
      textColor: STColors.oceanDeep,
      style: .bold,
      fontSize: 20,
      textAlignment: .center
    ).create() as! UILabel
  }()
  
  var subTitleLabel : UILabel = {
    LabelFactory(
      textColor: STColors.stormySea,
      style: .regular,
      fontSize: 16,
      textAlignment: .center
    ).create() as! UILabel
  }()
  
  
  var iconDismiss : UIImageView = {
    var image = UIImageView()
    image.image = UIImage(systemName: "xmark")
    image.contentMode = .scaleAspectFit
    image.tintColor = STColors.mistyBlue
    image.isUserInteractionEnabled = true
    return image
  }()
  
  var stackView : UIStackView = {
    var stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 4
    return stack
  }()
  
  var stackViewTitle : UIStackView = {
    var stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 10
    return stack
  }()
  
  var stackViewButton: UIStackView = {
    var stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 15
    stack.distribution = .equalSpacing
    return stack
  }()
  
  var dismisSection: Bool = false
  var buttons: [ModalHelperModel]?
  
  var iconImageSize: (CGFloat, CGFloat) = (72,72)
  
  init(
    imageAlert: String =  "popcorn.circle",
    dismisSection: Bool = false,
    buttons : [ModalHelperModel]?,
    iconImageSize: (CGFloat, CGFloat) = (72,72)
  ) {
    super.init(frame: .zero)
    self.backgroundColor = .clear
    self.buttons = buttons
    self.dismisSection = dismisSection
    self.iconImage.image =  UIImage(systemName: imageAlert)
    self.iconImageSize = iconImageSize
    initUIDynamic()
  }
  
  func initUIDynamic() {
    self.frame = UIScreen.main.bounds
    self.addSubview(backgroundView)
    backgroundView.addAnchorsWithMargin(0)
    self.addSubview(alertView)
    alertView.addAnchorsAndCenter(centerX: true,
                                  centerY: true,
                                  width: nil,
                                  height: nil,
                                  left: 50,
                                  top: nil,
                                  right: 50,
                                  bottom: nil)
    
    stackView.addArrangedSubview(iconImage)
    alertView.addSubview(stackView)
    iconImage.addAnchorsAndSize(width: iconImageSize.0,
                                height: iconImageSize.1,
                                left: nil,
                                top: nil,
                                right: nil,
                                bottom: nil)
    
    stackView.addAnchorsAndCenter(centerX: true,
                                  centerY: false,
                                  width: nil,
                                  height: nil,
                                  left: nil,
                                  top: 16,
                                  right: nil,
                                  bottom: nil)
    
    alertView.addSubview(iconDismiss)
    iconDismiss.addAnchorsAndSize(width: 24,
                                  height: 24,
                                  left: nil,
                                  top: 20,
                                  right: 20,
                                  bottom: nil)
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimissAction))
    iconDismiss.addGestureRecognizer(tapGestureRecognizer)
    iconDismiss.isHidden = dismisSection
    
  }
  
  func setText(title: String?,
               message: String?){
    if let titleMessage = title{
      titleLabel.text = titleMessage
      stackViewTitle.addArrangedSubview(titleLabel)
    }
    
    if let messageMessage = message{
      subTitleLabel.text = messageMessage
      stackViewTitle.addArrangedSubview(subTitleLabel)
    }
    
    alertView.addSubview(stackViewTitle)
    stackViewTitle.addAnchors(left: 10,
                              top: 20,
                              right: 10,
                              bottom: nil,
                              withAnchor: .top,
                              relativeToView: stackView)
  }
  
  
  
  func setButtons(){
    if let dynamicButtons = buttons{
      for i in 0...dynamicButtons.count - 1 {
        let button = dynamicButtons[i]
        var newButton = UIButton()
        newButton.tag = i
        newButton.setTitle(button.title, for: .normal)
        configureButton(button: &newButton, configure: button)
        newButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        newButton.addTarget(self, action: #selector(configureAction), for: .touchUpInside)
        stackViewButton.addArrangedSubview(newButton)
      }
    }
    
    alertView.addSubview(stackViewButton)
    stackViewButton.addAnchorsAndSize(width: nil,
                                      height: nil,
                                      left: 40,
                                      top: 15,
                                      right: 40,
                                      bottom: 16,
                                      withAnchor: .top,
                                      relativeToView: stackViewTitle)
  }
  
  func setImage(image: UIImage) {
    self.iconImage.image = image
  }
  
  @objc func configureAction(_ sender : UIButton){
    if let button = buttons{
      let action = button[sender.tag]
      if let act = action.aceptAction{
        act()
      }
      
      dimissAction()
    }
  }
  
  func configureButton(button : inout UIButton, configure : ModalHelperModel){
    switch configure.typeButton{
    case .accept:
      button.backgroundColor = STColors.oceanDeep
      button.setTitle(configure.title, for: .normal)
      button.titleLabel?.setMontserratFont(style: .bold, size: 18, color: STColors.springGreen)
      button.layer.cornerRadius = 25
    case .cancel:
      button.backgroundColor = STColors.springGreen
      button.setTitleColor(STColors.oceanDeep, for: .normal)
      button.setTitle(configure.title, for: .normal)
      button.titleLabel?.setMontserratFont(style: .bold, size: 18, color: STColors.oceanDeep)
      button.layer.cornerRadius = 25
    case .other:
      button.backgroundColor = STColors.foggyGray
      button.setTitleColor(STColors.springGreen, for: .normal)
      button.setTitle(configure.title, for: .normal)
      button.titleLabel?.setMontserratFont(style: .bold, size: 18, color: STColors.foggyGray)
      button.layer.cornerRadius = 25
    }
  }
  
  @objc func dimissAction(){
    self.removeFromSuperview()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
