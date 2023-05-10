//
//  UIElementFactory.swift
//  MixARTask
//
//  Created by Табункин Вадим on 08.05.2023.
//

import UIKit

class UIElementFactory {

    func addIconButtom(icon: UIImage, color: UIColor, cornerRadius: CGFloat, actionDoun: @escaping () -> Void, actionUp: @escaping () -> Void) -> UIButton {
        return {
            $0.toAutoLayout()
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
            $0.tintColor = color
            $0.setImage(icon, for: .normal)
            $0.layer.cornerRadius = cornerRadius
            $0.layer.masksToBounds = true
            $0.addAction(UIAction(handler: { _ in
                actionDoun()
            }) , for: .touchDown)
            $0.addAction(UIAction(handler: { _ in
                actionUp()
            }) , for: .touchUpInside)

            return $0
        }(UIButton())
    }
}
