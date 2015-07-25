package ssen.components.sparkDatagridSupportClasses.elements {

import flash.events.Event;

import mx.collections.IList;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.FlexEvent;
import mx.events.ResizeEvent;

import spark.components.DataGrid;
import spark.components.Grid;

use namespace mx_internal;

public class RowElementController {
	public var rowElement:IDataGridRowElement;
	public var draw:Function;

	public var scrollChanged:Boolean;
	public var sizeChanged:Boolean;
	public var collectionChanged:Boolean;

	private var _dataGrid:DataGrid;
	private var _dataProvider:IList;

	public function get dataGrid():DataGrid {
		return _dataGrid;
	}

	public function set dataGrid(value:DataGrid):void {
		clearDataGrid();
		_dataGrid = value;
		addDataGrid();

		rowElement.invalidateSize();
		rowElement.invalidateDisplayList();
	}

	private function clearDataGrid():void {
		if (_dataGrid) {
			var grid:Grid = _dataGrid.grid;

			grid.removeEventListener("dataProviderChanged", dataProviderChanged);
			grid.removeEventListener(ResizeEvent.RESIZE, gridResize);
			grid.removeEventListener(FlexEvent.UPDATE_COMPLETE, gridUpdateComplete);
		}
	}

	private function addDataGrid():void {
		var grid:Grid = _dataGrid.grid;

		grid.addEventListener("dataProviderChanged", dataProviderChanged);
		grid.addEventListener(ResizeEvent.RESIZE, gridResize);
		grid.addEventListener(FlexEvent.UPDATE_COMPLETE, gridUpdateComplete);

		dataProviderChanged();
	}

	public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		if (!_dataProvider) {
			return;
		}

		draw(sizeChanged, scrollChanged, collectionChanged);

		sizeChanged = false;
		scrollChanged = false;
		collectionChanged = false;
	}

	private function dataProviderChanged(event:Event = null):void {
		if (_dataProvider) {
			_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChange);
			_dataProvider = null;
		}

		if (_dataGrid.dataProvider) {
			_dataProvider = _dataGrid.dataProvider;
			_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChange);
			rowElement.invalidateDisplayList();
		}
	}

	private function gridUpdateComplete(event:FlexEvent):void {
		if (_dataGrid.grid.isInvalidateDisplayListReason("horizontalScrollPosition")) {
			scrollChanged = true;
			rowElement.invalidateDisplayList();
		}
	}

	private function gridResize(event:ResizeEvent):void {
		sizeChanged = true;
		rowElement.invalidateSize();
	}

	private function collectionChange(event:CollectionEvent):void {
		collectionChanged = true;
		rowElement.invalidateProperties();
	}
}
}
