package ssen.animation {
public class ArrayedDataTransition implements IDataTransition {
	private var changed:Boolean;

	//---------------------------------------------
	// from
	//---------------------------------------------
	private var _from:Array;

	/** from */
	public function get from():* {
		return _from;
	}

	public function set from(value:*):void {
		_from = value;
		changed = true;
	}

	//---------------------------------------------
	// to
	//---------------------------------------------
	private var _to:Array;

	/** to */
	public function get to():* {
		return _to;
	}

	public function set to(value:*):void {
		_to = value;
		changed = true;
	}

	//---------------------------------------------
	// primaryProperty
	//---------------------------------------------
	private var _primaryProperty:String;

	/** primaryProperty */
	public function get primaryProperty():String {
		return _primaryProperty;
	}

	public function set primaryProperty(value:String):void {
		_primaryProperty = value;
		changed = true;
	}

	//---------------------------------------------
	// property
	//---------------------------------------------
	private var _property:String;

	/** property */
	public function get property():String {
		return _property;
	}

	public function set property(value:String):void {
		_property = value;
		changed = true;
	}

	public function ArrayedDataTransition(property:String = null, primaryProperty:String = null, from:Array = null, to:Array = null) {
		_from = from;
		_to = to;
		_property = property;
		_primaryProperty = primaryProperty;
		changed = true;
	}

	private var transfers:Vector.<Transfer>;
	private var primaryValues:Vector.<String>;

	public function getSnapshot(t:Number):IDataTransitionSnapshot {
		if (changed) sortList();

		//		if (t < 0) t = 0;
		//		if (t > 1) t = 1;

		var value:Number;
		var values:Vector.<Number> = new Vector.<Number>(transfers.length, true);
		var ratios:Vector.<Number> = new Vector.<Number>(transfers.length, true);
		var total:Number = 0;
		var startRatios:Vector.<Number> = new Vector.<Number>(transfers.length, true);

		var transfer:Transfer;

		var f:int = transfers.length;
		var fmax:int;
		while (--f >= 0) {
			transfer = transfers[f];
			value = transfer.from + ((transfer.to - transfer.from) * t);
			values[f] = value;
			total += Math.max(value, 0);
		}

		var ratio:Number;
		var startRatio:Number = 0;
		f = -1;
		fmax = values.length;
		while (++f < fmax) {
			value = values[f];
			ratio = Math.max(value, 0) / total;
			ratios[f] = ratio;
			startRatios[f] = startRatio;
			startRatio += ratio;
		}

		var snapshot:Snapshot = new Snapshot;
		snapshot._t = t;
		snapshot._primaryValues = primaryValues;
		snapshot._total = total;
		snapshot._values = values;
		snapshot._ratios = ratios;
		snapshot._startRatios = startRatios;

		return snapshot;
	}

	private function sortList():void {
		var fromLength:int = _from.length;
		var toLength:int = _to.length;
		var from:Object;
		var to:Object;

		var transfers:Vector.<Transfer> = new <Transfer>[];
		var transfer:Transfer;
		var lastTransfer:Transfer;

		var f:int = -1;
		var fmax:int = Math.max(fromLength, toLength);

		while (++f < fmax) {
			from = (f < fromLength) ? _from[f] : null;
			to = (f < toLength) ? _to[f] : null;

			if (from[_primaryProperty] === to[_primaryProperty]) {
				transfer = new Transfer;
				transfer.primary = from[_primaryProperty];
				transfer.from = from[_property];
				transfer.to = to[_property];
				transfers.push(transfer);

				lastTransfer = transfer;
			} else {
				if (lastTransfer && lastTransfer.primary === from[_primaryProperty]) {
					lastTransfer.from = from[_property];
				} else {
					transfer = new Transfer;
					transfer.primary = from[_primaryProperty];
					transfer.from = from[_property];
					transfers.push(transfer);
				}

				transfer = new Transfer;
				transfer.primary = to[_primaryProperty];
				transfer.to = to[_property];
				transfers.push(transfer);

				lastTransfer = transfer;
			}
		}

		var primaryValues:Vector.<String> = new Vector.<String>(transfers.length, true);

		f = -1;
		fmax = transfers.length;
		while (++f < fmax) {
			primaryValues[f] = transfers[f].primary;
		}

		this.transfers = transfers;
		this.primaryValues = primaryValues;
	}
}
}

import ssen.animation.IDataTransitionSnapshot;

class Transfer {
	public var primary:String;
	public var from:Number = 0;
	public var to:Number = 0;
}

class Snapshot implements IDataTransitionSnapshot {
	internal var _t:Number;
	internal var _total:Number;
	internal var _ratios:Vector.<Number>;
	internal var _values:Vector.<Number>;
	internal var _startRatios:Vector.<Number>;
	internal var _primaryValues:Vector.<String>;

	public function get t():Number {
		return _t;
	}

	public function get sum():Number {
		return _total;
	}

	public function get primaryValues():Vector.<String> {
		return _primaryValues;
	}

	public function get ratios():Vector.<Number> {
		return _ratios;
	}

	public function get values():Vector.<Number> {
		return _values;
	}

	public function get startRatios():Vector.<Number> {
		return _startRatios;
	}
}