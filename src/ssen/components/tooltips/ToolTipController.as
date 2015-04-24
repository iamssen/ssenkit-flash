package ssen.components.tooltips {
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;

import mx.core.FlexGlobals;
import mx.core.IFactory;
import mx.managers.PopUpManager;

import ssen.common.IDisposable;

public class ToolTipController extends EventDispatcher implements IDisposable {
	//==========================================================================================
	// state
	//==========================================================================================
	private var state:int = 0;
	private static const BLANK:int = 0;
	private static const UNSTAGE:int = 1;
	private static const INIT:int = 2;
	private static const HOVER:int = 3;

	//==========================================================================================
	// instance
	//==========================================================================================
	//---------------------------------------------
	// host
	//---------------------------------------------
	private var _host:IToolTipHostElement;

	/** host */
	public function get host():IToolTipHostElement {
		return _host;
	}

	public function set host(value:IToolTipHostElement):void {
		if (_host) dispose();
		_host = value;
		initHost();
	}

	public var toolTipRenderer:IFactory;

	private var toolTip:IToolTipElement;

	//==========================================================================================
	// life cycle
	//==========================================================================================
	private function initHost():void {
		if (_host.stage) {
			initEvents();
		} else {
			_host.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);

			state = UNSTAGE;
		}
	}

	private function addedToStage(event:Event):void {
		_host.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		initEvents();
	}

	private function initEvents():void {
		_host.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
		_host.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
		_host.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);

		state = INIT;
	}

	private function removedFromStageHandler(event:Event):void {
		_host.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
		_host.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		_host.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);

		state = BLANK;
	}

	private function rollOutHandler(event:MouseEvent):void {
		clearRenderer();
		state = INIT;
	}

	private function clearRenderer():void {
		if (toolTip) {
			toolTip.dispose();
			PopUpManager.removePopUp(toolTip);
			toolTip = null;
		}
	}

	private function rollOverHandler(event:MouseEvent):void {
		clearRenderer();

		toolTip = toolTipRenderer.newInstance();
		toolTip.render(_host);

		PopUpManager.addPopUp(toolTip, FlexGlobals.topLevelApplication as DisplayObjectContainer);

		state = HOVER;
	}

	public function dispose():void {
		switch (state) {
			case UNSTAGE:
				_host.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
				break;
			case INIT:
				_host.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				_host.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				_host.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
				break;
			case HOVER:
				clearRenderer();

				_host.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				_host.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				_host.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
				break;
		}

		state = BLANK;
	}
}
}
