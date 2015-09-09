package ssen.components.dropdownAnchor {

import com.greensock.TweenLite;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.core.ClassFactory;

import mx.core.FlexGlobals;
import mx.core.IFactory;
import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
import mx.managers.PopUpManager;

import spark.components.Application;
import spark.components.PopUpAnchor;
import spark.components.SkinnableContainer;
import spark.components.SkinnablePopUpContainer;
import spark.components.supportClasses.SkinnableComponent;

import ssen.common.IDisposable;
import ssen.common.NullUtils;
import ssen.components.dropdownAnchor.snippets.DropDownAnchorSkin;

[Event(name="open", type="flash.events.Event")]
[Event(name="close", type="flash.events.Event")]

[Style(name="popupOpenDuration", inherit="no", type="uint", format="Time")]
[Style(name="popupCloseDuration", inherit="no", type="uint", format="Time")]

[SkinState("normal")]
[SkinState("disabled")]

[DefaultProperty("content")]

public class DropDownAnchor extends SkinnableComponent implements IDisposable {
	//==========================================================================================
	// skin parts
	//==========================================================================================
	[SkinPart(required="true")]
	public var openButton:SkinnableComponent;

	[SkinPart(required="true")]
	public var popupAnchor:PopUpAnchor;

	[SkinPart(required="true")]
	public var popupAnchorContainer:SkinnableContainer;

	[SkinPart(required="true")]
	public var popupContainerSkin:IFactory;

	//==========================================================================================
	// properties
	//==========================================================================================
	[Bindable]
	public var label:String;

	//---------------------------------------------
	// content
	//---------------------------------------------
	private var _content:UIComponent;

	/** content */
	[Bindable]
	public function get content():UIComponent {
		return _content;
	}

	public function set content(value:UIComponent):void {
		var oldValue:UIComponent = _content;
		_content = value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "content", oldValue, _content));
		}
		invalidateSkinState();
	}

	//==========================================================================================
	// construct
	//==========================================================================================
	//	public function DropDownAnchor() {
	//		setStyle("skinClass", DropDownAnchorSkin);
	//	}

	//	[Bindable(style="true")]
	//	override public function getStyle(styleProp:String):* {
	//		var value:* = super.getStyle(styleProp);
	//
	//		if (!value) {
	//			switch (styleProp) {
	//				case "skinClass":
	//					return DropDownAnchorSkin;
	//				case "skinFactory":
	//					return new ClassFactory(DropDownAnchorSkin);
	//			}
	//		}
	//
	//		return value;
	//	}


	override protected function createChildren():void {
		if (!getStyle("skinClass") && !getStyle("skinFactory")) setStyle("skinClass", DropDownAnchorSkin);
		super.createChildren();
	}

	//==========================================================================================
	// public api
	//==========================================================================================
	private var closed:Boolean = true;
	private var popupContainer:SkinnablePopUpContainer;

	public function dispose():void {
		detachSkin();
	}

	//---------------------------------------------
	// open
	//---------------------------------------------
	public function open():void {
		if (!closed)
			return;

		var popupOpenDuration:int = NullUtils.nullTo(getStyle("popupOpenDuration"), 300);
		var openDuration:Number = popupOpenDuration / 1000;
		var hasTween:Boolean = popupOpenDuration > 0;

		if (openWithPopupAnchor()) {
			popupAnchorContainer.addElement(content);
			popupAnchor.displayPopUp = true;

			if (hasTween) {
				popupAnchorContainer.alpha = 0;
				TweenLite.to(popupAnchorContainer, openDuration, {
					alpha     : 1,
					onComplete: popupAnchorContainerCompleteOpenTween
				});
			} else {
				popupAnchorContainer.alpha = 1;
				callLater(popupAnchorContainerCompleteOpenTween);
			}
		} else {
			var app:Application = FlexGlobals.topLevelApplication as Application;

			popupContainer = new SkinnablePopUpContainer;
			popupContainer.addElement(content);
			popupContainer.open(app, true);
			popupContainer.setStyle("skinFactory", popupContainerSkin);
			PopUpManager.centerPopUp(popupContainer);

			if (hasTween) {
				popupContainer.alpha = 0;
				TweenLite.to(popupContainer, openDuration, {alpha: 1});
			} else {
				popupContainer.alpha = 1;
			}
		}

		closed = false;
		dispatchEvent(new FlexEvent(Event.OPEN));
	}

	private function popupAnchorContainerCompleteOpenTween():void {
		stage.addEventListener(MouseEvent.CLICK, clickStage, false, 0, true);
		stage.addEventListener(Event.RESIZE, resizeStage, false, 0, true);
	}

	//---------------------------------------------
	// open and close event handlers
	//---------------------------------------------
	private function resizeStage(event:Event):void {
		close();
	}

	private function clickStage(event:MouseEvent):void {
		var cx:Number = event.stageX;
		var cy:Number = event.stageY;
		var px:Number = popupAnchor.popUp.x;
		var py:Number = popupAnchor.popUp.y;
		var pw:Number = popupAnchor.popUp.width;
		var ph:Number = popupAnchor.popUp.height;

		if (cx < px || cx > px + pw || cy < py || cy > py + ph) {
			close();
		}
	}

	//---------------------------------------------
	// close
	//---------------------------------------------
	public function close():void {
		if (closed)
			return;

		var popupCloseDuration:int = NullUtils.nullTo(getStyle("popupCloseDuration"), 200);
		var closeDuration:Number = popupCloseDuration / 1000;
		var hasTween:Boolean = popupCloseDuration > 0;

		if (popupContainer) {
			if (hasTween) {
				TweenLite.to(popupContainer, closeDuration, {alpha: 0, onComplete: popupContainerCompleteCloseTween});
			} else {
				popupContainerCompleteCloseTween();
			}
		} else {
			if (hasTween) {
				TweenLite.to(popupAnchorContainer, closeDuration, {
					alpha     : 0,
					onComplete: popupAnchorContainerCompleteCloseTween
				});
			} else {
				popupAnchorContainerCompleteCloseTween();
			}

			stage.removeEventListener(Event.RESIZE, resizeStage);
			stage.removeEventListener(MouseEvent.CLICK, clickStage);
		}

		closed = true;
		dispatchEvent(new FlexEvent(Event.CLOSE));
	}

	private function popupContainerCompleteCloseTween():void {
		popupContainer.close();
		popupContainer.removeElement(content);
		popupContainer = null;
	}

	private function popupAnchorContainerCompleteCloseTween():void {
		popupAnchor.displayPopUp = false;
		popupAnchorContainer.removeAllElements();
	}

	//==========================================================================================
	// utils
	//==========================================================================================
	protected function openWithPopupAnchor():Boolean {
		var pos:Point = parent.localToGlobal(new Point(x, y));
		var w:int = width;
		var h:int = height;
		var sw:int = stage.stageWidth;
		var sh:int = stage.stageHeight;

		var verticalSpaceClear:Boolean = pos.y > content.height || sh - pos.y + h > content.height;
		var horizontalSpaceClear:Boolean = sw - pos.x > content.width || pos.x + w > content.width;

		return verticalSpaceClear && horizontalSpaceClear;
	}

	//==========================================================================================
	// skin 
	//==========================================================================================
	override protected function getCurrentSkinState():String {
		return (!enabled || !content) ? "disabled" : "normal";
	}

	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance === openButton) {
			openButton.addEventListener(MouseEvent.CLICK, openAndCloseHandler, false, 0, true);
		}
	}

	override protected function partRemoved(partName:String, instance:Object):void {
		super.partRemoved(partName, instance);

		if (instance === openButton) {
			openButton.removeEventListener(MouseEvent.CLICK, openAndCloseHandler);
		}
	}

	//----------------------------------------------------------------
	// event handlers
	//----------------------------------------------------------------
	private function openAndCloseHandler(event:MouseEvent):void {
		if (closed) {
			open();
		} else {
			close();
		}
	}

}
}
