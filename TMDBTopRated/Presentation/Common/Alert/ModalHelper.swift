//
//  ModalHelper.swift
//  TMDBTopRaited
//
//  Created by Jesus Loaiza Herrera on 05/08/24.
//

import UIKit


enum ModalHelperConfig{
  case accept   // Usa el copy aceptar sin importar el texto que tu le pongas
  case cancel   // Usa el copy cancelar sin importar el texto que tu le pongas
  case other    // Usa texto que tu ingreses
}

struct ModalHelperModel{
  var title : String
  var aceptAction: (() -> Void)?
  var typeButton : ModalHelperConfig
}

struct ImageAlert {
  var imageUI: UIImage
  var size: (CGFloat, CGFloat) = (72, 72)
  var hideTConectaIcon: Bool
}

class ModalHelper<T: UIViewController> {
  
  static func showModalAlertDinamic(
    in viewController: T,
    image: String? = "popcorn.circle",
    imageAlert: ImageAlert? = nil,
    title: String?,
    message: String?,
    dismiss: Bool?  = true,
    buttons : [ModalHelperModel]?
  ) {
    let alert = TMDBModal(imageAlert: image ?? "popcorn.circle" ,
                          dismisSection: dismiss ?? true,
                          buttons: buttons,
                          iconImageSize: imageAlert?.size ?? (72,72))
    
    alert.setText(title: title, message: message)
    alert.setButtons()
    imageAlert?.hideTConectaIcon ?? true ? () : alert.setImage(image: imageAlert?.imageUI ?? UIImage())
    
    viewController.view.addSubview(alert)
    alert.addAnchorsWithMargin(0)
    if let window = UIApplication.shared.windows.first {
      window.addSubview(alert)
      alert.addAnchorsWithMargin(0)
    }
  }
  
}



extension UIView {
  func addToWindow()  {
    let window = UIApplication.shared.windows.last { $0.isKeyWindow }
    self.frame = window?.bounds ?? CGRect()
    window?.addSubview(self)
  }
}
