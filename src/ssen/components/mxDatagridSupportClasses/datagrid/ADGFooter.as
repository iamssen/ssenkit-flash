package ssen.components.mxDatagridSupportClasses.datagrid {
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.utils.getQualifiedClassName;

import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.UIComponent;
import mx.utils.ColorUtil;

[DefaultProperty("columns")]

/** 배경색 */
[Style(name="backgroundColor", inherit="no", type="uint")]

/** ADG에 Footer 기능을 추가한다 */
public class ADGFooter extends UIComponent {
	/** @private */
	internal var grid:ADG;

	/** Footer Columns */
	[Inspectable(arrayType="ssen.components.mxDatagridSupportClasses.datagrid.ADGFooterColumn")]
	public var columns:Array;

	//==========================================================================================
	// render
	//==========================================================================================
	/** @private */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (!grid.columns || !columns) {
			return;
		}

		var g:Graphics=graphics;
		var hlineColor:uint=grid.getStyle("horizontalGridLineColor");
		var vlineColor:uint=grid.getStyle("verticalGridLineColor");
		var bgColor:uint=grid.getStyle("backgroundColor") || 0xeeeeee;

		//		trace("ADGFooter.updateDisplayList(", unscaledWidth, unscaledHeight, ")");
		//		trace("ADGFooter.updateDisplayList(", hlineColor.toString(16), vlineColor.toString(16), bgColor.toString(16), ")");

		g.clear();
		removeAllChildren();

		//----------------------------------------------------------------
		// background
		//----------------------------------------------------------------
		g.beginFill(bgColor);
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.endFill();

		//----------------------------------------------------------------
		// hline
		//----------------------------------------------------------------
		g.beginFill(ColorUtil.adjustBrightness2(hlineColor, -30));
		g.drawRect(0, 0, unscaledWidth, 1);
		g.endFill();

		//----------------------------------------------------------------
		// vline and rendering
		//----------------------------------------------------------------
		var f:int=grid.horizontalScrollPosition - 1;
		var fmax:int=grid.columns.length;
		var column:AdvancedDataGridColumn;
		var footerColumn:ADGFooterColumn;

		var nx:Number=0;
		var tx:Number;
		var ty:Number;
		var tw:Number;
		var th:Number;
		var txt:Array=[];
		var renderer:IListItemRenderer;

		var drawInit:Boolean=false;

		g.beginFill(ColorUtil.adjustBrightness2(vlineColor, -30));

		while (++f < fmax) {
			column=grid.columns[f];
			footerColumn=columns[f];

			// calculate rect
			ty=3;
			tx=nx;
			tw=column.width;
			th=unscaledHeight - 3;

			// draw vertical line
			if (nx !== 0 && (drawInit || (getQualifiedClassName(footerColumn) !== "ssen.components.mxDatagridSupportClasses.datagrid::ADGFooterColumn" && getQualifiedClassName(footerColumn) !== "ssen.components.mxDatagridSupportClasses.datagrid::ADGFooterTextColumn"))) {
				g.drawRect(int(nx), 0, 1, unscaledHeight);

				tx=tx + 1;
				tw=tw - 1;

				drawInit=true;
			}

			if (column && footerColumn) {
				renderer=footerColumn.render(grid, f);

				if (renderer) {
					renderer.x=tx;
					renderer.y=ty;
					renderer.setActualSize(tw, th);
					//					UIComponent(renderer).setStyle("paddingTop", 5);

					addChild(renderer as DisplayObject);

					if (renderer is UIComponent) {
						UIComponent(renderer).validateNow();
					}
				}
			}

			nx+=column.width;

			txt.push(column.headerText);
		}

		g.endFill();
		//		trace("ADGFooter.updateDisplayList(", txt.join(", "), ")");
	}

	private function removeAllChildren():void {
		var f:int=numChildren;
		var child:DisplayObject;
		while (--f >= 0) {
			child=getChildAt(f);
			removeChild(child);
		}
	}

	//	override public function get width():Number {
	//		return 0;
	//	}
	//
	//	override public function get height():Number {
	//		return 0;
	//	}
}
}
