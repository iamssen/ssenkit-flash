package ssen.flexkit.components.grid.elements {
import spark.components.DataGrid;
import spark.components.Group;

[Style(name="paddingLeft", inherit="no", type="int")]
[Style(name="paddingRight", inherit="no", type="int")]
[Style(name="paddingTop", inherit="no", type="int")]
[Style(name="paddingBottom", inherit="no", type="int")]

public class GroupRowElement extends Group implements IDataGridRowElement {
	protected var helper:RowElementController;

	public function GroupRowElement() {
		helper=new RowElementController;
		helper.rowElement=this;
		helper.draw=draw;

		clipAndEnableScrolling=true;
	}

	public function get dataGrid():DataGrid {
		return helper.dataGrid;
	}

	public function set dataGrid(value:DataGrid):void {
		helper.dataGrid=value;
		layout.clearVirtualLayoutCache();
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		helper.updateDisplayList(unscaledWidth, unscaledHeight);
	}

	protected function draw(sizeChanged:Boolean, scrollChanged:Boolean, collectionChanged:Boolean):void {
	}
}
}
