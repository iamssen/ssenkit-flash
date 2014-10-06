package ssen.devkit {
import flash.net.SharedObject;

import mx.core.IVisualElement;

import org.apache.flex.collections.VectorCollection;

import spark.components.DropDownList;
import spark.components.Group;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.IndexChangeEvent;

[DefaultProperty("showcase")]

public class ShowcaseContainer extends SkinnableComponent {

	//==========================================================================================
	// skin parts
	//==========================================================================================
	[SkinPart]
	public var dropdownList:DropDownList;

	[SkinPart]
	public var container:Group;

	//==========================================================================================
	// settings
	//==========================================================================================
	//---------------------------------------------
	// showcase
	//---------------------------------------------
	private var _showcase:Vector.<Showcase>;

	/** showcase */
	public function get showcase():Vector.<Showcase> {
		return _showcase;
	}

	public function set showcase(value:Vector.<Showcase>):void {
		_showcase = value;

		if (dropdownList) {
			dropdownList.dataProvider = new VectorCollection(value);
		}
	}

	//==========================================================================================
	// ...
	//==========================================================================================
	private function loadShowcase(index:int):void {
		var Showcase:Class = _showcase[index].type;
		var showcase:IVisualElement = new Showcase;

		showcase.percentWidth = 100;
		showcase.percentHeight = 100;

		container.removeAllElements();
		container.addElement(showcase);

		setLastIndex(index);
	}

	//==========================================================================================
	// shared object
	//==========================================================================================
	private function getLastIndex():int {
		if (getSharedData()["lastIndex"] !== undefined) {
			var index:int = getSharedData()["lastIndex"];
			if (_showcase && index < _showcase.length) {
				return index;
			}
		}

		setLastIndex(0);
		return 0;
	}

	private static function setLastIndex(index:int):void {
		getSharedData()["lastIndex"] = index;
	}

	private static function getSharedData():Object {
		return SharedObject.getLocal("showcase").data;
	}

	//==========================================================================================
	// init
	//==========================================================================================
	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance === dropdownList) {
			dropdownList.addEventListener(IndexChangeEvent.CHANGE, indexChangedHandler);

			if (_showcase) {
				dropdownList.dataProvider = new VectorCollection(_showcase);
				dropdownList.selectedIndex = getLastIndex();
			}
		} else if (instance === container) {
			if (_showcase) {
				loadShowcase(getLastIndex());
			}
		}
	}

	override protected function partRemoved(partName:String, instance:Object):void {
		super.partRemoved(partName, instance);
	}

	public function ShowcaseContainer() {
		setStyle("skinClass", ShowcaseContainerSkin);
		percentWidth = 100;
		percentHeight = 100;
	}

	//==========================================================================================
	// event handler
	//==========================================================================================
	private function indexChangedHandler(event:IndexChangeEvent):void {
		if (event.newIndex < 0) return;
		loadShowcase(event.newIndex);
	}

}
}
