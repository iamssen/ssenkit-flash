package ssen.components.grid.headers {
import ssen.common.IDisposable;

public interface IHeaderColumnRenderer {
	function draw(container:IHeaderElement, column:IHeaderColumn):IDisposable;
}
}
