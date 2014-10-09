package ssen.components.mxDatagridSupportClasses.datagrid {
import flash.events.ContextMenuEvent;
import flash.net.FileReference;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import flash.utils.ByteArray;

import mx.collections.IList;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.core.IMXMLObject;

/** ADG에 Context Menu 기능을 추가한다 */
public class ADGContextMenuAddon implements IMXMLObject {
	private var grid:ADG;

	/** @private */
	public function initialized(document:Object, id:String):void {
		grid=document as ADG;

		// create context menu items
		var downloadExcel:ContextMenuItem=new ContextMenuItem("엑셀 다운로드");
		downloadExcel.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, downloadExcelHandler, false, 0, true);

		// create context menu
		var customContextMenu:ContextMenu=new ContextMenu;
		customContextMenu.hideBuiltInItems();
		customContextMenu.customItems=[downloadExcel];

		// set context menu
		grid.contextMenu=customContextMenu;
	}

	//==========================================================================================
	// Excel Download
	//==========================================================================================
	private function downloadExcelHandler(event:ContextMenuEvent):void {
		var list:IList=grid.dataProvider as IList;
		var columns:Array=grid.columns;
		var renderers:Vector.<GridRenderer>=new Vector.<GridRenderer>(columns.length, true);

		var data:Object;
		var column:AdvancedDataGridColumn;
		var renderer:Object;

		var row:Vector.<String>=new Vector.<String>;
		var rows:Vector.<String>=new Vector.<String>;

		var value:String;

		var f:int=-1;
		var fmax:int=list.length;
		var s:int;
		var smax:int;


		s=-1;
		smax=columns.length;
		while (++s < smax) {
			column=columns[s];
			row.push(removeLineBreak(column.headerText));

			renderer=column.itemRenderer.newInstance();

			if (renderer is GridRenderer) {
				renderers[s]=renderer as GridRenderer;
			}
		}
		rows.push(row.join(","));

		while (++f < fmax) {
			data=list.getItemAt(f);
			row.length=0;

			s=-1;
			smax=columns.length;
			while (++s < smax) {
				column=columns[s];

				if (renderers[s]) {
					row.push(removeLineBreak(renderers[s].format(data[column.dataField])));
				} else {
					row.push(removeLineBreak(data[column.dataField]));
				}
			}
			rows.push(row.join(","));
		}

		var bytes:ByteArray=new ByteArray;
		//		bytes.writeUTFBytes(rows.join("\n"));
		bytes.writeMultiByte(rows.join("\n"), "euc-kr");

		var ref:FileReference=new FileReference;
		ref.save(bytes, "excel.csv");
	}

	private function removeLineBreak(str:String):String {
		return str.replace(/\n/g, " ");
	}
}
}
