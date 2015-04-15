package ssen.components.grid.contents.tables {
import flash.display.Graphics;
import flash.geom.Rectangle;

import mx.core.IFactory;

import spark.components.Group;
import spark.components.supportClasses.ItemRenderer;

import ssen.components.grid.GridBlock;

import ssen.components.grid.GridElement;
import ssen.components.grid.GridUtils;
import ssen.components.grid.contents.IGridContent;
import ssen.components.grid.headers.HeaderLayoutMode;
import ssen.components.grid.headers.IHeader;

[DefaultProperty("columns")]

public class Table extends GridElement implements IGridContent {
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// row infors
	// - dataProvider
	// - columns
	// - TableColumn
	// - row info fields
	//----------------------------------------------------------------
	private var rows:Vector.<Row>;
	private var flagColumn:TableFlagColumn;

	//==========================================================================================
	// invalidate
	//==========================================================================================
	//----------------------------------------------------------------
	// from columns
	//----------------------------------------------------------------
	private var refreshCellContentsCallColumns:Vector.<TableColumn> = new <TableColumn>[];
	private var refreshCellStylesCallColumns:Vector.<TableColumn> = new <TableColumn>[];

	internal function refreshRows():void {
		invalidate_rows();
	}

	internal function refreshCellContents(column:TableColumn):void {
		if (refreshCellContentsCallColumns.indexOf(column) === -1) {
			refreshCellContentsCallColumns.push(column);
		}
		invalidate_draw();
	}

	internal function refreshCellStyles(column:TableColumn):void {
		if (refreshCellStylesCallColumns.indexOf(column) === -1) {
			refreshCellStylesCallColumns.push(column);
		}
		invalidate_draw();
	}

	//----------------------------------------------------------------
	// from IGridContent interface
	//----------------------------------------------------------------
	public function invalidateColumnLayout():void {
		trace("Table.invalidateColumnLayout()");
		invalidate_cellCreation();
	}

	public function invalidateScroll():void {
		//		trace("Table.invalidateScroll()", width, height, frontLockedContainer.width, frontLockedContainer.height, unlockedContainer.width, unlockedContainer.height, backLockedContainer.width, backLockedContainer.height);
		commit_scroll();
		//		invalidateDisplayList();
	}

	//---------------------------------------------
	// inavalidate rows
	//---------------------------------------------
	private var rowsChanged:Boolean;

	final protected function invalidate_rows():void {
		rowsChanged = true;
		invalidateProperties();
	}

	//---------------------------------------------
	// inavalidate cellCreation
	//---------------------------------------------
	private var cellCreationChanged:Boolean;

	final protected function invalidate_cellCreation():void {
		cellCreationChanged = true;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// inavalidate draw
	//---------------------------------------------
	private var drawChanged:Boolean;

	final protected function invalidate_draw():void {
		drawChanged = true;
		invalidateDisplayList();
	}

	//==========================================================================================
	// commits
	//==========================================================================================
	private function canCommitRows():Boolean {
		return _header
				&& _header.numColumns > 0
				&& _header.computedColumnPositionList
				&& _header.computedColumnPositionList.length > 0
				&& _columns
				&& _columns.length > 0
				&& _dataProvider;
	}

	private function canCommitCellCreation():Boolean {
		return canCommitRows()
				&& rows
				&& rows.length > 0;
	}

	private function canCommitDraw():Boolean {
		return canCommitCellCreation()
				&& cells
				&& cells.length > 0;
	}

	//---------------------------------------------
	// commit rows
	//---------------------------------------------
	protected function commit_rows():void {
		rows = null;
		flagColumn = null;

		readColumns();
		readRows();

		invalidate_cellCreation();
	}

	//==========================================================================================
	// public
	//==========================================================================================
	//---------------------------------------------
	// header
	//---------------------------------------------
	private var _header:IHeader;

	/** header */
	public function get header():IHeader {
		return _header;
	}

	public function set header(value:IHeader):void {
		_header = value;
		invalidate_cellCreation();
	}

	//----------------------------------------------------------------
	// column default
	//----------------------------------------------------------------
	//---------------------------------------------
	// mergeDirection
	//---------------------------------------------
	private var _mergeDirection:String = "top";

	/** mergeDirection */
	public function get mergeDirection():String {
		return _mergeDirection;
	}

	public function set mergeDirection(value:String):void {
		_mergeDirection = value;
		invalidate_rows();
	}

	private function getMergeDirection(data:Object):String {
		if (flagColumn && flagColumn.mergeDirectionField && data[flagColumn.mergeDirectionField] is String) {
			switch (data[flagColumn.mergeDirectionField]) {
				case MergeDirection.TOP:
				case MergeDirection.BOTTOM:
					return data[flagColumn.mergeDirectionField];
			}
		}

		return mergeDirection;
	}

	//---------------------------------------------
	// mergeIndentSize
	//---------------------------------------------
	private var _mergeIndentSize:int = 12;

	/** mergeIndentSize */
	public function get mergeIndentSize():int {
		return _mergeIndentSize;
	}

	public function set mergeIndentSize(value:int):void {
		if (value < 5) return;
		_mergeIndentSize = value;
		invalidate_rows();
	}

	//---------------------------------------------
	// rowHeight
	//---------------------------------------------
	private var _rowHeight:int = 26;

	/** rowHeight */
	public function get rowHeight():int {
		return _rowHeight;
	}

	public function set rowHeight(value:int):void {
		_rowHeight = value;
		invalidate_rows();
	}

	private function getRowHeight(data:Object):int {
		if (flagColumn && flagColumn.rowHeightField && !isNaN(Number(data[flagColumn.rowHeightField]))) {
			if (data[flagColumn.rowHeightField] > 10) {
				return data[flagColumn.rowHeightField];
			}
		}

		return rowHeight;
	}

	//---------------------------------------------
	// rowBackgroundColor
	//---------------------------------------------
	private var _rowBackgroundColor:uint = 0xffffff;

	/** rowBackgroundColor */
	public function get rowBackgroundColor():uint {
		return _rowBackgroundColor;
	}

	public function set rowBackgroundColor(value:uint):void {
		_rowBackgroundColor = value;
		invalidate_draw();
	}

	private function getRowBackgroundColor(data:Object):uint {
		if (flagColumn && flagColumn.rowBackgroundColorField && !isNaN(Number(data[flagColumn.rowBackgroundColorField]))) {
			return data[flagColumn.rowBackgroundColorField];
		}

		return rowBackgroundColor;
	}

	//---------------------------------------------
	// rowBackgroundAlpha
	//---------------------------------------------
	private var _rowBackgroundAlpha:Number = 1;

	/** rowBackgroundAlpha */
	public function get rowBackgroundAlpha():Number {
		return _rowBackgroundAlpha;
	}

	public function set rowBackgroundAlpha(value:Number):void {
		_rowBackgroundAlpha = value;
		invalidate_draw();
	}

	private function getRowBackgroundAlpha(data:Object):Number {
		if (flagColumn && flagColumn.rowBackgroundAlphaField && !isNaN(Number(data[flagColumn.rowBackgroundAlphaField]))) {
			return data[flagColumn.rowBackgroundAlphaField];
		}

		return rowBackgroundAlpha;
	}

	//----------------------------------------------------------------
	// data read policy
	//----------------------------------------------------------------
	//---------------------------------------------
	// childrenField
	//---------------------------------------------
	private var _childrenField:String = "children";

	/** childrenField */
	public function get childrenField():String {
		return _childrenField;
	}

	public function set childrenField(value:String):void {
		_childrenField = value;
		invalidate_rows();
	}

	//----------------------------------------------------------------
	// table style
	//----------------------------------------------------------------
	//---------------------------------------------
	// rowGap
	//---------------------------------------------
	private var _rowGap:int = 2;

	/** rowGap */
	public function get rowGap():int {
		return _rowGap;
	}

	public function set rowGap(value:int):void {
		_rowGap = value;
		invalidate_rows();
	}

	//----------------------------------------------------------------
	// data
	//----------------------------------------------------------------
	//---------------------------------------------
	// dataProvider
	//---------------------------------------------
	private var _dataProvider:Object;

	/** dataProvider */
	public function get dataProvider():Object {
		return _dataProvider;
	}

	public function set dataProvider(value:Object):void {
		_dataProvider = value;
		invalidate_rows();
	}

	//---------------------------------------------
	// columns
	//---------------------------------------------
	private var _columns:Vector.<TableColumn>;

	/** columns */
	public function get columns():Vector.<TableColumn> {
		return _columns;
	}

	public function set columns(value:Vector.<TableColumn>):void {
		_columns = value;

		var self:Table = this;

		value.forEach(function (column:TableColumn, i:int, columns:Vector.<TableColumn>):void {
			column.table = self;
		});

		invalidate_rows();
	}

	//---------------------------------------------
	// itemRenderer
	//---------------------------------------------
	private var _itemRenderer:IFactory = TableCellRenderer.defaultRenderer;

	/** itemRenderer */
	public function get itemRenderer():IFactory {
		return _itemRenderer;
	}

	public function set itemRenderer(value:IFactory):void {
		_itemRenderer = value;
		invalidate_cellCreation();
	}

	private function getItemRenderer(column:TableColumn):IFactory {
		return (column.itemRenderer) ? column.itemRenderer : itemRenderer;
	}

	//==========================================================================================
	// invalidate and commit
	//==========================================================================================
	override protected function commitProperties():void {
		super.commitProperties();

		if (rowsChanged) {
			if (canCommitRows()) {
				commit_rows();
				rowsChanged = false;
			} else {
				invalidateProperties();
			}
		}
	}

	//==========================================================================================
	// create rows
	//==========================================================================================
	private function readColumns():void {
		if (_columns && _columns[0] is TableFlagColumn) {
			flagColumn = _columns[0] as TableFlagColumn;
		}
	}

	private function readRows():void {
		var f:int;
		var fmax:int;
		var rows:Vector.<Row> = new <Row>[];

		if (_dataProvider is Array) {
			var arr:Array = _dataProvider as Array;
			f = -1;
			fmax = arr.length;
			while (++f < fmax) {
				readRow(arr[f], rows);
			}
		} else {
			readRow(_dataProvider, rows);
		}

		// set chain
		var prev:Row;
		var row:Row;
		var ny:Number = 0;

		f = -1;
		fmax = rows.length;
		while (++f < fmax) {
			row = rows[f];

			row.y = ny;
			ny += row.height + rowGap;

			row.prev = prev;
			if (prev) prev.next = row;
			prev = row;
		}

		this.rows = rows;
	}

	private function readRow(data:Object, rows:Vector.<Row>, depth:int = 0):void {
		var f:int;
		var fmax:int;

		var mergeDirection:String = getMergeDirection(data);
		var rowHeight:int = getRowHeight(data);
		var rowBackgroundColor:uint = getRowBackgroundColor(data);
		var rowBackgroundAlpha:Number = getRowBackgroundAlpha(data);
		var childrenField:String = this.childrenField;

		var row:Row = new Row;
		row.indent = depth;
		row.data = data;
		row.height = rowHeight;
		row.backgroundColor = rowBackgroundColor;
		row.backgroundAlpha = rowBackgroundAlpha;

		var startIndex:int = rows.length;
		var endIndex:int;
		var children:Array;
		var child:Object;

		if (data[childrenField] is Array) {
			if (mergeDirection === MergeDirection.TOP) {
				// add to collection
				rows.push(row);
				// loop children
				children = data[childrenField];
				f = -1;
				fmax = children.length;
				while (++f < fmax) {
					child = children[f];
					readRow(child, rows, depth + 1);
				}
				// set index
				endIndex = rows.length - 1;
				row.rowIndex = startIndex;
				row.startRowIndex = startIndex;
				row.endRowIndex = endIndex;
				// set children
				row.hasChildren=true;
			} else {
				// loop children
				children = data[childrenField];
				f = -1;
				fmax = children.length;
				while (++f < fmax) {
					child = children[f];
					readRow(child, rows, depth + 1);
				}
				// add to collection
				rows.push(row);
				// set index
				endIndex = rows.length - 1;
				row.rowIndex = endIndex;
				row.startRowIndex = startIndex;
				row.endRowIndex = endIndex;
				// set children
				row.hasChildren=true;
			}
		} else {
			// add to collection
			rows.push(row);
			// set index
			row.rowIndex = startIndex;
			row.startRowIndex = startIndex;
			row.endRowIndex = startIndex;
			// set children
			row.hasChildren = false;
		}
	}

	//----------------------------------------------------------------
	//
	//----------------------------------------------------------------
	//---------------------------------------------
	// commit cellCreation
	//---------------------------------------------
	protected function commit_cellCreation():void {
		// cell 들을 만들면서 bound 계산을 한다
		frontLockedContainer.removeAllElements();
		unlockedContainer.removeAllElements();
		backLockedContainer.removeAllElements();
		cells.length = 0;

		frontContentWidth = 0;
		backContentWidth = 0;
		unlockContentWidth = 0;
		contentHeight = 0;

		var bound:Rectangle = new Rectangle;
		var block:Group;

		var widthList:Vector.<Number> = header.computedColumnWidthList;
		var positionList:Vector.<Number> = header.computedColumnPositionList;
		var blockId:int;

		var rowGap:int = this.rowGap;

		var columns:Vector.<TableColumn> = this.columns;
		var column:TableColumn;
		var row:Row;

		var cell:ITableCellRenderer;

		var f:int;
		var fmax:int;
		var s:int;
		var smax:int;

		var ny:Number = 0;

		f = -1;
		fmax = rows.length;
		while (++f < fmax) {
			row = rows[f];

			s = -1;
			smax = widthList.length;
			while (++s < smax) {
				blockId = GridUtils.getContainerId(header, s);
				block = getBlock(blockId);

				column = columns[s];

				bound.x = GridUtils.columnDrawX(positionList, s, blockId, header.columnLayoutMode, header.frontLockedColumnCount, header.backLockedColumnCount);
				bound.y = ny;
				bound.width = widthList[s];
				bound.height = row.height;

				cell = getItemRenderer(column).newInstance();
				cell.table = this;
				cell.row = row;
				cell.column = column;
				cell.columnIndex = s;

				cell.x = bound.x;
				cell.y = bound.y;
				cell.width = bound.width;
				cell.height = bound.height;

				block.addElement(cell);
				cells.push(cell);

				switch (blockId) {
					case GridBlock.FRONT_LOCK:
						frontContentWidth = Math.max(frontContentWidth, bound.x + bound.width);
						break;
					case GridBlock.BACK_LOCK :
						backContentWidth = Math.max(backContentWidth, bound.x + bound.width);
						break;
					case GridBlock.UNLOCK:
						unlockContentWidth = Math.max(unlockContentWidth, bound.x + bound.width);
						break;
				}

				contentHeight = Math.max(contentHeight, bound.y + bound.height);
			}

			// increase row info
			ny += row.height + rowGap;
		}
	}

	//---------------------------------------------
	// commit layout
	//---------------------------------------------
	protected function commit_layout():void {
		if (header.columnLayoutMode === HeaderLayoutMode.FIXED) {
			var frontGap:Number = 0;
			var backGap:Number = 0;

			// front / back container visible
			if (header.frontLockedColumnCount > 0) {
				frontLockedContainer.visible = true;
				frontLockedContainer.includeInLayout = true;

				frontGap = header.columnSeparatorSize;
			} else {
				frontLockedContainer.visible = false;
				frontLockedContainer.includeInLayout = false;

				frontGap = 0;
			}

			if (header.backLockedColumnCount > 0) {
				backLockedContainer.visible = true;
				backLockedContainer.includeInLayout = true;

				backGap = header.columnSeparatorSize;
			} else {
				backLockedContainer.visible = false;
				backLockedContainer.includeInLayout = false;

				backGap = 0;
			}

			// set bound values
			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			unlockedContainer.x = header.computedFrontLockedColumnWidthTotal + frontGap;
			unlockedContainer.width = unscaledWidth - header.computedFrontLockedColumnWidthTotal - frontGap - header.computedBackLockedColumnWidthTotal - backGap;
			unlockedContainer.height = contentHeight;

			if (unlockedContainer.width > unlockContentWidth) {
				unlockedContainer.width = unlockContentWidth;
			}

			if (header.frontLockedColumnCount > 0) {
				frontLockedContainer.width = header.computedFrontLockedColumnWidthTotal;
				frontLockedContainer.height = contentHeight;
			}

			if (header.backLockedColumnCount > 0) {
				backLockedContainer.x = unlockedContainer.x + unlockedContainer.width + backGap;
				backLockedContainer.width = header.computedBackLockedColumnWidthTotal;
				backLockedContainer.height = contentHeight;
			}
		} else {
			frontLockedContainer.visible = false;
			frontLockedContainer.includeInLayout = false;

			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			backLockedContainer.visible = false;
			backLockedContainer.includeInLayout = false;

			unlockedContainer.x = 0;
			unlockedContainer.width = unscaledWidth;
			unlockedContainer.height = contentHeight;
		}
	}

	//---------------------------------------------
	// commit draw
	//---------------------------------------------
	protected function commit_draw():void {
		var f:int = cells.length;
		while (--f >= 0) {
			cells[f].render();
		}
	}

	//---------------------------------------------
	// commit scroll
	//---------------------------------------------
	protected function commit_scroll():void {
		if (!_header || !unlockedContainer) return;
		unlockedContainer.horizontalScrollPosition = _header.horizontalScrollPosition;
	}

	//==========================================================================================
	//
	//==========================================================================================
	private var cells:Vector.<ITableCellRenderer> = new <ITableCellRenderer>[];
	private var frontContentWidth:Number;
	private var unlockContentWidth:Number;
	private var backContentWidth:Number;
	private var contentHeight:Number;

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		//----------------------------------------------------------------
		// commit rows
		//----------------------------------------------------------------
		if (rowsChanged) {
			if (canCommitRows()) {
				commit_rows();
				rowsChanged = false;
			}
		}

		//----------------------------------------------------------------
		// cancel update
		//----------------------------------------------------------------
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		//----------------------------------------------------------------
		// cell creation
		//----------------------------------------------------------------
		if (cellCreationChanged) {
			if (canCommitCellCreation()) {
				commit_cellCreation();
				cellCreationChanged = false;
				drawChanged = true;
			} else {
				invalidateDisplayList();
				return;
			}
		}

		//----------------------------------------------------------------
		// layout
		//----------------------------------------------------------------
		commit_layout();

		//----------------------------------------------------------------
		// scroll
		//----------------------------------------------------------------
		commit_scroll();

		//----------------------------------------------------------------
		// draw
		//----------------------------------------------------------------
		if (drawChanged) {
			if (canCommitDraw()) {
				commit_draw();
				drawChanged = false;
			} else {
				invalidateDisplayList();
				return;
			}
		}

		//		//----------------------------------------------------------------
		//		// test
		//		//----------------------------------------------------------------
		//		if (cellCreationChanged || drawChanged) {
		//			if (canCommitCellCreation() || canCommitDraw()) {
		//				//---------------------------------------------
		//				// clear
		//				//---------------------------------------------
		//				frontLockedContainer.graphics.clear();
		//				unlockedContainer.graphics.clear();
		//				backLockedContainer.graphics.clear();
		//
		//				commit_cellCreation();
		//
		//				cellCreationChanged = false;
		//				drawChanged = false;
		//			} else {
		//				invalidate_cellCreation();
		//			}
		//
		//			trace("Table.updateDisplayList()", unscaledWidth, unscaledHeight);
		//		}

		//----------------------------------------------------------------
		// cell creation
		//----------------------------------------------------------------
		//		if (canCommitCellCreation()) {
		//			commit_cellCreation();
		//			cellCreationChanged = false;
		//		}

		//----------------------------------------------------------------
		// draw
		//----------------------------------------------------------------
		//		if (canCommitDraw()) {
		//			//---------------------------------------------
		//			// clear
		//			//---------------------------------------------
		//			frontLockedContainer.graphics.clear();
		//			unlockedContainer.graphics.clear();
		//			backLockedContainer.graphics.clear();
		//
		//			commit_draw();
		//			drawChanged = false;
		//		}
	}

	private function oldDraw():void {

		//----------------------------------------------------------------
		// draw
		//----------------------------------------------------------------
		var g:Graphics;
		var bound:Rectangle = new Rectangle;
		var block:Group;

		var widthList:Vector.<Number> = header.computedColumnWidthList;
		var positionList:Vector.<Number> = header.computedColumnPositionList;
		var blockId:int;

		var alpha:Number;

		var row:Row;

		var f:int;
		var fmax:int;
		var s:int;
		var smax:int;

		f = -1;
		fmax = rows.length;
		while (++f < fmax) {
			row = rows[f];

			alpha = 1;

			s = -1;
			smax = widthList.length;
			while (++s < smax) {
				blockId = GridUtils.getContainerId(header, s);
				block = getBlock(blockId);

				//---------------------------------------------
				// draw
				//---------------------------------------------
				bound.x = GridUtils.columnDrawX(positionList, s, blockId, header.columnLayoutMode, header.frontLockedColumnCount, header.backLockedColumnCount);
				bound.y = (f * 25);
				bound.width = widthList[s];
				bound.height = 20;

				//				trace("Table.commit_cellCreation() draw", f, s, block.width, block.height);
				//
				//				g = block.graphics;
				//				g.beginFill(0, alpha);
				//				g.drawRect(bound.x, bound.y, bound.width, bound.height);
				//				g.endFill();
				//
				//				alpha -= 0.1;
			}
		}

		//----------------------------------------------------------------
		// set height
		//----------------------------------------------------------------
		var computedWidth:Number = unscaledWidth;
		var computedHeight:Number = bound.y + bound.height;

		//----------------------------------------------------------------
		// update container layouts
		//----------------------------------------------------------------
		if (header.columnLayoutMode === HeaderLayoutMode.FIXED) {
			var frontGap:Number = 0;
			var backGap:Number = 0;

			// front / back container visible
			if (header.frontLockedColumnCount > 0) {
				frontLockedContainer.visible = true;
				frontLockedContainer.includeInLayout = true;

				frontGap = header.columnSeparatorSize;
			} else {
				frontLockedContainer.visible = false;
				frontLockedContainer.includeInLayout = false;

				frontGap = 0;
			}

			if (header.backLockedColumnCount > 0) {
				backLockedContainer.visible = true;
				backLockedContainer.includeInLayout = true;

				backGap = header.columnSeparatorSize;
			} else {
				backLockedContainer.visible = false;
				backLockedContainer.includeInLayout = false;

				backGap = 0;
			}

			// set bound values
			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			unlockedContainer.x = header.computedFrontLockedColumnWidthTotal + frontGap;
			unlockedContainer.width = unscaledWidth - header.computedFrontLockedColumnWidthTotal - frontGap - header.computedBackLockedColumnWidthTotal - backGap;
			unlockedContainer.height = computedHeight;

			//			trace("Table.commit_cellCreation() unlocked width", unscaledWidth, header.computedFrontLockedColumnWidthTotal, frontGap, header.computedBackLockedColumnWidthTotal, backGap);

			if (header.frontLockedColumnCount > 0) {
				frontLockedContainer.width = header.computedFrontLockedColumnWidthTotal;
				frontLockedContainer.height = computedHeight;
			}

			if (header.backLockedColumnCount > 0) {
				backLockedContainer.x = unlockedContainer.x + unlockedContainer.width + header.columnSeparatorSize;
				backLockedContainer.width = header.computedBackLockedColumnWidthTotal;
				backLockedContainer.height = computedHeight;

				trace("Table.commit_cellCreation()", backLockedContainer.x, backLockedContainer.width, backLockedContainer.height);
			}
		} else {
			frontLockedContainer.visible = false;
			frontLockedContainer.includeInLayout = false;

			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			backLockedContainer.visible = false;
			backLockedContainer.includeInLayout = false;

			unlockedContainer.x = 0;
			unlockedContainer.width = unscaledWidth;
			unlockedContainer.height = computedHeight;
		}

		//		if (frontLockedContainer.visible) {
		//			frontLockedContainer.height = computedHeight;
		//		}
		//
		//		if (backLockedContainer.visible) {
		//			backLockedContainer.height = computedHeight;
		//		}
		//
		//		height = computedHeight;

		trace("Table.commit_cellCreation() Containers", unscaledWidth, unscaledHeight, width, height, frontLockedContainer.width, frontLockedContainer.height, unlockedContainer.width, unlockedContainer.height, backLockedContainer.width, backLockedContainer.height);


		//----------------------------------------------------------------
		// draw2
		//----------------------------------------------------------------
		f = -1;
		fmax = rows.length;
		while (++f < fmax) {
			row = rows[f];

			alpha = 1;

			s = -1;
			smax = widthList.length;
			while (++s < smax) {
				blockId = GridUtils.getContainerId(header, s);
				block = getBlock(blockId);

				//---------------------------------------------
				// draw
				//---------------------------------------------
				bound.x = GridUtils.columnDrawX(positionList, s, blockId, header.columnLayoutMode, header.frontLockedColumnCount, header.backLockedColumnCount);
				bound.y = (f * 25);
				bound.width = widthList[s];
				bound.height = 20;

				trace("Table.commit_cellCreation() draw", f, s, block.width, block.height);

				g = block.graphics;
				g.beginFill(0, alpha);
				g.drawRect(bound.x, bound.y, bound.width, bound.height);
				g.endFill();

				alpha -= 0.1;
			}
		}
	}
}
}
