package ssen.components.mxDatagridSupportClasses.datagrid {

import flash.display.DisplayObject;

import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
import mx.controls.advancedDataGridClasses.SortInfo;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.core.IFlexDisplayObject;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;

//----------------------------------------------------------------
// styles
//----------------------------------------------------------------
[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]
[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]
[Style(name="paddingTop", type="Number", format="Length", inherit="no")]
[Style(name="proposedColor", type="uint", format="Color", inherit="yes")]

//----------------------------------------------------------------
// skins
//----------------------------------------------------------------
[Style(name="icon", type="Class", inherit="no")]

/** 
 * AdvancedDataGridHeaderRenderer의 기본 SortItemRenderer가 너무 많은 공간을 차지하는 것을 해결한 SortItemRenderer
 * 상속 처리가 불가해서 Clone한 코드
 */
public class ADGSortItemRenderer extends UIComponent {

	public function ADGSortItemRenderer() {
		super();
		visible=false;
	}

	//--------------------------------------------------------------------------
	//  Variables
	//--------------------------------------------------------------------------
	mx_internal var icon:IFlexDisplayObject;
	mx_internal var iconName:String="icon";

	//	protected var label:IUITextField;

	//--------------------------------------------------------------------------
	//  Properties
	//--------------------------------------------------------------------------   
	//----------------------------------
	//  descending
	//----------------------------------
	private var _descending:Boolean=false;

	public function get descending():Boolean {
		return _descending;
	}

	public function set descending(value:Boolean):void {
		if (_descending != value) {
			_descending=value;

			invalidateDisplayList();
		}
	}

	//--------------------------------------------------------------------------
	//  Overridden methods: UIComponent
	//--------------------------------------------------------------------------
	override protected function createChildren():void {
		super.createChildren();

		//		if (!label) {
		//			label=IUITextField(createInFontContext(UITextField));
		//			label.styleName=this;
		//			addChild(DisplayObject(label));
		//		}

		if (!icon) {
			var iconClass:Class=ADGSortArrow;
			//			 DataGridSortArrow
			if (iconClass) {
				icon=new iconClass();
				icon.name=iconName;
				if (icon is ISimpleStyleClient)
					ISimpleStyleClient(icon).styleName=this;
				addChild(DisplayObject(icon));
			}
		}
	}

	override protected function commitProperties():void {
		super.commitProperties();

		//		// Font styles
		//		getFontStyles();
		//
		// Whether the current column is sorted or not, and if so what info to
		// display
		var sortInfo:SortInfo=getFieldSortInfo();
		if (sortInfo) {
			visible=true;
			//
			//			label.text=(sortInfo.sequenceNumber).toString();
			//
			//			if (sortInfo.status == SortInfo.PROPOSEDSORT)
			//				label.setColor(getStyle("proposedColor") !== undefined ? getStyle("proposedColor") : 0x999999);
			//			else
			//				label.setColor(getStyle("color") !== undefined ? getStyle("color") : 0x000000);
			//
			descending=sortInfo.descending;
		} else {
			visible=false;
		}
	}

	override protected function measure():void {
		super.measure();

		// Cache padding values
		var paddingLeft:int=getStyle("paddingLeft");
		var paddingRight:int=getStyle("paddingRight");
		var paddingTop:int=getStyle("paddingTop");
		var paddingBottom:int=getStyle("paddingBottom");

		//		// Measure label
		//		// if text is empty string, use '2' as default text for measuring
		//		// for empty string, measureText() returns height as 15
		//		var lineMetrics:TextLineMetrics=measureText(label.length == 0 ? "2" : label.text);
		//
		//		// Inspired by mx.controls.Label#measureTextFieldBounds():
		//		// In order to display the text completely,
		//		// a TextField must be 4-5 pixels larger.
		//		var labelWidth:Number=lineMetrics.width + UITextField.TEXT_WIDTH_PADDING;
		//		var labelHeight:Number=lineMetrics.height + UITextField.TEXT_HEIGHT_PADDING;

		// Measure icon
		//		trace("ADGSortItemRenderer.measure(", icon, ")");
		var iconWidth:Number=icon ? icon.width : 0;
		var iconHeight:Number=icon ? icon.height : 0;

		var horizontalGap:Number=getStyle("horizontalGap");
		if (iconWidth == 0)
			horizontalGap=0;

		// Sum measurements of children
		//		var w:Number=labelWidth + horizontalGap + iconWidth;
		//		var h:Number=Math.max(labelHeight, iconHeight);
		var w:Number=horizontalGap + iconWidth;
		var h:Number=iconHeight;

		// Add padding
		w+=getStyle("paddingLeft") + getStyle("paddingRight");
		h+=getStyle("paddingTop") + getStyle("paddingBottom");

		// Set required width and height
		measuredMinWidth=measuredWidth=w;
		measuredMinHeight=measuredHeight=h;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		// It seems strange to get a zero-width display,
		// is there a need to handle this case?
		if (unscaledWidth == 0)
			return;

		// Cache padding values
		var paddingLeft:int=getStyle("paddingLeft");
		var paddingRight:int=getStyle("paddingRight");
		var paddingTop:int=getStyle("paddingTop");
		var paddingBottom:int=getStyle("paddingBottom");

		// Size of icon
		// Assumption that iconWidth < unscaledWidth
		// and iconHeight < unscaledHeight
		var iconWidth:Number=icon ? icon.width : 0;
		var iconHeight:Number=icon ? icon.height : 0;

		var horizontalGap:Number=getStyle("horizontalGap");
		if (iconWidth == 0)
			horizontalGap=0;

		//		// Size of label
		//		var labelWidth:Number=unscaledWidth - iconWidth - horizontalGap - paddingLeft - paddingRight;
		//		var labelHeight:Number=unscaledHeight - paddingTop - paddingBottom;
		//		label.setActualSize(labelWidth, labelHeight);
		//
		//		// Calculate position of label
		//		var labelX:Number=paddingLeft;
		//		var labelY:Number=(unscaledHeight - label.height - paddingTop - paddingBottom) / 2 + paddingTop;
		//		labelY=Math.max(labelY, 0);
		//
		//		// Set positions
		//		label.x=Math.round(labelX);
		//		label.y=Math.round(labelY);

		// Calculate position of icon
		if (icon) {
			var iconX:Number=unscaledWidth - iconWidth - paddingRight;
			var iconY:Number=(unscaledHeight - iconHeight - paddingTop - paddingBottom) / 2 + paddingTop;
			icon.x=Math.round(iconX);
			icon.y=Math.round(iconY);

			// Default is false i.e. ascending order
			if (!descending) {
				icon.scaleY=-1.0;
				icon.y+=iconHeight;
			} else {
				icon.scaleY=1.0;
			}
		}
	}

	//--------------------------------------------------------------------------
	//  Methods
	//--------------------------------------------------------------------------
	protected function getFontStyles():void {
		var gridStyle:*=undefined;

		if (grid) {
			gridStyle=grid.getStyle("sortFontFamily");
			if (gridStyle !== undefined)
				setStyle("fontFamily", gridStyle);
			gridStyle=grid.getStyle("sortFontSize");
			if (gridStyle !== undefined)
				setStyle("fontSize", gridStyle);
			gridStyle=grid.getStyle("sortFontStyle");
			if (gridStyle !== undefined)
				setStyle("fontStyle", gridStyle);
			gridStyle=grid.getStyle("sortFontWeight");
			if (gridStyle !== undefined)
				setStyle("fontWeight", gridStyle);
		}
	}

	protected function getFieldSortInfo():SortInfo {
		// Parent is the header renderer.
		if (grid && parent is IDropInListItemRenderer) {
			var listData:AdvancedDataGridListData=(parent as IDropInListItemRenderer).listData as AdvancedDataGridListData;
			if (listData && listData.columnIndex != -1)
				return grid.getFieldSortInfo(grid.columns[listData.columnIndex]);
		}

		return null;
	}

	protected function get grid():AdvancedDataGrid {
		if (parent && IUIComponent(parent).owner && IUIComponent(parent).owner is AdvancedDataGrid)
			return IUIComponent(parent).owner as AdvancedDataGrid;
		else
			return null;
	}

} // end class AdvancedDataGridSortItemRenderer

}


