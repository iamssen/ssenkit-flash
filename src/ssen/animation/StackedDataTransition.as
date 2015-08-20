package ssen.animation {
public class StackedDataTransition {
	//==========================================================================================
	// properties
	//==========================================================================================
	private var changed:Boolean;

	//---------------------------------------------
	// from
	//---------------------------------------------
	private var _from:Array;

	/** from */
	public function get from():Array {
		return _from;
	}

	public function set from(value:Array):void {
		_from = value;
		changed = true;
	}

	//---------------------------------------------
	// to
	//---------------------------------------------
	private var _to:Array;

	/** to */
	public function get to():Array {
		return _to;
	}

	public function set to(value:Array):void {
		_to = value;
		changed = true;
	}

	//---------------------------------------------
	// primaryKeyProperty
	//---------------------------------------------
	private var _primaryKeyProperty:String;

	/** primaryKeyProperty */
	public function get primaryKeyProperty():String {
		return _primaryKeyProperty;
	}

	public function set primaryKeyProperty(value:String):void {
		_primaryKeyProperty = value;
		changed = true;
	}

	//---------------------------------------------
	// valueProperty
	//---------------------------------------------
	private var _valueProperty:String;

	/** valueProperty */
	public function get valueProperty():String {
		return _valueProperty;
	}

	public function set valueProperty(value:String):void {
		_valueProperty = value;
		changed = true;
	}

	//==========================================================================================
	// functions
	//==========================================================================================
	public function StackedDataTransition(valueProperty:String = null, primaryKeyProperty:String = null, from:Array = null, to:Array = null) {
		_from = from;
		_to = to;
		_valueProperty = valueProperty;
		_primaryKeyProperty = primaryKeyProperty;
		changed = true;
	}

	private var transfers:Vector.<Transfer>;
	private var primaryKeys:Vector.<String>;

	public function getSnapshot(t:Number):StackedDataTransitionSnapshot {
		if (changed) sortList();

		//		if (t < 0) t = 0;
		//		if (t > 1) t = 1;

		var value:Number;
		var values:Vector.<Number> = new Vector.<Number>(transfers.length, true);
		var ratios:Vector.<Number> = new Vector.<Number>(transfers.length, true);
		var valuesSum:Number = 0;
		var startRatios:Vector.<Number> = new Vector.<Number>(transfers.length, true);

		var transfer:Transfer;

		var f:int = transfers.length;
		var fmax:int;
		while (--f >= 0) {
			transfer = transfers[f];
			value = transfer.from + ((transfer.to - transfer.from) * t);
			values[f] = value;
			valuesSum += Math.max(value, 0);
		}

		var ratio:Number;
		var startRatio:Number = 0;
		f = -1;
		fmax = values.length;
		while (++f < fmax) {
			value = values[f];
			ratio = Math.max(value, 0) / valuesSum;
			ratios[f] = ratio;
			startRatios[f] = startRatio;
			startRatio += ratio;
		}

		var snapshot:StackedDataTransitionSnapshot = new StackedDataTransitionSnapshot;
		snapshot.t = t;
		snapshot.primaryKeys = primaryKeys;
		snapshot.valueSum = valuesSum;
		snapshot.values = values;
		snapshot.ratios = ratios;
		snapshot.startRatios = startRatios;

		return snapshot;
	}

	//----------------------------------------------------------------
	//
	//----------------------------------------------------------------
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

			if (from[_primaryKeyProperty] === to[_primaryKeyProperty]) {
				transfer = new Transfer;
				transfer.primaryKey = from[_primaryKeyProperty];
				transfer.from = from[_valueProperty];
				transfer.to = to[_valueProperty];
				transfers.push(transfer);

				lastTransfer = transfer;
			} else {
				if (lastTransfer && lastTransfer.primaryKey === from[_primaryKeyProperty]) {
					lastTransfer.from = from[_valueProperty];
				} else {
					transfer = new Transfer;
					transfer.primaryKey = from[_primaryKeyProperty];
					transfer.from = from[_valueProperty];
					transfers.push(transfer);
				}

				transfer = new Transfer;
				transfer.primaryKey = to[_primaryKeyProperty];
				transfer.to = to[_valueProperty];
				transfers.push(transfer);

				lastTransfer = transfer;
			}
		}

		var primaryValues:Vector.<String> = new Vector.<String>(transfers.length, true);

		f = -1;
		fmax = transfers.length;
		while (++f < fmax) {
			primaryValues[f] = transfers[f].primaryKey;
		}

		this.transfers = transfers;
		this.primaryKeys = primaryValues;
	}
}
}

class Transfer {
	public var primaryKey:String;
	public var from:Number = 0;
	public var to:Number = 0;
}