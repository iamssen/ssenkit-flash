package ssen.flexkit.components.grid.renderers {
import flash.events.IEventDispatcher;

import mx.collections.IList;
import mx.events.PropertyChangeEvent;

public class HierarchicalSumRenderer extends GridRenderer {
	private var prevDatas:Vector.<IEventDispatcher>;

	override protected function draw(hasBeenRecycled:Boolean, dataChanged:Boolean, columnChanged:Boolean, sizeChanged:Boolean):void {
		if (dataChanged || columnChanged) {
			clearDataEvents();
			var children:Array=sumDatas();
			addDataEvents(children);
		}
	}

	override protected function clear(willBeRecycled:Boolean):void {
		if (willBeRecycled) {
			clearDataEvents();
		}
	}

	private function sumDatas():Array {
		if (isGroupData(data)) {
			var sum:Number=0;
			var children:Array=getItems(data);

			var f:int=-1;
			var fmax:int=children.length;
			var dataField:String=column.dataField;

			while (++f < fmax) {
				sum+=children[f][column.dataField];
			}

			data[column.dataField]=sum;
			column.itemToLabel(sum);
			text=(column.formatter) ? column.formatter.format(sum) : sum.toString();

			return children;
		}

		return null;
	}

	private function addDataEvents(datas:Array):void {
		if (!datas) {
			return;
		}

		prevDatas=new Vector.<IEventDispatcher>;

		var f:int=datas.length;
		var data:IEventDispatcher;
		while (--f >= 0) {
			if (datas[f] is IEventDispatcher) {
				data=datas[f] as IEventDispatcher;
				data.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, childrenPropertyChanged);
			}
		}
	}

	private function clearDataEvents():void {
		if (prevDatas) {
			var f:int=prevDatas.length;
			var data:IEventDispatcher;
			while (--f >= 0) {
				data=prevDatas[f];
				data.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, childrenPropertyChanged);
			}

			prevDatas=null;
		}
	}

	override public function toString():String {
		return this.data["GroupLabel"] + " : " + column.dataField;
	}

	private function childrenPropertyChanged(event:PropertyChangeEvent):void {
		if (event.property == column.dataField) {
			sumDatas();
		}
	}

	private function getItems(data:Object):Array {
		var result:Array=[];

		if (!data || !data.hasOwnProperty("children")) {
			return result;
		}

		var children:IList=data["children"];

		var f:int=-1;
		var fmax:int=children.length;
		var child:Object;

		while (++f < fmax) {
			child=children.getItemAt(f);

			if (isGroupData(child)) {
				result=result.concat(getItems(child));
			} else {
				result.push(child);
			}
		}

		return result;
	}

	private function isGroupData(data:Object):Boolean {
		return data.hasOwnProperty("children") && data.hasOwnProperty("GroupLabel");
	}
}
}
