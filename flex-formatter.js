var str = 'name\=properties|sort\=11|includeStates\=true|wrap\=54|attrs\=allowDisjointSelection,allowMultipleSelection,allowThumbOverlap,allowTrackClick,autoLayout,autoRepeat,automationName,cachePolicy,class,clipContent,condenseWhite,conversion,creationIndex,creationPolicy,currentState,data,dataDescriptor,dataProvider,dataTipFormatFunction,dayNames,defaultButton,direction,disabledDays,disabledRanges,displayedMonth,displayedYear,doubleClickEnabled,emphasized,enabled,explicitHeight,explicitMaxHeight,explicitMaxWidth,explicitMinHeight,explicitMinWidth,explicitWidth,firstDayOfWeek,focusEnabled,fontContext,height,horizontalLineScrollSize,horizontalPageScrollSize,horizontalScrollBar,horizontalScrollPolicy,horizontalScrollPosition,htmlText,icon,iconField,id,imeMode,includeInLayout,indeterminate,label,labelField,labelFunction,labelPlacement,labels,layout,lineScrollSize,listData,liveDragging,maxChars,maxHeight,maxScrollPosition,maxWidth,maxYear,maximum,measuredHeight,measuredMinHeight,measuredMinWidth,measuredWidth,menuBarItemRenderer,menuBarItems,menus,minWidth,minHeight,minScrollPosition,minYear,minimum,mode,monthNames,monthSymbol,mouseFocusEnabled,pageScrollSize,pageSize,percentHeight,percentWidth,scaleX,scaleY,scrollPosition,selectable,selectableRange,selected,selectedDate,selectedField,selectedIndex,selectedRanges,showDataTip,showRoot,showToday,sliderDataTipClass,sliderThumbClass,snapInterval,source,states,stepSize,stickyHighlighting,styleName,text,thumbCount,tickInterval,tickValues,toggle,toolTip,transitions,truncateToFit,validationSubField,value,verticalLineScrollSize,verticalPageScrollSize,verticalScrollBar,verticalScrollPolicy,verticalScrollPosition,width,x,y,yearNavigationEnabled,yearSymbol,|data\=-1|\nname\=xml_namespaces|sort\=11|includeStates\=true|wrap\=54|attrs\=xmlns,xmlns\:.*,|data\=-1|\nname\=events|sort\=11|includeStates\=true|wrap\=54|attrs\=add,added,activate,addedToStage,buttonDown,change,childAdd,childIndexChange,childRemove,clickHandler,clear,click,complete,contextMenu,copy,creationComplete,currentStateChange,currentStateChanging,cut,dataChange,deactivate,doubleClick,dragComplete,dragDrop,dragEnter,dragExit,dragOver,dragStart,effectEnd,effectStart,enterFrame,enterState,exitFrame,exitState,focusIn,focusOut,frameConstructed,hide,httpStatus,init,initialize,invalid,ioError,itemClick,itemRollOut,itemRollOver,keyDown,keyFocusChange,keyUp,menuHide,menuShow,middleClick,middleMouseDown,middleMouseUp,mouseDown,mouseUp,mouseOver,mouseMove,mouseOut,mouseFocusChange,mouseWheel,mouseDownOutside,mouseWheelOutside,move,nativeDragComplete,nativeDragDrop,nativeDragEnter,nativeDragExit,nativeDragOver,nativeDragStart,nativeDragUpdate,open,paste,preinitialize,progress,record,remove,removed,removedFromStage,render,resize,rightClick,rightMouseDown,rightMouseUp,rollOut,rollOver,scroll,securityError,selectAll,show,tabChildrenChange,tabEnabledChange,tabIndexChange,thumbDrag,thumbPress,thumbRelease,toolTipCreate,toolTipEnd,toolTipHide,toolTipShow,toolTipShown,toolTipStart,updateComplete,unload,valid,valueCommit,|data\=-1|\nname\=styles|sort\=11|includeStates\=true|wrap\=54|attrs\=backgroundAlpha,backgroundAttachment,backgroundColor,backgroundDisabledColor,backgroundImage,backgroundSize,backgroundSkin,barColor,barSkin,borderColor,borderSides,borderSkin,borderStyle,borderThickness,bottom,color,cornerRadius,dataTipOffset,dataTipPrecision,dataTipStyleName,disabledColor,disabledIcon,disabledIconColor,disabledSkin,disbledOverlayAlpha,downArrowDisabledSkin,downArrowDownSkin,downArrowOverSkin,downArrowUpSkin,downIcon,downSkin,dropShadowColor,dropShadowEnabled,errorColor,fillAlphas,fillColors,focusAlpha,focusBlendMode,focusRoundedCorners,focusSkin,focusThickness,fontAntiAliasType,fontFamily,fontGridFitType,fontSharpness,fontSize,fontStyle,fontThickness,fontWeight,fontfamily,headerColors,headerStyleName,highlightAlphas,horizontalAlign,horizontalCenter,horizontalGap,horizontalScrollBarStyleName,icon,iconColor,indeterminateMoveInterval,indeterminateSkin,itemDownSkin,itemOverSkin,itemUpSkin,kerning,labelOffset,labelStyleName,labelWidth,leading,left,letterSpacing,maskSkin,menuStyleName,nextMonthDisabledSkin,nextMonthDownSkin,nextMonthOverSkin,nextMonthSkin,nextMonthUpSkin,nextYearDisabledSkin,nextYearDownSkin,nextYearOverSkin,nextYearSkin,nextYearUpSkin,overIcon,overSkin,paddingBottom,paddingLeft,paddingRight,paddingTop,prevMonthDisabledSkin,prevMonthDownSkin,prevMonthOverSkin,prevMonthSkin,prevMonthUpSkin,prevYearDisabledSkin,prevYearDownSkin,prevYearOverSkin,prevYearSkin,prevYearUpSkin,repeatDelay,repeatInterval,right,rollOverColor,rollOverIndicatorSkin,selectedDisabledIcon,selectedDisabledSkin,selectedDownIcon,selectedDownSkin,selectedOverIcon,selectedOverSkin,selectedUpIcon,selectedUpSkin,selectionColor,selectionIndicatorSkin,shadowColor,shadowDirection,shadowDistance,showTrackHighlight,skin,slideDuration,slideEasingFunction,strokeColor,strokeWidth,textAlign,textDecoration,textIndent,textRollOverColor,textSelectedColor,themeColor,thumbDisabledSkin,thumbDownSkin,thumbIcon,thumbOffset,thumbOverSkin,thumbUpSkin,tickColor,tickLength,tickOffset,tickThickness,todayColor,todayIndicatorSkin,todayStyleName,top,tracHighlightSkin,trackColors,trackHeight,trackMargin,trackSkin,upArrowDisabledSkin,upArrowDownSkin,upArrowOverSkin,upArrowUpSkin,upIcon,upSkin,verticalAlign,verticalCenter,verticalGap,verticalScrollBarStyleName,weekDayStyleName,|data\=-1|\nname\=effects|sort\=11|includeStates\=true|wrap\=54|attrs\=addedEffect,completeEffect,creationCompleteEffect,focusInEffect,focusOutEffect,hideEffect,mouseDownEffect,mouseUpEffect,moveEffect,removedEffect,resizeEffect,rollOutEffect,rollOverEffect,showEffect,|data\=-1|\nname\=Special_Group--Other Attributes|sort\=11|includeStates\=true|wrap\=54|attrs\=|data\=-1|\n'

var groups = str.split('\n')
var f = -1, fmax = groups.length

var yaml = []

while(++f < fmax) {
	var group = groups[f]

	if (group == '') {
		continue;
	}

	var props = group.split('|')
	var s = -1, smax = props.length

	yaml.push('#------------------------------------------------')

	while(++s < smax) {
		var prop = props[s]
		var kv = prop.split('=')
		var name = kv[0]
		var value = kv[1]

		if (name === 'attrs') {
			var attrs = value.split(',')
			var th = -1, thmax = attrs.length

			yaml.push('  attrs:')

			while (++th < thmax) {
				var attr = attrs[th]

				if (!attr || attr == '') {
					continue;
				}
				yaml.push('  - ' + attr)
			}
		} else {
			if (!name || name == '') {
				continue;
			} if (s === 0) {
				yaml.push('- ' + name + ': ' + value)
			} else {
				yaml.push('  ' + name + ': ' + value)
			}
		}
	}
}

console.log(yaml.join('\n'))

