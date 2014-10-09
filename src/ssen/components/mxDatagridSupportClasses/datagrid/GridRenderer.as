package ssen.components.mxDatagridSupportClasses.datagrid {
import mx.controls.advancedDataGridClasses.AdvancedDataGridItemRenderer;
import mx.events.ToolTipEvent;

/** Grid Item Renderer Base Class */
public class GridRenderer extends AdvancedDataGridItemRenderer {
	public function GridRenderer() {
		setStyle("fontSize", 12);
	}

	/** [Block] 기본 아이템 렌더러의 툴팁이 괴상한 위치에 표시되는 것을 방지 */
	override protected function toolTipShowHandler(event:ToolTipEvent):void {
	}

	/** 텍스트 포맷팅 함수 : 기본 Grid 출력시 이외에도 Excel(csv) 파일을 포맷팅 하는데도 사용된다 */
	public function format(value:*):String {
		return value;
	}
}
}
