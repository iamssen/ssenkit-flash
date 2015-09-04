package ssen.components.base.sizeHelpers {
import flash.events.Event;

import mx.binding.utils.BindingUtils;
import mx.core.IVisualElementContainer;
import mx.core.UIComponent;

import org.osmf.layout.VerticalAlign;

import spark.components.DropDownList;
import spark.components.Group;
import spark.components.HGroup;
import spark.components.Label;
import spark.components.VGroup;

import ssen.datakit.binders.SelectionDataBinder;

public class Showcase__ComponentSize2 extends Group {
	// invalidate container
	private var containerWidth:SelectionDataBinder = new SelectionDataBinder([NaN, 150, 200, 350, 500, 800, "30%", "50%", "70%", "100%"], 2, invalidateContainer);
	private var containerHeight:SelectionDataBinder = new SelectionDataBinder([NaN, 150, 200, 350, 500, 800, "30%", "50%", "70%", "100%"], 2, invalidateContainer);

	// invalidte components
	private var componentWidth:SelectionDataBinder = new SelectionDataBinder([NaN, 50, 200, 300, 500, "30%", "50%", "70%", "100%"], 2, invalidateComponent);
	private var componentHeight:SelectionDataBinder = new SelectionDataBinder([NaN, 50, 200, 300, 500, "30%", "50%", "70%", "100%"], 2, invalidateComponent);

	// invalidte contents
	private var contentsWidth:SelectionDataBinder = new SelectionDataBinder([100, 300, 500], 1, invalidateContents);
	private var contentsHeight:SelectionDataBinder = new SelectionDataBinder([100, 300, 500], 1, invalidateContents);
	private var contentsMinWidth:SelectionDataBinder = new SelectionDataBinder([30, 100, 150], 1, invalidateContents);
	private var contentsMinHeight:SelectionDataBinder = new SelectionDataBinder([30, 100, 150], 1, invalidateContents);
	private var vOver:SelectionDataBinder = new SelectionDataBinder(["ignore", "resize", "cut"], 1, invalidateContents);
	private var vUnder:SelectionDataBinder = new SelectionDataBinder(["ignore", "resize", "scroll"], 1, invalidateContents);
	private var vAlign:SelectionDataBinder = new SelectionDataBinder(["front", "center", "back"], 1, invalidateContents);
	private var hOver:SelectionDataBinder = new SelectionDataBinder(["ignore", "resize", "cut"], 1, invalidateContents);
	private var hUnder:SelectionDataBinder = new SelectionDataBinder(["ignore", "resize", "scroll"], 1, invalidateContents);
	private var hAlign:SelectionDataBinder = new SelectionDataBinder(["front", "center", "back"], 1, invalidateContents);

	private var container:Container;
	private var component:Component;

	public function Showcase__ComponentSize2() {
		//---------------------------------------------
		// initial options
		//---------------------------------------------
		var widthOptions:HGroup = new HGroup;
		widthOptions.verticalAlign = VerticalAlign.MIDDLE;
		addDropdownList("w container", containerWidth, widthOptions);
		addDropdownList("component", componentWidth, widthOptions);
		addDropdownList("contents", contentsWidth, widthOptions);
		addDropdownList("contents min", contentsMinWidth, widthOptions);
		addDropdownList("over", hOver, widthOptions);
		addDropdownList("under", hUnder, widthOptions);
		addDropdownList("align", hAlign, widthOptions);

		var heightOptions:HGroup = new HGroup;
		heightOptions.verticalAlign = VerticalAlign.MIDDLE;
		addDropdownList("h container", containerHeight, heightOptions);
		addDropdownList("component", componentHeight, heightOptions);
		addDropdownList("contents", contentsHeight, heightOptions);
		addDropdownList("contents min", contentsMinHeight, heightOptions);
		addDropdownList("over", vOver, heightOptions);
		addDropdownList("under", vUnder, heightOptions);
		addDropdownList("align", vAlign, heightOptions);

		//		var sizeOptions:HGroup = new HGroup;
		//		sizeOptions.verticalAlign = VerticalAlign.MIDDLE;

		var options:VGroup = new VGroup;
		options.left = 10;
		options.right = 10;
		options.top = 10;
		options.addElement(widthOptions);
		options.addElement(heightOptions);
		//		options.addElement(sizeOptions);
		addElement(options);

		//---------------------------------------------
		// initial container and component
		//---------------------------------------------
		component = new Component;
		component.hsize = new ComponentSize2(hOver.selectedValue, hUnder.selectedValue, hAlign.selectedValue);
		component.vsize = new ComponentSize2(vOver.selectedValue, vUnder.selectedValue, vAlign.selectedValue);
		setWidth(component, componentWidth.selectedValue);
		setHeight(component, componentHeight.selectedValue);
		component.contentsWidth = contentsWidth;
		component.contentsHeight = contentsHeight;
		component.contentsMinWidth = contentsMinWidth;
		component.contentsMinHeight = contentsMinHeight;

		container = new Container;
		container.component = component;
		container.addElement(component);
		setWidth(container, containerWidth.selectedValue);
		setHeight(container, containerHeight.selectedValue);

		container.horizontalCenter = 0;
		container.verticalCenter = 0;

		addElement(container);
	}

	private static function addDropdownList(title:String, dataBinder:SelectionDataBinder, container:IVisualElementContainer):void {
		var label:Label;
		var dropdown:DropDownList;
		label = new Label;
		label.text = title;

		dropdown = new DropDownList;
		dropdown.dataProvider = dataBinder.list;
		dropdown.selectedIndex = dataBinder.selectedIndex;
		dropdown.width = 80;

		BindingUtils.bindProperty(dataBinder, "selectedIndex", dropdown, "selectedIndex", false);

		container.addElement(label);
		container.addElement(dropdown);
	}

	private function invalidateContainer(event:Event = null):void {
		setWidth(container, containerWidth.selectedValue);
		setHeight(container, containerHeight.selectedValue);
	}

	private function invalidateComponent(event:Event = null):void {
		setWidth(component, componentWidth.selectedValue);
		setHeight(component, componentHeight.selectedValue);
	}

	private function invalidateContents(event:Event = null):void {
		component.hsize.overSizePolicy = hOver.selectedValue;
		component.hsize.underSizePolicy = hUnder.selectedValue;
		component.hsize.align = hAlign.selectedValue;

		component.vsize.overSizePolicy = vOver.selectedValue;
		component.vsize.underSizePolicy = vUnder.selectedValue;
		component.vsize.align = vAlign.selectedValue;

		component.invalidateProperties();
	}

	private static function setWidth(element:UIComponent, value:*):void {
		if (isNaN(value)) {
			var str:String = String(value);
			element.width = NaN;
			element.percentWidth = Number(str.substr(0, str.length - 1));
		} else {
			element.width = value;
		}
	}

	private static function setHeight(element:UIComponent, value:*):void {
		if (isNaN(value)) {
			var str:String = String(value);
			element.height = NaN;
			element.percentHeight = Number(str.substr(0, str.length - 1));
		} else {
			element.height = value;
		}
	}
}
}

import flash.display.Graphics;

import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.utils.StringUtil;

import spark.components.Group;

import ssen.components.base.sizeHelpers.ComponentSize2;
import ssen.components.base.sizeHelpers.LinearPoint;
import ssen.datakit.binders.SelectionDataBinder;
import ssen.text.HtmlRichText;

use namespace mx_internal;

class Container extends Group {
	internal var component:Component;

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		const stroke:int = 8;
		const g:Graphics = graphics;
		g.clear();
		g.beginFill(0xcccccc, 0.2);
		g.drawRect(-stroke, -stroke, unscaledWidth + (stroke * 2), unscaledHeight + (stroke * 2));
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.endFill();
	}
}

class Component extends UIComponent {
	internal var contentsWidth:SelectionDataBinder;
	internal var contentsHeight:SelectionDataBinder;
	internal var contentsMinWidth:SelectionDataBinder;
	internal var contentsMinHeight:SelectionDataBinder;

	internal var hsize:ComponentSize2;
	internal var vsize:ComponentSize2;

	private var label:HtmlRichText;

	public function Component() {
		// constructor 에서 기본 Size Policy를 정해준다
		//		hsize = new ComponentSize("resize", "resize");
		label = new HtmlRichText;
		addChild(label);
	}

	override public function set explicitMaxWidth(value:Number):void {
		hsize.userExplicitMaxSize = value;
		if (hsize.canSkipSetExplicitMaxSize()) return;
		super.explicitMaxWidth = value;
	}

	override public function set explicitMinWidth(value:Number):void {
		hsize.userExplicitMinSize = value;
		if (hsize.canSkipSetExplicitMinSize()) return;
		super.explicitMinWidth = value;
	}

	override public function set explicitMaxHeight(value:Number):void {
		vsize.userExplicitMaxSize = value;
		if (vsize.canSkipSetExplicitMaxSize()) return;
		super.explicitMaxHeight = value;
	}

	override public function set explicitMinHeight(value:Number):void {
		vsize.userExplicitMinSize = value;
		if (vsize.canSkipSetExplicitMinSize()) return;
		super.explicitMinHeight = value;
	}

	override protected function commitProperties():void {
		//		trace("Component.commitProperties()");

		super.commitProperties();
		// content size 확정 구간
		// commit properties 에서 content의 계산된 size를 입력해준다
		hsize.commitProperties(contentsWidth.selectedValue, contentsMinWidth.selectedValue);
		super.explicitMaxWidth = hsize.explicitMaxSize;
		super.explicitMinWidth = hsize.explicitMinSize;

		vsize.commitProperties(contentsHeight.selectedValue, contentsMinHeight.selectedValue);
		super.explicitMaxHeight = vsize.explicitMaxSize;
		super.explicitMinHeight = vsize.explicitMinSize;

		invalidateSize();
		invalidateDisplayList();
	}

	override protected function measure():void {
		super.measure();
		// measure size 확정 구간
		// measure 상황이 되고, explicit size가 없으면 measure size 에 content size를 넣어준다
		if (isNaN(explicitWidth)) measuredWidth = hsize.contentSize;
		if (isNaN(explicitHeight)) measuredHeight = vsize.contentSize;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		// draw component
		var stroke:int = 4;
		const g:Graphics = graphics;
		g.clear();
		g.beginFill(0x7B81E4, 0.4);
		g.drawRect(-stroke, -stroke, unscaledWidth + (stroke * 2), unscaledHeight + (stroke * 2));
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.endFill();

		// draw contents
		var hRenderPoint:LinearPoint = hsize.getLayoutPoint(unscaledWidth);
		var vRenderPoint:LinearPoint = vsize.getLayoutPoint(unscaledHeight);

		stroke = 1;
		g.lineStyle(1);
		g.beginFill(0, 0.1);
		g.drawRect(hRenderPoint.p - stroke
				, vRenderPoint.p - stroke
				, hRenderPoint.size + (stroke * 2)
				, vRenderPoint.size + (stroke * 2)
		);
		g.drawRect(hRenderPoint.p
				, vRenderPoint.p
				, hRenderPoint.size
				, vRenderPoint.size
		);
		g.endFill();
		g.lineStyle();

		label.x = hRenderPoint.p + 10;
		label.y = vRenderPoint.p + 10;
		label.width = hRenderPoint.size - 20;
		label.height = vRenderPoint.size - 20;
		label.text = StringUtil.substitute([
					'w({0}), cw({1}/{2}) <br/>--> {3}',
					'h({4}), ch({5}/{6}) <br/>--> {7}',
					'h({8}/{9}) + {10} <br/>--> {11}',
					'v({12}/{13}) + {14} <br/>--> {15}'
				].join('<br/>')
				, width, hsize.contentSize, hsize.contentMinSize, unscaledWidth
				, height, vsize.contentSize, vsize.contentMinSize, unscaledHeight
				, hsize.underSizePolicy, hsize.overSizePolicy, sizeString(width, hsize.contentSize), getCurrentPolicy(width, hsize)
				, vsize.underSizePolicy, vsize.overSizePolicy, sizeString(height, vsize.contentSize), getCurrentPolicy(height, vsize)
		);

		trace("---------------------------------------------------------");
		trace("size", width, height);
		trace("unscaled", unscaledWidth, unscaledHeight);
		trace("measured", measuredWidth, measuredHeight);
		trace("measured min", measuredMinWidth, measuredMinHeight);
		trace("explicit", explicitWidth, explicitHeight);
		trace("explicit min", explicitMinWidth, explicitMinHeight);
		trace("explicit max", explicitMaxWidth, explicitMaxHeight);
		trace("content size", hsize.contentSize);
		trace("content min size", hsize.contentMinSize);
		//		trace();
		//		trace();
	}

	private static function sizeString(unscaledSize:Number, contentSize:Number):String {
		if (unscaledSize > contentSize) {
			return "over";
		} else if (unscaledSize < contentSize) {
			return "under";
		}
		return "equal";
	}

	public static function getCurrentPolicy(unscaledSize:Number, size:ComponentSize2):String {
		if (unscaledSize > size.contentSize) {
			return size.overSizePolicy;
		} else if (unscaledSize < size.contentSize) {
			return size.underSizePolicy;
		}
		return "none";
	}
}
