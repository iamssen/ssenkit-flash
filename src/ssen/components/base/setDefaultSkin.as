package ssen.components.base {
import flash.utils.getQualifiedClassName;

import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleManager2;

public function setDefaultSkin(styleManager:IStyleManager2, component:Class, defaultSkin:Class):void {
	var selector:String = getQualifiedClassName(component).replace("::", ".");
	if (styleManager.selectors.indexOf(selector) > -1) return;

	var style:CSSStyleDeclaration = styleManager.getStyleDeclaration(selector);
	if (!style || !style.getStyle("skinClass")) {
		style = new CSSStyleDeclaration;
		style.setStyle("skinClass", defaultSkin);
	}

	styleManager.setStyleDeclaration(selector, style, true);
}
}
