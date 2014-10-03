package ssen.components.alerts {

import com.greensock.TweenLite;
import com.greensock.easing.Quad;

import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.MouseEvent;

import mx.core.FlexGlobals;
import mx.managers.PopUpManager;

import spark.components.supportClasses.SkinnableComponent;

public class AlertBase extends SkinnableComponent {
	//==========================================================================================
	// skin parts
	//==========================================================================================
	[SkinPart]
	public var moveArea:InteractiveObject;

	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// style
	//----------------------------------------------------------------
	public var openDuration:Number = 0.5;
	public var openEase:Function = Quad.easeOut;

	public var closeDuration:Number = 0.5;
	public var closeEase:Function = Quad.easeOut;

	//==========================================================================================
	// methods
	//==========================================================================================
	//----------------------------------------------------------------
	// open
	//----------------------------------------------------------------
	final public function open():void {
		PopUpManager.addPopUp(this, FlexGlobals.topLevelApplication as DisplayObjectContainer, true);
		validateNow();
		x = (stage.stageWidth - width) / 2;
		y = (stage.stageHeight - height) / 2;
		addPopup();
	}

	protected function addPopup():void {
		alpha = 0;
		TweenLite.to(this, openDuration, {alpha: 1, ease: openEase});
	}

	//----------------------------------------------------------------
	// close
	//----------------------------------------------------------------
	final public function close(...args:Array):void {
		applyCallback(args);
		closePopup(removePopup);
	}

	private function removePopup():void {
		PopUpManager.removePopUp(this);
	}

	protected function closePopup(removePopup:Function):void {
		if (closeDuration > 0) {
			TweenLite.to(this, closeDuration, {alpha: 0, ease: closeEase, onComplete: removePopup});
		} else {
			removePopup();
		}
	}

	protected function applyCallback(args:Array = null):void {
	}

	//==========================================================================================
	// skin
	//==========================================================================================
	/** @private */
	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance === moveArea) {
			moveArea.addEventListener(MouseEvent.MOUSE_DOWN, moveStartHandler, false, 0, true);
		}
	}

	/** @private */
	override protected function partRemoved(partName:String, instance:Object):void {
		super.partRemoved(partName, instance);

		if (instance === moveArea) {
			moveArea.removeEventListener(MouseEvent.MOUSE_DOWN, moveStartHandler);
		}
	}

	//==========================================================================================
	// snap and drag
	//==========================================================================================
	private var moveStartMouseX:int;
	private var moveStartMouseY:int;
	private var moveStartWindowX:int;
	private var moveStartWindowY:int;

	private function moveStartHandler(event:MouseEvent):void {
		moveArea.removeEventListener(MouseEvent.MOUSE_DOWN, moveStartHandler);

		moveStartMouseX = event.stageX;
		moveStartMouseY = event.stageY;
		moveStartWindowX = x;
		moveStartWindowY = y;

		stage.addEventListener(MouseEvent.MOUSE_UP, moveEndHandler);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
	}

	private function moveHandler(event:MouseEvent):void {
		moveContainer(event);
	}

	private function moveEndHandler(event:MouseEvent):void {
		moveContainer(event);

		stage.removeEventListener(MouseEvent.MOUSE_UP, moveEndHandler);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);

		moveArea.addEventListener(MouseEvent.MOUSE_DOWN, moveStartHandler, false, 0, true);
	}

	private function moveContainer(event:MouseEvent):void {
		var dx:int = event.stageX - moveStartMouseX;
		var dy:int = event.stageY - moveStartMouseY;

		var tx:int = moveStartWindowX + dx;
		var ty:int = moveStartWindowY + dy;

		x = tx;
		y = ty;
	}
}
}
