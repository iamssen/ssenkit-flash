package ssen.components.tooltips {
import mx.core.ClassFactory;

import spark.components.Group;

public class Showcase__ToolTip extends Group {
	private var controller:ToolTipController;
	private var host:Host;

	override protected function createChildren():void {
		super.createChildren();

		host = new Host;
		host.x = 300;
		host.y = 150;
		addElement(host);

		controller = new ToolTipController;
		controller.host = host;
		controller.toolTipRenderer = new ClassFactory(Element);
	}
}
}

import flash.geom.Point;

import spark.components.Button;
import spark.components.Label;
import spark.skins.spark.ButtonSkin;

import ssen.components.tooltips.IToolTipElement;
import ssen.components.tooltips.IToolTipHostElement;

class Element extends Label implements IToolTipElement {

	public function render(host:IToolTipHostElement):void {
		text = "HELLO WORLD";
		width = 350;
		height = 250;
		setStyle("backgroundColor", 0xaaaaaa);

		x = host.toolTipHostX;
		y = host.toolTipHostY;

		mouseChildren = false;
		mouseEnabled = false;
		mouseFocusEnabled = false;
	}

	public function dispose():void {
	}
}

class Host extends Button implements IToolTipHostElement {
	public function Host() {
		label = "TEST";
		setStyle("skinClass", ButtonSkin);
	}

	private function getGlobalPoint():Point {
		return parent.localToGlobal(new Point(x, y));
	}

	public function get toolTipHostX():Number {
		return getGlobalPoint().x + (width / 2);
	}

	public function get toolTipHostY():Number {
		return getGlobalPoint().y + (height / 2);
	}

	public function get toolTipHostMargin():Number {
		return 0;
	}
}