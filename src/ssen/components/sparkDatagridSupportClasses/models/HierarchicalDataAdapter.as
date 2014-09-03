package ssen.flexkit.components.grid.models {
import flash.events.EventDispatcher;

import mx.collections.CursorBookmark;
import mx.collections.IHierarchicalCollectionView;
import mx.collections.IHierarchicalCollectionViewCursor;
import mx.collections.IList;
import mx.collections.IViewCursor;
import mx.events.CollectionEvent;

public class HierarchicalDataAdapter extends EventDispatcher implements IList {
	private var view:IHierarchicalCollectionView;
	private var viewCursor:IHierarchicalCollectionViewCursor;
	private var currentIndex:int;

	public function HierarchicalDataAdapter(hierarchicalCollectionView:IHierarchicalCollectionView) {
		view=hierarchicalCollectionView;

		hierarchicalCollectionView.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);
		viewCursor=hierarchicalCollectionView.createCursor() as IHierarchicalCollectionViewCursor;
		currentIndex=length - 1;
	}

	public function get length():int {
		return view.length;
	}

	public function get hierarchicalCollectionView():IHierarchicalCollectionView {
		return view;
	}

	public function addItem(item:Object):void {
		viewCursor.seek(CursorBookmark.LAST);
		viewCursor.insert(item);
		currentIndex=length;
	}

	public function addItemAt(item:Object, index:int):void {
		viewCursor.seek(CursorBookmark.FIRST, index);
		viewCursor.insert(item);
		currentIndex=index;
	}

	public function getItemAt(index:int, prefetch:int=0):Object {
		if (index == currentIndex)
			return viewCursor.current;

		if (currentIndex + 1 == index) {
			viewCursor.moveNext();
			currentIndex++;
			return viewCursor.current;
		}
		if (currentIndex - 1 == index) {
			viewCursor.movePrevious();
			currentIndex--;
			return viewCursor.current;
		}

		if (index < length - index)
			viewCursor.seek(CursorBookmark.FIRST, index);
		else
			viewCursor.seek(CursorBookmark.LAST, index - length);
		currentIndex=index;
		return viewCursor.current;
	}

	public function getItemIndex(item:Object):int {
		if (viewCursor.current === item)
			return currentIndex;

		if (viewCursor.findFirst(item)) {
			if ("index" in viewCursor) {
				currentIndex=viewCursor["index"];
			} else {
				var bookmark:CursorBookmark=viewCursor.bookmark;
				currentIndex=bookmark.getViewIndex();
				if (currentIndex == -1)
					trace("getViewIndex may not be supported by this IViewCursor")
			}
			return currentIndex;
		} else {
			viewCursor.seek(CursorBookmark.FIRST);
			currentIndex=0;
		}
		return -1;
	}

	public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void {
		view.itemUpdated(item, property, oldValue, newValue);
	}

	public function removeAll():void {
		currentIndex=0;
		viewCursor.seek(CursorBookmark.FIRST);
		while (view.length > 0) {
			viewCursor.remove();
		}
	}

	public function removeItemAt(index:int):Object {
		var old:Object=getItemAt(index);
		viewCursor.remove();
		currentIndex=length > 0 ? index : -1;
		return old;
	}

	public function setItemAt(item:Object, index:int):Object {
		var old:Object=getItemAt(index);
		viewCursor.remove();
		viewCursor.insert(item);
		return old;
	}

	public function toArray():Array {
		var arr:Array=[];
		var temp:IViewCursor=view.createCursor();
		while (!temp.afterLast) {
			arr.push(temp.current);
			temp.moveNext();
		}
		return arr;
	}

	private function collectionChangeHandler(event:CollectionEvent):void {
		if ("index" in viewCursor) {
			currentIndex=viewCursor["index"];
		} else {
			var bookmark:CursorBookmark=viewCursor.bookmark;
			currentIndex=bookmark.getViewIndex();
			if (currentIndex == -1)
				trace("getViewIndex may not be supported by this IViewCursor")
		}
		if (currentIndex == -1 && length > 0) {
			viewCursor.seek(CursorBookmark.FIRST);
			currentIndex=0;
		}
		dispatchEvent(event);
	}
}
}
