package ssen.components.simpleGrid {
import de.polygonal.ds.Array2;

import flash.geom.Rectangle;

import mx.collections.IList;
import mx.core.IFactory;
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.events.PropertyChangeEvent;

import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;

import ssen.components.simpleGrid.snippets.SimpleGridSkin;

[Style(name="headerRowHeight", inherit="no", type="int")]
[Style(name="rowHeight", inherit="no", type="int")]
[Style(name="columnBorder", inherit="no", type="int")]
[Style(name="rowBorder", inherit="no", type="int")]
[Style(name="leftGutter", inherit="no", type="int")]
[Style(name="rightGutter", inherit="no", type="int")]
[Style(name="topGutter", inherit="no", type="int")]
[Style(name="bottomGutter", inherit="no", type="int")]

[SkinState("blank")]
[SkinState("normal")]

public class OldSimpleGrid extends SkinnableComponent {
	//==========================================================================================
	// skin parts
	//==========================================================================================
	[SkinPart(required="true")]
	public var headerCellRenderer:IFactory /* of ISimpleGridRenderer */;

	[SkinPart(required="true")]
	public var categoryCellRenderer:IFactory /* of ISimpleGridRenderer */;

	[SkinPart(required="true")]
	public var cellRenderer:IFactory /* of ISimpleGridRenderer */;

	[SkinPart(required="true")]
	public var headerBackground:IVisualElement;

	[SkinPart(required="true")]
	public var bodyBackground:IVisualElement;

	[SkinPart(required="true")]
	public var cellGroup:IVisualElementContainer;

	//==========================================================================================
	// setting variables
	//==========================================================================================
	//---------------------------------------------
	// dataProvider
	//---------------------------------------------
	private var _dataProvider:IList;

	/** dataProvider */
	[Bindable]
	public function get dataProvider():IList {
		return _dataProvider;
	}

	public function set dataProvider(value:IList):void {
		var oldValue:IList = _dataProvider;
		if (oldValue === value) {
			return;
		}

		_dataProvider = value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dataProvider", oldValue, _dataProvider));
		}

		dataProviderChanged = true;
		invalidateProperties();
	}

	//---------------------------------------------
	// columns
	//---------------------------------------------
	private var _columns:Array;

	/** columns */
	[Bindable]
	public function get columns():Array {
		return _columns;
	}

	public function set columns(value:Array):void {
		var oldValue:Array = _columns;
		if (oldValue === value) {
			return;
		}

		_columns = value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "columns", oldValue, _columns));
		}

		columnsChanged = true;
		invalidateProperties();
	}

	//---------------------------------------------
	// highlightFunction
	//---------------------------------------------
	private var _highlightFunction:Function;

	/** highlightFunction */
	public function get highlightFunction():Function {
		return _highlightFunction;
	}

	public function set highlightFunction(value:Function):void {
		_highlightFunction = value;
	}

	//==========================================================================================
	// object stores
	//==========================================================================================
	private var dataProviderChanged:Boolean;
	private var columnsChanged:Boolean;

	//==========================================================================================
	// state flow
	//==========================================================================================
	public function OldSimpleGrid() {
		setStyle("skinClass", SimpleGridSkin);
	}

	override protected function commitProperties():void {
		super.commitProperties();

		invalidateSkinState();
	}

	override protected function getCurrentSkinState():String {
		var state:String = (dataProvider && columns) ? "normal" : "blank";
		return state;
	}

	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);
	}

	override protected function stateChanged(oldState:String, newState:String, recursive:Boolean):void {
		super.stateChanged(oldState, newState, recursive);

		if (oldState !== newState) {
			invalidateDisplayList();
		}
	}

	override protected function partRemoved(partName:String, instance:Object):void {
		super.partRemoved(partName, instance);

		if (instance === cellGroup) {
			cellGroup.removeAllElements();
			cells.clear(true);
			cells = null;
		}
	}

	//==========================================================================================
	// rendering
	//==========================================================================================
	private var cells:Array2;

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (skin.currentState === "blank") {
			return;
		}

		// width, height
		var w:int = unscaledWidth;
		var h:int = unscaledHeight;

		var columnsLength:int = _columns.length;
		var dataLength:int = _dataProvider.length;

		// get style properties
		var headerRowHeight:int = getStyle("headerRowHeight") || 24;
		var rowHeight:int = getStyle("rowHeight") || 23;
		var columnBorder:int = getStyle("columnBorder") || 1;
		var rowBorder:int = getStyle("rowBorder") || 1;
		var leftGutter:int = getStyle("leftGutter") || 0;
		var rightGutter:int = getStyle("rightGutter") || 0;
		var topGutter:int = getStyle("topGutter") || 1;
		var bottomGutter:int = getStyle("bottomGutter") || 1;

		var contentWidth:int = w - leftGutter - rightGutter;

		var tc:int, tcmax:int, r:int, rmax:int;
		var column:SimpleGridColumn;
		var columnsWidthRatioTotal:int;
		var columnWidths:Vector.<int> = new Vector.<int>(columnsLength, true);

		// calculate width ratio total
		columnsWidthRatioTotal = 0;

		tc = columnsLength;
		while (--tc >= 0) {
			column = _columns[tc];
			columnsWidthRatioTotal += column.widthRatio;
		}

		// calculate width list
		var columnsWidthTotal:int = contentWidth - (columnBorder * (columnsLength - 2));
		var columnsWidthExtra:int = columnsWidthTotal;
		var columnWidth:int;

		tc = -1;
		tcmax = columnsLength;
		while (++tc < tcmax) {
			column = _columns[tc];

			if (tc < tcmax) {
				columnWidth = columnsWidthTotal * (column.widthRatio / columnsWidthRatioTotal);
				columnsWidthExtra -= columnWidth;
			}
			else {
				columnWidth = columnsWidthExtra;
			}

			columnWidths[tc] = columnWidth;
		}

		// make cells
		var cell:Label;
		var dataRow:Object;
		var skinState:String;

		if (dataProviderChanged || columnsChanged) {
			cellGroup.removeAllElements();
			cells = new Array2(columnsLength, dataLength);

			tc = -1;
			tcmax = columnsLength;
			while (++tc < tcmax) {
				column = _columns[tc];
				cell = headerCellRenderer.newInstance();
				cell.text = column.headerText;
				cellGroup.addElement(cell);
				cells.set(tc, 0, cell);

				r = 0;
				rmax = dataLength + 1;
				while (++r < rmax) {
					dataRow = dataProvider.getItemAt(r - 1);

					if (!dataRow) {
						continue;
					}

					skinState = (_highlightFunction !== null && _highlightFunction(column, dataRow)) ? "highlighted" : "normal";
					cell = column.category ? categoryCellRenderer.newInstance() : cellRenderer.newInstance();
					cell.text = String(dataRow[column.dataField]);
					cell.setStyle("textAlign", column.textAlign);
					cell.currentState = skinState;
					cellGroup.addElement(cell);
					cells.set(tc, r, cell);
				}
			}

			dataProviderChanged = false;
			columnsChanged = false;
		}

		// position
		var nx:int = leftGutter;
		var ny:int = topGutter;

		tc = -1;
		tcmax = columnsLength;
		while (++tc < tcmax) {
			cell = cells.get(tc, 0) as Label;
			cell.x = nx;
			cell.y = ny;
			cell.width = columnWidths[tc];
			cell.height = headerRowHeight;

			ny += headerRowHeight + rowBorder;

			r = 0;
			rmax = dataLength + 1;
			while (++r < rmax) {
				cell = cells.get(tc, r) as Label;
				if (!cell) {
					continue;
				}

				cell.x = nx;
				cell.y = ny;
				cell.width = columnWidths[tc];
				cell.height = rowHeight;

				ny += rowHeight + rowBorder;
			}

			nx += columnWidths[tc] + columnBorder;
			ny = topGutter;
		}

		var headerBackgroundBound:Rectangle = new Rectangle(0, 0, nx - columnBorder + rightGutter, topGutter + headerRowHeight + rowBorder);
		var bodyBackgroundBound:Rectangle = new Rectangle(0, headerBackgroundBound.height, headerBackgroundBound.width, (rowHeight * dataLength) + (rowBorder * (dataLength - 1)) + bottomGutter);

		if (headerBackground) {
			headerBackground.x = headerBackgroundBound.x;
			headerBackground.y = headerBackgroundBound.y;
			headerBackground.width = headerBackgroundBound.width;
			headerBackground.height = headerBackgroundBound.height;
		}

		if (bodyBackground) {
			bodyBackground.x = bodyBackgroundBound.x;
			bodyBackground.y = bodyBackgroundBound.y;
			bodyBackground.width = bodyBackgroundBound.width;
			bodyBackground.height = bodyBackgroundBound.height;
		}
	}
}
}
