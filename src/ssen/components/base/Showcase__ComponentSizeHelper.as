package ssen.components.base {
import flash.events.Event;

import mx.binding.utils.BindingUtils;
import mx.core.IVisualElementContainer;
import mx.core.UIComponent;

import org.osmf.layout.VerticalAlign;

import spark.components.DropDownList;
import spark.components.HGroup;
import spark.components.Label;
import spark.components.SkinnableContainer;
import spark.components.VGroup;

import ssen.datakit.binders.SelectionDataBinder;

public class Showcase__ComponentSizeHelper extends SkinnableContainer {
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

	public function Showcase__ComponentSizeHelper() {
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
		// printer
		//---------------------------------------------
		var printer:Printer = new Printer;
		printer.x = 10;
		printer.y = 100;
		addElement(printer);

		//---------------------------------------------
		// initial container and component
		//---------------------------------------------
		component = new Component;
		component.printer = printer;
		component.hsize = new ComponentSizeHelper(hOver.selectedValue, hUnder.selectedValue, hAlign.selectedValue);
		component.vsize = new ComponentSizeHelper(vOver.selectedValue, vUnder.selectedValue, vAlign.selectedValue);
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
		trace("Showcase__ComponentSize2.invalidateContainer()");
		setWidth(container, containerWidth.selectedValue);
		setHeight(container, containerHeight.selectedValue);
	}

	private function invalidateComponent(event:Event = null):void {
		trace("Showcase__ComponentSize2.invalidateComponent()");
		setWidth(component, componentWidth.selectedValue);
		setHeight(component, componentHeight.selectedValue);
	}

	private function invalidateContents(event:Event = null):void {
		trace("Showcase__ComponentSize2.invalidateContents()");
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
import mx.formatters.DateFormatter;
import mx.utils.StringUtil;

import spark.components.SkinnableContainer;
import spark.skins.spark.SkinnableContainerSkin;

import ssen.components.base.ComponentSizeHelper;
import ssen.datakit.binders.SelectionDataBinder;
import ssen.drawing.LinearPoint;
import ssen.text.HtmlRichText;

use namespace mx_internal;

class Size {
	public var w:Number;
	public var h:Number;

	public function Size(w:Number, h:Number) {
		this.w = w;
		this.h = h;
	}

	public function toString(title:String):String {
		return StringUtil.substitute('{0} : w={1} h={2}', title, w, h);
	}
}

class Printer extends HtmlRichText {
	public var sizeSize:Size;
	public var unscaledSize:Size;
	public var measuredSize:Size;
	public var measuredMinSize:Size;
	public var explicitSize:Size;
	public var explicitMinSize:Size;
	public var explicitMaxSize:Size;
	public var contentSize:Size;
	public var contentMinSize:Size;

	private var dateFormatter:DateFormatter;

	public function Printer() {
		dateFormatter = new DateFormatter;
		dateFormatter.formatString = "HH:NN:SS";
	}

	public function update(lines:Array):void {
		var strs:Array = [];

		strs.push([
			sizeSize.toString("size"),
			unscaledSize.toString("unscaled"),
			measuredSize.toString("measured"),
			measuredMinSize.toString("measured min"),
			explicitSize.toString("explicit"),
			explicitMinSize.toString("explicit min"),
			explicitMaxSize.toString("explicit max"),
			contentSize.toString("content"),
			contentMinSize.toString("content min")
		].join('<br/>'));

		strs.push(lines.join('<br/>'));

		strs.push([
			"Last update : " + dateFormatter.format(new Date)
		]);

		text = strs.join('<br/>----------------------------<br/>');
	}
}

class Container extends SkinnableContainer {
	internal var component:Component;

	public function Container() {
		setStyle("skinClass", SkinnableContainerSkin);
	}

	override public function invalidateDisplayList():void {
		trace("+ Container.invalidateDisplayList()");
		super.invalidateDisplayList();
	}

	override public function invalidateProperties():void {
		trace("+ Container.invalidateProperties()");
		super.invalidateProperties();
	}

	override public function invalidateSize():void {
		trace("+ Container.invalidateSize()");
		super.invalidateSize();
	}

	override protected function invalidateParentSizeAndDisplayList():void {
		trace("+ Container.invalidateParentSizeAndDisplayList()");
		super.invalidateParentSizeAndDisplayList();
	}

	override protected function commitProperties():void {
		trace("- Container.commitProperties()");
		super.commitProperties();
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		trace("- Container.updateDisplayList()");
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

	internal var hsize:ComponentSizeHelper;
	internal var vsize:ComponentSizeHelper;

	//	private var label:HtmlRichText;
	internal var printer:Printer;

	public function Component() {
		// constructor 에서 기본 Size Policy를 정해준다
		//		hsize = new ComponentSize("resize", "resize");
		//		label = new HtmlRichText;
		//		addChild(label);
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

	override public function invalidateDisplayList():void {
		trace("++ Component.invalidateDisplayList()");
		super.invalidateDisplayList();
	}

	override public function invalidateProperties():void {
		trace("++ Component.invalidateProperties()");
		super.invalidateProperties();
	}

	override public function invalidateSize():void {
		trace("++ Component.invalidateSize()");
		super.invalidateSize();
	}

	override protected function invalidateParentSizeAndDisplayList():void {
		trace("++ Component.invalidateParentSizeAndDisplayList()");
		super.invalidateParentSizeAndDisplayList();
	}

	override protected function commitProperties():void {
		trace("-- Component.commitProperties()");
		super.commitProperties();
		// content size 확정 구간
		// commit properties 에서 content의 계산된 size를 입력해준다
		hsize.commitProperties(contentsWidth.selectedValue, contentsMinWidth.selectedValue);
		super.explicitMaxWidth = hsize.explicitMaxSize;
		super.explicitMinWidth = hsize.explicitMinSize;

		vsize.commitProperties(contentsHeight.selectedValue, contentsMinHeight.selectedValue);
		super.explicitMaxHeight = vsize.explicitMaxSize;
		super.explicitMinHeight = vsize.explicitMinSize;

		printer.contentSize = new Size(hsize.contentSize, vsize.contentSize);
		printer.contentMinSize = new Size(hsize.contentMinSize, vsize.contentMinSize);

		invalidateSize();
		invalidateDisplayList();
	}

	override mx_internal function measureSizes():Boolean {
		trace("-- Component.measureSizes()", explicitWidth, explicitHeight);
		var result:Boolean = super.mx_internal::measureSizes();
		printer.explicitSize = new Size(explicitWidth, explicitHeight);
		printer.explicitMinSize = new Size(explicitMinWidth, explicitMinHeight);
		printer.explicitMaxSize = new Size(explicitMaxWidth, explicitMaxHeight);
		printer.measuredSize = new Size(measuredWidth, measuredHeight);
		printer.measuredMinSize = new Size(measuredMinWidth, measuredMinHeight);
		return result;
	}

	override protected function measure():void {
		trace("-- Component.measure()");
		super.measure();
		// measure size 확정 구간
		// measure 상황이 되고, explicit size가 없으면 measure size 에 content size를 넣어준다
		if (isNaN(explicitWidth)) measuredWidth = hsize.contentSize;
		if (isNaN(explicitHeight)) measuredHeight = vsize.contentSize;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		trace("-- Component.updateDisplayList()");
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

		printer.sizeSize = new Size(width, height);
		printer.unscaledSize = new Size(unscaledWidth, unscaledHeight);
		printer.update([
			StringUtil.substitute('h({0} / {1})', hsize.underSizePolicy, hsize.overSizePolicy),
			StringUtil.substitute('v({0} / {1})', vsize.underSizePolicy, vsize.overSizePolicy),
			StringUtil.substitute('h content size is {0} than unscaled width', (hsize.contentSize === unscaledWidth) ? "equal" : (hsize.contentSize > unscaledWidth) ? "bigger" : "smaller"),
			StringUtil.substitute('v content size is {0} than unscaled height', (vsize.contentSize === unscaledHeight) ? "equal" : (vsize.contentSize > unscaledHeight) ? "bigger" : "smaller")
		]);
	}

	private static function sizeString(unscaledSize:Number, contentSize:Number):String {
		if (unscaledSize > contentSize) {
			return "over";
		} else if (unscaledSize < contentSize) {
			return "under";
		}
		return "equal";
	}

	public static function getCurrentPolicy(unscaledSize:Number, size:ComponentSizeHelper):String {
		if (unscaledSize > size.contentSize) {
			return size.overSizePolicy;
		} else if (unscaledSize < size.contentSize) {
			return size.underSizePolicy;
		}
		return "none";
	}
}
