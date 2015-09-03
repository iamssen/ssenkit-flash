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
		var containerOptions:HGroup = new HGroup;
		containerOptions.verticalAlign = VerticalAlign.MIDDLE;
		addDropdownList("container w", containerWidth, containerOptions);
		addDropdownList("h", containerHeight, containerOptions);
		addDropdownList("component w", componentWidth, containerOptions);
		addDropdownList("h", componentHeight, containerOptions);

		var contentsOptions:HGroup = new HGroup;
		contentsOptions.verticalAlign = VerticalAlign.MIDDLE;
		addDropdownList("contents w", contentsWidth, contentsOptions);
		addDropdownList("h", contentsHeight, contentsOptions);
		addDropdownList("contents min w", contentsMinWidth, contentsOptions);
		addDropdownList("h", contentsMinHeight, contentsOptions);

		var sizeOptions:HGroup = new HGroup;
		sizeOptions.verticalAlign = VerticalAlign.MIDDLE;
		addDropdownList("vertical over", vOver, sizeOptions);
		addDropdownList("under", vUnder, sizeOptions);
		addDropdownList("align", vAlign, sizeOptions);
		addDropdownList("horizontal over", hOver, sizeOptions);
		addDropdownList("under", hUnder, sizeOptions);
		addDropdownList("align", hAlign, sizeOptions);

		var options:VGroup = new VGroup;
		options.left = 10;
		options.right = 10;
		options.top = 10;
		options.addElement(containerOptions);
		options.addElement(contentsOptions);
		options.addElement(sizeOptions);
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

import spark.components.Group;

import ssen.components.base.sizeHelpers.ComponentSize;
import ssen.datakit.binders.SelectionDataBinder;

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

	public function Component() {
		// constructor 에서 기본 Size Policy를 정해준다
		//		hsize = new ComponentSize("resize", "resize");
	}

	override protected function commitProperties():void {
		super.commitProperties();
		// content size 확정 구간
		// commit properties 에서 content의 계산된 size를 입력해준다
		hsize.commitProperties(contentsWidth.selectedValue, contentsMinWidth.selectedValue);
		vsize.commitProperties(contentsHeight.selectedValue, contentsMinHeight.selectedValue);
	}

	override protected function measure():void {
		super.measure();
		// measure size 확정 구간
		// measure 상황이 되고, explicit size가 없으면 measure size 에 content size를 넣어준다
		if (isNaN(explicitWidth)) measuredWidth = hsize.contentSize;
		if (isNaN(explicitHeight)) measuredHeight = vsize.contentSize;
	}

	override public function setActualSize(w:Number, h:Number):void {
		// actual size 변조 구간
		// cut 이거나 scroll 이 설정되어 있는 경우, actual size를 변조한다
		w = hsize.getActualSize(w);
		h = vsize.getActualSize(h);
		super.setActualSize(w, h);
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		// draw component
		var stroke:int = 4;
		const g:Graphics = graphics;
		g.clear();
		g.beginFill(0x7B81E4);
		g.drawRect(-stroke, -stroke, unscaledWidth + (stroke * 2), unscaledHeight + (stroke * 2));
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.endFill();

		//		var computedWidth:Number = hsize.getActualSize()
		//		stroke = 1;
		//		g.beginFill(0);
		//		g.drawRect(-stroke, -stroke, unscaledWidth + (stroke * 2), unscaledHeight + (stroke * 2));
		//		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		//		g.endFill();

		trace("size", width, height);
		trace("unscaled", unscaledWidth, unscaledHeight);
		trace("measured", measuredWidth, measuredHeight);
		trace("measured min", measuredMinWidth, measuredMinHeight);
		trace("explicit", explicitWidth, explicitHeight);
		trace("explicit min", explicitMinWidth, explicitMinHeight);
		trace("explicit max", explicitMaxWidth, explicitMaxHeight);
		trace("content size", hsize.contentSize);
		trace("content min size", hsize.contentMinSize);
		trace();
		trace();
	}
}
