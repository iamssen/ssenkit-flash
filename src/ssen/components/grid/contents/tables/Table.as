package ssen.components.grid.contents.tables {
import flash.events.Event;
import flash.geom.Rectangle;

import mx.core.IFactory;
import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;
import mx.events.ResizeEvent;

import spark.components.Group;
import spark.core.IViewport;

import ssen.common.DisposableUtils;
import ssen.components.grid.GridBlock;
import ssen.components.grid.GridElement;
import ssen.components.grid.GridUtils;
import ssen.components.grid.contents.IGridContent;
import ssen.components.grid.headers.HeaderLayoutMode;
import ssen.components.grid.headers.IHeader;

use namespace mx_internal;

[DefaultProperty("columns")]

public class Table extends GridElement implements IGridContent, IViewport {
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
	private var flagColumn:TableColumn;

	private var cells:Vector.<ITableCellRenderer> = new <ITableCellRenderer>[];
	private var _frontContentWidth:Number;
	private var _unlockContentWidth:Number;
	private var _backContentWidth:Number;

	//==========================================================================================
	// invalidate
	//==========================================================================================
	//----------------------------------------------------------------
	// from columns
	//----------------------------------------------------------------
	private var refreshCellContentsCallColumns:Vector.<TableColumn> = new <TableColumn>[];
	private var refreshCellStylesCallColumns:Vector.<TableColumn> = new <TableColumn>[];

	internal function refreshRows():void {
		// trace("Table.refreshRows()", name);
		invalidate_rows();
	}

	internal function refreshCellContents(column:TableColumn):void {
		// trace("Table.refreshCellContents()", name);
		if (refreshCellContentsCallColumns.indexOf(column) === -1) {
			refreshCellContentsCallColumns.push(column);
		}
		invalidate_draw();
	}

	internal function refreshCellStyles(column:TableColumn):void {
		// trace("Table.refreshCellStyles()", name);
		if (refreshCellStylesCallColumns.indexOf(column) === -1) {
			refreshCellStylesCallColumns.push(column);
		}
		invalidate_draw();
	}

	//---------------------------------------------
	// event hook
	//---------------------------------------------
	internal function cellMouseClick(column:TableColumn, row:Row):void {

	}

	//----------------------------------------------------------------
	// from IGridContent interface
	//----------------------------------------------------------------
	public function invalidateColumnLayout():void {
		invalidate_cellCreation();
	}

	public function invalidateScroll():void {
		//		commit_layout();
		commit_scroll();
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
		var flag:TableFlagColumn;

		if (flagColumn is TableFlagColumn) {
			flag = flagColumn as TableFlagColumn;
		} else {
			return MergeDirection.NONE;
		}

		if (flag && flag.mergeDirectionField && data[flag.mergeDirectionField] is String) {
			switch (data[flag.mergeDirectionField]) {
				case MergeDirection.TOP:
				case MergeDirection.BOTTOM:
					return data[flag.mergeDirectionField];
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
	private var _rowGap:int = 1;

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
	// create rows
	//==========================================================================================
	private function readColumns():void {
		flagColumn = _columns[0];
		//		if (_columns && _columns[0] is TableFlagColumn) {
		//			flagColumn = _columns[0] as TableFlagColumn;
		//		}
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
		var childrenField:String = this.childrenField;

		var row:Row = new Row;
		row.indent = depth;
		row.data = data;
		row.height = rowHeight;
		row.backgroundColor = rowBackgroundColor;

		var startIndex:int = rows.length;
		var endIndex:int;
		var children:Array;
		var child:Object;

		if (getMergeDirection(data) !== MergeDirection.NONE && data[childrenField] is Array) {
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
				row.hasChildren = true;
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
				row.hasChildren = true;
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

	//==========================================================================================
	// create commits
	//==========================================================================================
	//---------------------------------------------
	// commit cellCreation
	//---------------------------------------------
	protected function commit_cellCreation():void {
		//---------------------------------------------
		// clear
		//---------------------------------------------
		DisposableUtils.disposeContainer(frontLockedContainer);
		DisposableUtils.disposeContainer(unlockedContainer);
		DisposableUtils.disposeContainer(backLockedContainer);
		cells.length = 0;

		var frontContentWidth:Number = 0;
		var backContentWidth:Number = 0;
		var unlockContentWidth:Number = 0;
		var contentHeight:Number = 0;

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

		_frontContentWidth = frontContentWidth;
		_backContentWidth = backContentWidth;
		_unlockContentWidth = unlockContentWidth;
		set_contentHeight(contentHeight);
		//		trace("Table.commit_cellCreation() explicit height is", explicitHeight, explicitMinHeight, explicitMaxHeight, minHeight, maxHeight);
		measuredHeight = getContainerHeight(contentHeight);
		//		trace("@ Table.commit_cellCreation()", measuredHeight, contentHeight);
	}

	private function getContainerHeight(contentHeight:Number):Number {
		if (!isNaN(explicitHeight)) {
			//			trace("Table.getContainerHeight() use explicitHeight", name, contentHeight, explicitHeight, explicitMinHeight, explicitMaxHeight);
			return explicitHeight;
		} else if (!isNaN(explicitMinHeight) && contentHeight < explicitMinHeight) {
			//			trace("Table.getContainerHeight() use explicitMinHeight", name, contentHeight, explicitHeight, explicitMinHeight, explicitMaxHeight);
			return explicitMinHeight;
		} else if (!isNaN(explicitMaxHeight) && contentHeight > explicitMaxHeight) {
			//			trace("Table.getContainerHeight() use explicitMaxHeight", name, contentHeight, explicitHeight, explicitMinHeight, explicitMaxHeight);
			return explicitMaxHeight;
		}
		//		trace("Table.getContainerHeight() use contentHeight", name, contentHeight, explicitHeight, explicitMinHeight, explicitMaxHeight);
		return contentHeight;
	}

	//---------------------------------------------
	// commit layout
	//---------------------------------------------
	protected function commit_layout():void {
		//		trace("Table.commit_layout() height values is", explicitHeight, explicitMinHeight, explicitMaxHeight, measuredHeight);
		var containerHeight:Number = getContainerHeight(_contentHeight);
		var containerWidth:Number = 0;
		var enabledScroll:Boolean = _contentHeight > containerHeight;

		if (header.columnLayoutMode === HeaderLayoutMode.FIXED) {
			// front / back container visible
			if (header.computedFrontLockedBlockVisible) {
				frontLockedContainer.visible = true;
				frontLockedContainer.includeInLayout = true;
			} else {
				frontLockedContainer.visible = false;
				frontLockedContainer.includeInLayout = false;
			}

			if (header.computedBackLockedBlockVisible) {
				backLockedContainer.visible = true;
				backLockedContainer.includeInLayout = true;
			} else {
				backLockedContainer.visible = false;
				backLockedContainer.includeInLayout = false;
			}

			// set bound values
			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			unlockedContainer.x = header.computedUnlockedBlockX;
			unlockedContainer.width = header.computedUnlockedBlockWidth;
			unlockedContainer.height = containerHeight;

			if (unlockedContainer.width > _unlockContentWidth) {
				unlockedContainer.width = _unlockContentWidth;

				containerWidth = unlockedContainer.x + unlockedContainer.width;
			}

			if (header.computedFrontLockedBlockVisible) {
				frontLockedContainer.x = header.computedFrontLockedBlockX;
				frontLockedContainer.width = header.computedFrontLockedBlockWidth;
				frontLockedContainer.height = containerHeight;
			}

			if (header.computedBackLockedBlockVisible) {
				backLockedContainer.x = header.computedBackLockedBlockX;
				backLockedContainer.width = header.computedBackLockedBlockWidth;
				backLockedContainer.height = containerHeight;

				containerWidth = backLockedContainer.x + backLockedContainer.width;
			}
		} else {
			frontLockedContainer.visible = false;
			frontLockedContainer.includeInLayout = false;

			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			backLockedContainer.visible = false;
			backLockedContainer.includeInLayout = false;

			unlockedContainer.x = header.computedUnlockedBlockX;
			unlockedContainer.width = header.computedUnlockedBlockWidth;
			unlockedContainer.height = containerHeight;

			containerWidth = unlockedContainer.x + unlockedContainer.width;
		}

		if (enabledScroll) {
			scrollBar.visible = true;
			scrollBar.includeInLayout = true;

			scrollBar.x = containerWidth - scrollBar.width;
			scrollBar.y = 0;
			scrollBar.height = containerHeight;
		} else {
			scrollBar.visible = false;
			scrollBar.includeInLayout = false;
		}
	}

	override protected function createChildren():void {
		super.createChildren();
		if (scrollBar) scrollBar.viewport = this;
		//		if (scrollBar) {
		//			scrollBar.addEventListener(Event.CHANGE, scrollChanged);
		//		}
	}

	//	private function scrollChanged(event:Event):void {
	//		trace("Table.scrollChanged()", scrollBar.maximum, scrollBar.value);
	//	}

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
		if (!_header) return;
		horizontalScrollPosition = _header.horizontalScrollPosition;
//		trace("Table.commit_scroll()", this.height, this.contentHeight);
	}

	//==========================================================================================
	// update hook
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

	//	override public function invalidateDisplayList():void {
	//		super.invalidateDisplayList();
	//		// trace("Table.invalidateDisplayList()", name);
	//	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		//----------------------------------------------------------------
		// commit rows
		//----------------------------------------------------------------
		if (rowsChanged) {
			// trace("Table.updateDisplayList() rowChanged", name);

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
			// trace("Table.updateDisplayList() cellCreationChanged", name);

			if (canCommitCellCreation()) {
				commit_cellCreation();
				cellCreationChanged = false;
				drawChanged = true;

				if (unscaledHeight != measuredHeight) {
					var oldWidth:Number = width;
					var oldHeight:Number = height;

					unscaledHeight = measuredHeight;
					_height = measuredHeight;

					invalidateParentSizeAndDisplayList();
					if (hasEventListener("heightChanged")) dispatchEvent(new Event("heightChanged"));
					if (hasEventListener(ResizeEvent.RESIZE)) dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE, false, false, oldWidth, oldHeight));
					//					if (scrollBar.visible) scrollBar.maximum = contentHeight - height;
				}
			} else {
				invalidateDisplayList();
				return;
			}
		}

		//----------------------------------------------------------------
		// layout
		//----------------------------------------------------------------
		commit_layout();
		if (scrollBar.visible) {
			scrollBar.height = unscaledHeight;
			scrollBar.maximum = contentHeight - height;
		}

		//----------------------------------------------------------------
		// scroll
		//----------------------------------------------------------------
		commit_scroll();

		//----------------------------------------------------------------
		// draw
		//----------------------------------------------------------------
		if (drawChanged) {
			// trace("Table.updateDisplayList() drawChanged", name);

			if (canCommitDraw()) {
				commit_draw();
				drawChanged = false;
			} else {
				invalidateDisplayList();
				return;
			}
		}
	}

	//==========================================================================================
	// implements IViewport
	//==========================================================================================
	public function get contentWidth():Number {
		return (unlockedContainer) ? unlockedContainer.contentWidth : 0;
	}

	//---------------------------------------------
	// contentHeight
	//---------------------------------------------
	private var _contentHeight:Number;

	/** contentHeight */
	[Bindable(event="propertyChange")]
	public function get contentHeight():Number {
		return _contentHeight;
	}

	private function set_contentHeight(value:Number):void {
		var oldValue:Number = _contentHeight;
		_contentHeight = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "contentHeight", oldValue, _contentHeight));
		}
	}

	public function get horizontalScrollPosition():Number {
		return (unlockedContainer) ? unlockedContainer.horizontalScrollPosition : 0;
	}

	public function set horizontalScrollPosition(value:Number):void {
		if (!unlockedContainer) return;
		unlockedContainer.horizontalScrollPosition = value;
	}

	//---------------------------------------------
	// verticalScrollPosition
	//---------------------------------------------
	private var _verticalScrollPosition:Number;

	/** verticalScrollPosition */
	[Bindable]
	public function get verticalScrollPosition():Number {
		return _verticalScrollPosition;
	}

	public function set verticalScrollPosition(value:Number):void {
		var oldValue:Number = _verticalScrollPosition;
		_verticalScrollPosition = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "verticalScrollPosition", oldValue, _verticalScrollPosition));
		}

		if (frontLockedContainer) frontLockedContainer.verticalScrollPosition = value;
		if (unlockedContainer) unlockedContainer.verticalScrollPosition = value;
		if (backLockedContainer) backLockedContainer.verticalScrollPosition = value;
	}

	public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number {
		return 0;
	}

	public function getVerticalScrollPositionDelta(navigationUnit:uint):Number {
		return (unlockedContainer) ? unlockedContainer.getVerticalScrollPositionDelta(navigationUnit) : 0;
	}

	public function get clipAndEnableScrolling():Boolean {
		return true;
	}

	public function set clipAndEnableScrolling(value:Boolean):void {
		// ignore
	}
}
}
