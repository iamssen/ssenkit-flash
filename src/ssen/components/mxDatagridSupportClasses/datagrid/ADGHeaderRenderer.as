package ssen.components.mxDatagridSupportClasses.datagrid {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextLineMetrics;

import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnGroup;
import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
import mx.controls.advancedDataGridClasses.SortInfo;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.ClassFactory;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.IInvalidating;
import mx.core.IToolTip;
import mx.core.IUITextField;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.events.ToolTipEvent;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------
[Event(name="dataChange", type="mx.events.FlexEvent")]

//--------------------------------------
//  Styles
//--------------------------------------
[Style(name="color", type="uint", format="Color", inherit="yes")]
[Style(name="separatorColor", type="uint", format="Color", inherit="yes")]
[Style(name="horizontalAlign", type="String", enumeration="left,center,right", inherit="no")]
[Style(name="verticalAlign", type="String", enumeration="top,middle,bottom", inherit="no")]

/** 
 * Advanced Data Grid Header의 문제점을 보완한 HeaderRenderer 
 * (Clone Code) 상속으로 해결이 안되어서 Clone 해와서 수정했음
 */ 
public class ADGHeaderRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer {
	//--------------------------------------------------------------------------
	//  Constructor
	//--------------------------------------------------------------------------
	public function ADGHeaderRenderer() {
		super();

		tabEnabled=false;

		addEventListener(ToolTipEvent.TOOL_TIP_SHOW, toolTipShowHandler);
	}

	//--------------------------------------------------------------------------
	//  Variables
	//--------------------------------------------------------------------------

	private var grid:AdvancedDataGrid;
	private var oldUnscaledWidth:Number=-1;
	private var partsSeparatorSkinClass:Class;
	private var partsSeparatorSkin:DisplayObject;
	private var sortItemRendererInstance:UIComponent;
	private var sortItemRendererChanged:Boolean=false;
	protected var label:IUITextField;
	protected var background:Sprite;

	//--------------------------------------------------------------------------
	//  Overridden properties: UIComponent
	//--------------------------------------------------------------------------
	//----------------------------------
	//  baselinePosition
	//----------------------------------
	override public function get baselinePosition():Number {
		return label.baselinePosition;
	}

	//--------------------------------------------------------------------------
	//  Properties
	//--------------------------------------------------------------------------
	//----------------------------------
	//  data
	//----------------------------------
	private var _data:Object;

	[Bindable("dataChange")]
	public function get data():Object {
		return _data;
	}

	public function set data(value:Object):void {
		_data=value;
		invalidateProperties();
		dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
	}

	//----------------------------------
	//  sortItemRenderer
	//----------------------------------
	private var _sortItemRenderer:IFactory;

	[Inspectable(category="Data")]
	public function get sortItemRenderer():IFactory {
		return _sortItemRenderer;
	}

	public function set sortItemRenderer(value:IFactory):void {
		_sortItemRenderer=value;

		sortItemRendererChanged=true;
		invalidateSize();
		invalidateDisplayList();

		dispatchEvent(new Event("sortItemRendererChanged"));
	}

	//----------------------------------
	//  listData
	//----------------------------------
	private var _listData:AdvancedDataGridListData;

	[Bindable("dataChange")]
	public function get listData():BaseListData {
		return _listData;
	}

	public function set listData(value:BaseListData):void {
		_listData=AdvancedDataGridListData(value);
		grid=AdvancedDataGrid(_listData.owner);

		invalidateProperties();
	}

	//--------------------------------------------------------------------------
	//  Overridden methods: UIComponent
	//--------------------------------------------------------------------------

	override protected function createChildren():void {
		super.createChildren();

		if (!label) {
			label=IUITextField(createInFontContext(UITextField));
			addChild(DisplayObject(label));
		}

		if (!background) {
			background=new UIComponent();
			addChild(background);
		}
	}

	override protected function commitProperties():void {
		super.commitProperties();

		if (!initialized)
			label.styleName=this;

		if (!sortItemRendererInstance || sortItemRendererChanged) {
			if (!sortItemRenderer)
				sortItemRenderer=ClassFactory(grid.sortItemRenderer);

			if (sortItemRenderer) {
				sortItemRendererInstance=sortItemRenderer.newInstance();

				addChild(DisplayObject(sortItemRendererInstance));
			}

			sortItemRendererChanged=false;
		}

		// Handle skin for the separator between the text and icon parts
		var oldPartsSeparatorSkinClass:Class=partsSeparatorSkinClass;
		if (!partsSeparatorSkinClass || partsSeparatorSkinClass != grid.getStyle("headerSortSeparatorSkin")) {
			partsSeparatorSkinClass=grid.getStyle("headerSortSeparatorSkin");
		}
		if (grid.sortExpertMode || partsSeparatorSkinClass != oldPartsSeparatorSkinClass) {
			if (partsSeparatorSkin)
				removeChild(partsSeparatorSkin);
			if (!grid.sortExpertMode) {
				partsSeparatorSkin=new partsSeparatorSkinClass();
				addChild(partsSeparatorSkin);
			}
		}
		if (partsSeparatorSkin)
			partsSeparatorSkin.visible=!(_data is AdvancedDataGridColumnGroup);

		if (_data != null) {
			label.text=listData.label ? listData.label : " ";
			label.multiline=grid.variableRowHeight;
			if (_data is AdvancedDataGridColumn)
				label.wordWrap=grid.columnHeaderWordWrap(_data as AdvancedDataGridColumn);


			//             if (listData.columnIndex > -1)
			//                 label.wordWrap = grid.columnHeaderWordWrap(grid.columns[listData.columnIndex]);
			else
				label.wordWrap=grid.wordWrap;

			if (_data is AdvancedDataGridColumn) {
				var column:AdvancedDataGridColumn=_data as AdvancedDataGridColumn;

				var dataTips:Boolean=grid.showDataTips;
				if (column.showDataTips == true)
					dataTips=true;
				if (column.showDataTips == false)
					dataTips=false;
				if (dataTips) {
					if (label.textWidth > label.width || column.dataTipFunction || column.dataTipField || grid.dataTipFunction || grid.dataTipField) {
						toolTip=column.itemToDataTip(_data);
					} else {
						toolTip=null;
					}
				} else {
					toolTip=null;
				}
			}
		} else {
			label.text=" ";
			toolTip=null;
		}

		if (sortItemRendererInstance is IInvalidating)
			IInvalidating(sortItemRendererInstance).invalidateProperties();
	}

	/**
	 * @private
	 */
	override protected function measure():void {
		super.measure();

		// Cache padding values
		var paddingLeft:int=getStyle("paddingLeft");
		var paddingRight:int=getStyle("paddingRight");
		var paddingTop:int=getStyle("paddingTop");
		var paddingBottom:int=getStyle("paddingBottom");

		// Measure sortItemRenderer
		var sortItemRendererWidth:Number=sortItemRendererInstance ? sortItemRendererInstance.getExplicitOrMeasuredWidth() : 0;
		var sortItemRendererHeight:Number=sortItemRendererInstance ? sortItemRendererInstance.getExplicitOrMeasuredHeight() : 0;
		if (grid.sortExpertMode && getFieldSortInfo() == null) {
			sortItemRendererWidth=0;
			sortItemRendererHeight=0;
		}

		var horizontalGap:Number=getStyle("horizontalGap");
		if (sortItemRendererWidth == 0)
			horizontalGap=0;

		// Measure text
		var labelWidth:Number=0;
		var labelHeight:Number=0;
		var w:Number=0;
		var h:Number=0;

		// By default, we already get the column's width
		if (!isNaN(explicitWidth)) {
			w=explicitWidth;
			labelWidth=w - sortItemRendererWidth - horizontalGap - (partsSeparatorSkin ? partsSeparatorSkin.width + 10 : 0) - paddingLeft - paddingRight;
			label.width=labelWidth;
			// Inspired by mx.controls.Label#measureTextFieldBounds():
			// In order to display the text completely,
			// a TextField must be 4-5 pixels larger.
			labelHeight=label.textHeight + UITextField.TEXT_HEIGHT_PADDING;
		} else {
			var lineMetrics:TextLineMetrics=measureText(label.text);
			labelWidth=lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
			labelHeight=lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;
			w=labelWidth + horizontalGap + (partsSeparatorSkin ? partsSeparatorSkin.width : 0) + sortItemRendererWidth
		}

		h=Math.max(labelHeight, sortItemRendererHeight);
		h=Math.max(h, (partsSeparatorSkin ? partsSeparatorSkin.height : 0));

		// Add padding
		w+=paddingLeft + paddingRight;
		h+=paddingTop + paddingBottom;

		// Set required width and height
		measuredMinWidth=measuredWidth=w;
		measuredMinHeight=measuredHeight=h;
	}

	/**
	 * @private
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (unscaledWidth == 0)
			return;

		// Cache padding values
		var paddingLeft:int=getStyle("paddingLeft");
		var paddingRight:int=getStyle("paddingRight");
		var paddingTop:int=getStyle("paddingTop");
		var paddingBottom:int=getStyle("paddingBottom");

		// Size of sortItemRenderer
		var sortItemRendererWidth:Number=sortItemRendererInstance ? sortItemRendererInstance.getExplicitOrMeasuredWidth() : 0;
		var sortItemRendererHeight:Number=sortItemRendererInstance ? sortItemRendererInstance.getExplicitOrMeasuredHeight() : 0;
		if (sortItemRendererInstance)
			sortItemRendererInstance.setActualSize(sortItemRendererWidth, sortItemRendererHeight);
		if (grid.sortExpertMode && getFieldSortInfo() == null) {
			sortItemRendererWidth=0;
			sortItemRendererHeight=0;
		}

		var horizontalGap:Number=getStyle("horizontalGap");
		if (sortItemRendererWidth == 0)
			horizontalGap=0;

		// Size of label
		const MINIMUM_SIZE:TextLineMetrics=measureText("w");

		// Adjust to given width
		var lineMetrics:TextLineMetrics=measureText(label.text);
		var labelWidth:Number=lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
		var maxLabelWidth:int=unscaledWidth - sortItemRendererWidth - horizontalGap - paddingLeft - paddingRight;
		if (maxLabelWidth < 0)
			maxLabelWidth=0; // set the max width to 0, if its < 0

		var truncate:Boolean=false;

		if (maxLabelWidth < labelWidth) {
			truncate=true;
			labelWidth=maxLabelWidth;
		}

		// Adjust to given height
		var labelHeight:Number=label.textHeight + UITextField.TEXT_HEIGHT_PADDING;
		var maxLabelHeight:int=unscaledHeight - paddingTop - paddingBottom;

		if (maxLabelHeight < labelHeight) {
			truncate=true;
			labelHeight=maxLabelHeight;
		}

		// Size of label
		// FIXME Seoyeon Lee 망할 놈의 Advanced DataGrid Header Text 잘리는 문제 해결
		//		label.setActualSize(labelWidth, labelHeight);
		label.setActualSize(unscaledWidth, unscaledHeight);

		// truncate only if the truncate flag is set
		if (truncate && !label.multiline)
			label.truncateToFit();

		// Calculate position of label, by default center it
		var labelX:Number;
		var horizontalAlign:String=getStyle("horizontalAlign");
		if (horizontalAlign == "left") {
			labelX=paddingLeft;
		} else if (horizontalAlign == "right") {
			labelX=unscaledWidth - paddingRight - sortItemRendererWidth - horizontalGap - labelWidth;
		} else // if (horizontalAlign == "center")
		{
			labelX=(unscaledWidth - labelWidth - paddingLeft - paddingRight - horizontalGap - sortItemRendererWidth) / 2 + paddingLeft;
		}
		labelX=Math.max(labelX, 0);

		var labelY:Number;
		var verticalAlign:String=getStyle("verticalAlign");
		if (verticalAlign == "top") {
			labelY=paddingTop;
		} else if (verticalAlign == "bottom") {
			labelY=unscaledHeight - labelHeight - paddingBottom + 2; // 2 for gutter
		} else // if (verticalAlign == "middle")
		{
			labelY=(unscaledHeight - labelHeight - paddingBottom - paddingTop) / 2 + paddingTop;
		}
		labelY=Math.max(labelY, 0);

		// Set positions
		label.x=Math.round(labelX);
		label.y=Math.round(labelY);

		if (sortItemRendererInstance) {
			// Calculate position of sortItemRenderer (to the right of the headerRenderer)
			var sortItemRendererX:Number=unscaledWidth - sortItemRendererWidth - paddingRight;
			var sortItemRendererY:Number=(unscaledHeight - sortItemRendererHeight - paddingTop - paddingBottom) / 2 + paddingTop;

			sortItemRendererInstance.x=Math.round(sortItemRendererX);
			sortItemRendererInstance.y=Math.round(sortItemRendererY);
		}

		// Draw the separator
		graphics.clear();
		if (sortItemRendererInstance && !grid.sortExpertMode && !(_data is AdvancedDataGridColumnGroup)) {
			if (!partsSeparatorSkinClass) {
				graphics.lineStyle(1, getStyle("separatorColor") !== undefined ? getStyle("separatorColor") : 0xCCCCCC);
				graphics.moveTo(sortItemRendererInstance.x - 1, 1);
				graphics.lineTo(sortItemRendererInstance.x - 1, unscaledHeight - 1);
			} else {
				partsSeparatorSkin.x=sortItemRendererInstance.x - horizontalGap - partsSeparatorSkin.width;
				partsSeparatorSkin.y=(unscaledHeight - partsSeparatorSkin.height) / 2;
			}
		}

		// Set text color
		var labelColor:Number;

		if (data && parent) {
			if (!enabled)
				labelColor=getStyle("disabledColor");
			else if (grid.isItemHighlighted(listData.uid))
				labelColor=getStyle("textRollOverColor");
			else if (grid.isItemSelected(listData.uid))
				labelColor=getStyle("textSelectedColor");
			else
				labelColor=getStyle("color");

			label.setColor(labelColor);
		}

		// Set background size, position, color
		if (background) {
			background.graphics.clear();
			background.graphics.beginFill(0xFFFFFF, 0.0); // transparent
			background.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			background.graphics.endFill();
			setChildIndex(DisplayObject(background), 0);
		}
	}

	//--------------------------------------------------------------------------
	//  Methods
	//--------------------------------------------------------------------------

	public function mouseEventToHeaderPart(event:MouseEvent):String {
		var point:Point=new Point(event.stageX, event.stageY);
		point=globalToLocal(point);

		// Needs to be in sync with the logic in measure() and updateDisplayList()
		return point.x < sortItemRendererInstance.x ? AdvancedDataGrid.HEADER_TEXT_PART : AdvancedDataGrid.HEADER_ICON_PART;
	}

	protected function getFieldSortInfo():SortInfo {
		return grid.getFieldSortInfo(grid.columns[listData.columnIndex]);
	}

	//--------------------------------------------------------------------------
	//  Event handlers
	//--------------------------------------------------------------------------
	protected function toolTipShowHandler(event:ToolTipEvent):void {
		var toolTip:IToolTip=event.toolTip;
		var xPos:int=DisplayObject(systemManager).mouseX + 11;
		var yPos:int=DisplayObject(systemManager).mouseY + 22;
		// Calculate global position of label.
		var pt:Point=new Point(xPos, yPos);
		pt=DisplayObject(systemManager).localToGlobal(pt);
		pt=DisplayObject(systemManager.getSandboxRoot()).globalToLocal(pt);

		toolTip.move(pt.x, pt.y + (height - toolTip.height) / 2);

		var screen:Rectangle=toolTip.screen;
		var screenRight:Number=screen.x + screen.width;
		if (toolTip.x + toolTip.width > screenRight)
			toolTip.move(screenRight - toolTip.width, toolTip.y);

	}

	mx_internal function getLabel():IUITextField {
		return label;
	}
}
}
