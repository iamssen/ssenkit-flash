package ssen.components.base.sizeHelpers {
import flash.events.Event;

import mx.binding.utils.BindingUtils;
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;

import org.osmf.layout.VerticalAlign;

import spark.components.DropDownList;
import spark.components.Group;
import spark.components.HGroup;
import spark.components.Label;
import spark.components.VGroup;

import ssen.datakit.binders.SelectionDataBinder;

public class Showcase__ComponentSize extends Group {
	// invalidate container
	private var containerWidth:SelectionDataBinder = new SelectionDataBinder([150, 200, 350, 500, 800, "30%", "50%", "70%", "100%"], 1, invalidateContainer);
	private var containerHeight:SelectionDataBinder = new SelectionDataBinder([150, 200, 350, 500, 800, "30%", "50%", "70%", "100%"], 1, invalidateContainer);

	// invalidte components
	private var componentWidth:SelectionDataBinder = new SelectionDataBinder([50, 200, 300, 500, "30%", "50%", "70%", "100%"], 1, invalidateComponent);
	private var componentHeight:SelectionDataBinder = new SelectionDataBinder([50, 200, 300, 500, "30%", "50%", "70%", "100%"], 1, invalidateComponent);

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

	public function Showcase__ComponentSize() {
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
		component.hsize = new ComponentSize(hOver.selectedValue, hUnder.selectedValue, hAlign.selectedValue);
		component.vsize = new ComponentSize(vOver.selectedValue, vUnder.selectedValue, vAlign.selectedValue);
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

	private static function setWidth(element:IVisualElement, value:*):void {
		if (isNaN(value)) {
			var str:String = String(value);
			element.percentWidth = Number(str.substr(0, str.length - 1));
		} else {
			element.width = value;
		}
	}

	private static function setHeight(element:IVisualElement, value:*):void {
		if (isNaN(value)) {
			var str:String = String(value);
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
import mx.managers.ISystemManager;
import mx.utils.StringUtil;

import spark.components.Group;

import ssen.components.base.sizeHelpers.ComponentSize;
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
		g.beginFill(0xcccccc);
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

	internal var hsize:ComponentSize;
	internal var vsize:ComponentSize;

	private var label:HtmlRichText;

	public function Component() {
		// constructor 에서 기본 Size Policy를 정해준다
		//		hsize = new ComponentSize("resize", "resize");
		label = new HtmlRichText;
		addChild(label);
	}

	override protected function commitProperties():void {
		//		trace("Component.commitProperties()");

		super.commitProperties();
		// content size 확정 구간
		// commit properties 에서 content의 계산된 size를 입력해준다
		hsize.commitProperties(contentsWidth.selectedValue, contentsMinWidth.selectedValue);
		vsize.commitProperties(contentsHeight.selectedValue, contentsMinHeight.selectedValue);

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

	override public function validateDisplayList():void {
		oldLayoutDirection = layoutDirection;
		if (invalidateDisplayListFlag) {
			// actual size 변조 구간
			// cut 이거나 scroll 이 설정되어 있는 경우, actual size를 변조한다
			trace("Component.validateDisplayList()", width, height);

			invalidateDisplayListFlag = false;

			var sm:ISystemManager = parent as ISystemManager;
			if (sm) {
				if (sm.isProxy || (sm == systemManager.topLevelSystemManager && sm.document != this)) {
					setActualSize(hsize.computeSize(getExplicitOrMeasuredWidth()), vsize.computeSize(getExplicitOrMeasuredHeight()));
				}
			}

			var unscaledWidth:Number = hsize.computeSize(width);
			var unscaledHeight:Number = vsize.computeSize(height);

			label.text = StringUtil.substitute([
						'w({0}), cw({1}/{2}) --> {3}',
						'h({4}), ch({5}/{6}) --> {7}',
						'h({8}/{9}) + {10} --> {11}',
						'v({12}/{13}) + {14} --> {15}'
					].join('<br/>')
					, width, hsize.contentSize, hsize.contentMinSize, unscaledWidth
					, height, vsize.contentSize, vsize.contentMinSize, unscaledHeight
					, hsize.underSizePolicy, hsize.overSizePolicy, sizeString(width, hsize.contentSize), getCurrentPolicy(width, hsize)
					, vsize.underSizePolicy, vsize.overSizePolicy, sizeString(height, vsize.contentSize), getCurrentPolicy(height, vsize)
			);

			setActualSize(unscaledWidth, unscaledHeight);

			trace("Component.validateDisplayList()", UIComponent(parent).invalidatePropertiesFlag);

			if (!invalidateDisplayListFlag) updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}

	//	override public function setActualSize(w:Number, h:Number):void {
	//
	//		// actual size 변조 구간
	//		// cut 이거나 scroll 이 설정되어 있는 경우, actual size를 변조한다
	//		var w2:Number = hsize.getActualSize(w);
	//		var h2:Number = vsize.getActualSize(h);
	//
	//		trace("Component.setActualSize()", w, h, w2, h2);
	//
	//		//		label.text = [
	//		//			'h size: ' + w + "/" + hsize.contentSize + " --> " + w2,
	//		//			'v size: ' + h + "/" + vsize.contentSize + " --> " + h2,
	//		//
	//		//			'h size state: ' + sizeString(w, hsize.contentSize),
	//		//			'v size state: ' + sizeString(h, vsize.contentSize),
	//		//
	//		//			'h policy: ' + hsize.getCurrentPolicy(w),
	//		//			'v policy: ' + vsize.getCurrentPolicy(h)
	//		//		].join('<br/>');
	//
	//		super.setActualSize(w2, h2);
	//	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		trace("Component.updateDisplayList()", width, unscaledWidth, height, unscaledHeight);

		super.updateDisplayList(unscaledWidth, unscaledHeight);

		// draw component
		var stroke:int = 4;
		const g:Graphics = graphics;
		g.clear();
		g.beginFill(0x7B81E4);
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

		//		trace("size", width, height);
		//		trace("unscaled", unscaledWidth, unscaledHeight);
		//		trace("measured", measuredWidth, measuredHeight);
		//		trace("measured min", measuredMinWidth, measuredMinHeight);
		//		trace("explicit", explicitWidth, explicitHeight);
		//		trace("explicit min", explicitMinWidth, explicitMinHeight);
		//		trace("explicit max", explicitMaxWidth, explicitMaxHeight);
		//		trace("content size", hsize.contentSize);
		//		trace("content min size", hsize.contentMinSize);
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

	public static function getCurrentPolicy(unscaledSize:Number, size:ComponentSize):String {
		if (unscaledSize > size.contentSize) {
			return size.overSizePolicy;
		} else if (unscaledSize < size.contentSize) {
			return size.underSizePolicy;
		}
		return "none";
	}
}
