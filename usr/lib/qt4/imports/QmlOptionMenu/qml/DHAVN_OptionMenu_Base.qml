// { modified by Sergey 09.11.2013 for ITS#207936
import QtQuick 1.0
import "DHAVN_OptionMenu.js" as CONST
import "DHAVN_LayersList.js" as LayersList
import QmlStatusBar 1.0 //modified by edo.lee 2013.04.04
import Qt.labs.gestures 2.0

Item
{
    id: optionmenubase

    x:0
    y:93
    width: CONST.const_DISPLAY_WIDHT
    height: CONST.const_DISPLAY_HEIGTH

// public
    property string type: CONST.const_OPTION_MENU

    property bool focus_visible: false
    property int focus_id: -1
    property bool is_focusable: true
    property int focus_index: 0

    property bool autoHiding: false
    property alias autoHideInterval: disappearTimer.interval
    property QtObject menumodel
    property int level: LayersList.count()
    property bool bAVPMode: false // DUAL_KEY
//private
    property variant component
    property bool middleEast: false // added by Dmitry 29.04.13
    property bool scrollingTicker //[ISV][64532][C](aettie.ji)
    property bool pressed: false //added by junam 2013.07.06 for timeover

//signals
    signal textItemSelect( variant itemId )
    signal checkBoxSelect( variant itemId, variant flag )
    signal radioBtnSelect( variant itemId )
    signal nextMenuSelect( variant itemId )
    signal isHidden();
    signal lostFocus( int arrow, int focusID );
    signal beep(); // added by Sergey 02.11.2013 for ITS#205776
    signal qmlLog(string Log); // added by oseong.kwon 2014.08.04 for show Log

    // { added by oseong.kwon 2014.08.04 for show Log
    function __LOG(Log)
    {
       qmlLog( "DHAVN_OptionMenu_Base.qml: " + Log );
    }
    // } added by oseong.kwon 2014.08.04

    function hideFocus() { focus_visible = false }
    function showFocus() { focus_visible = true }

    function setDefaultFocus( arrow )
    {
       if (LayersList.count() > 0) // modified by Dmitry 17.07.2013
          LayersList.top().layer.setDefaultFocus( arrow )
    }

    function onLostFocus(arrow, focusID)
    {
       lostFocus(arrow, focusID)
    }

// added by radhakrushna 25.07.2013  ITS # 181433
    function disableMenu(  )
    {
       if (LayersList.count() > 0)
          LayersList.top().layer.disabled = true;
    }
// added by radhakrushna 25.07.2013 


    /* Return type: string
     * Return values: "TopListLayer", "AmongListLayers", "OutOfList"
      */
    function areaType(x, y)
    {
        var result = "TopListLayer";

        if (!middleEast)
        {
            // added by suil.you 20130909 for ITS 0188607 START
            switch(LayersList.count())
            {
                case 1:
                {
                    if ( (y >= 93  && y <= CONST.const_DISPLAY_HEIGTH) &&
                            (x >= 0 && x <= CONST.const_DISPLAY_WIDHT - (CONST.const_OPTION_MENU_ITEM_WIDTH_L0+CONST.const_OPTION_MENU_ITEM_SCROLL_WIDTH)))
                    {
                        result = "OutOfList";
                    }
                    break;
                }
                case 2:
                {
                    if ( (y >= 93  && y <= CONST.const_DISPLAY_HEIGTH) &&
                            (x >= 0 && x <= CONST.const_DISPLAY_WIDHT - CONST.const_OPTION_MENU_ITEM_WIDTH_L1_TAP_AREA))
                    {
                        result = "OutOfList";
                    }
                    else if((y >= 93  && y <= CONST.const_DISPLAY_HEIGTH) &&
                            (x > CONST.const_DISPLAY_WIDHT - CONST.const_OPTION_MENU_ITEM_WIDTH_L1_TAP_AREA && x < CONST.const_DISPLAY_WIDHT - (CONST.const_OPTION_MENU_ITEM_WIDTH_L0+CONST.const_OPTION_MENU_ITEM_SCROLL_WIDTH)))
                    {
                        result = "AmongListLayers";
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }

        }
        else
        {
            switch(LayersList.count())
            {
                case 1:
                {
                    if ( (y >= 93  && y <= CONST.const_DISPLAY_HEIGTH) &&
                            (x >= (CONST.const_OPTION_MENU_ITEM_WIDTH_L0+CONST.const_OPTION_MENU_ITEM_SCROLL_WIDTH) && x <= CONST.const_DISPLAY_WIDHT))
                    {
                        result = "OutOfList";
                    }
                    break;
                }
                case 2:
                {
                    if ( (y >= 93  && y <= CONST.const_DISPLAY_HEIGTH) &&
                            (x >= CONST.const_OPTION_MENU_ITEM_WIDTH_L1_TAP_AREA && x <= CONST.const_DISPLAY_WIDHT)) // modified by Sergey 24.09.2013 for ITS#191247
                    {
                        result = "OutOfList";
                    }
                    else if((y >= 93  && y <= CONST.const_DISPLAY_HEIGTH) &&
                            (x > (CONST.const_OPTION_MENU_ITEM_WIDTH_L0+CONST.const_OPTION_MENU_ITEM_SCROLL_WIDTH)  && x < CONST.const_OPTION_MENU_ITEM_WIDTH_L1_TAP_AREA))
                    {
                        result = "AmongListLayers";
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        return result;
    }


	//added by edo.lee 2013.05.03
	QmlStatusBar {
		id: statusBar
		x: 0; 
		y: -93;
		z: 1000
		width: 1280; 
		height: 93;
		homeType: "button"
		middleEast: optionmenubase.middleEast //[ME][ITS][177647][minor](aettie.ji)
	}//added by edo.lee 2013.05.03
	
    Rectangle
    {
        id: bg // added by Sergey 02.08.2013 for ITS#181512
	
        width: CONST.const_DISPLAY_WIDHT
        height: CONST.const_DISPLAY_HEIGTH
	//modified by aettie.ji ux fix 20130926
//        color: Qt.rgba( 0, 0, 0, CONST.const_OPTION_MENU_BLACKOUT_1 )
        color: Qt.rgba( 255, 255, 255, 0 )
	// removed by Sergey 02.08.2013 for ITS#181512

        Behavior on opacity { PropertyAnimation { duration: 100 } } // modified by Sergey 28.05.2013
        

       GestureArea
        {
            id: gestureArea
           anchors.fill: parent

           // Values: "TopListLayer", "AmongListLayers", "OutOfList"
           property string sPressedArea: "TopListLayer"

           Tap
           {
               onStarted:
               {
                   gestureArea.sPressedArea = areaType(gesture.position.x, gesture.position.y);

                   __LOG("GestureArea Tap onStarted area = " + gestureArea.sPressedArea);
               }

               onFinished:
               {
                   if (autoHiding)
                       disappearTimer.restart()

                   var releasedArea = areaType(gesture.position.x, gesture.position.y);

                   __LOG("GestureArea Tap onFinished area = " + releasedArea);

                   if(releasedArea == "OutOfList")
                   {
                       optionmenubase.beep(); // added by Sergey 02.11.2013 for ITS#205776
                       hide();
                   }
                   else if(releasedArea == "AmongListLayers")
                   {
                       optionmenubase.beep(); // added by Sergey 02.11.2013 for ITS#205776
                       backLevel();
                   }
                   else if(releasedArea == "TopListLayer")
                   {
                       // Will be handled by ListView
                   }
               }
           }

            Pan
            {
                onStarted:
                {
                    __LOG("GestureArea Pan onStarted")
                }

                onFinished:
                {
                    __LOG("GestureArea Pan onFinished area = " + gestureArea.sPressedArea + " deltaX = " + gesture.offset.x + " deltaY = " + gesture.offset.y);

                    if (autoHiding)
                        disappearTimer.restart()

                    if (!middleEast){

                        if (gesture.offset.x > 100 && Math.abs(gesture.offset.y) < 300)
                        {
                            destroyTopLayer();
                        }
                        else if(Math.abs(gesture.offset.x) < 100 && Math.abs(gesture.offset.y) < 100)
                        {
                            if(gestureArea.sPressedArea == "OutOfList" )
                            {
                                optionmenubase.beep(); // added by Sergey 02.11.2013 for ITS#205776
                                hide();
                            }
                            else if(gestureArea.sPressedArea == "AmongListLayers")
                            {
                                optionmenubase.beep(); // added by Sergey 02.11.2013 for ITS#205776
                                backLevel();
                            }
                        }
                    }
                    else 
                    {
                        if (gesture.offset.x < -100 && Math.abs(gesture.offset.y) < 300)
                        {
                            destroyTopLayer();
                        }
                        else if(Math.abs(gesture.offset.x) < 100 && Math.abs(gesture.offset.y) < 100)
                        {
                            if(gestureArea.sPressedArea == "OutOfList" )
                            {
                                optionmenubase.beep(); // added by Sergey 02.11.2013 for ITS#205776
                                hide();
                            }
                            else if(gestureArea.sPressedArea == "AmongListLayers")
                            {
                                optionmenubase.beep(); // added by Sergey 02.11.2013 for ITS#205776
                                backLevel();
                            }
                        }
                    }
                }
            }
        }

       MouseArea
       {
           id: bg_mouseArea
           anchors.fill: parent
           anchors.rightMargin: (CONST.const_OPTION_MENU_ITEM_WIDTH_L0+CONST.const_OPTION_MENU_ITEM_SCROLL_WIDTH)
           beepEnabled: false
       }
    }

    function onNextMenuSelect(itemId, itemIndex)
    {
       __LOG("onNextMenu")
       // { added by cychoi 2015.06.03 for ITS 263675
       if (LayersList.count() == 0 || LayersList.top().layer.pendingDestroy)
       {
          if (autoHiding) disappearTimer.stop()
          // Top menu is destroying or destroyed, just return
          return
       }
       // } added by cychoi 2015.06.03
       var model = optionmenubase.menumodel.nextLevel(itemIndex)
       indentLayers(true)
       var layer = component.createObject(optionmenubase, {"x": 1280, "visible": true } )
       layer.destroyed.connect(onDestroyed)
       LayersList.add(layer, model)
       layer.menumodel = function() { return model }
       layer.setDefaultFocusbyLevelMenu()

       if (LayersList.count() > 1)
       {
          // disable and hide focus immediately after creation of new layer
          // so user won't be able to press anything on underlying menu
          LayersList.previous().layer.disabled = true
          LayersList.previous().layer.focus_visible = false
       }
       __LOG("ZZZ LayersList.count() = " + LayersList.count())
    }

    // hide with animation
    function hide()
    {
       bg.opacity = 0 // added by Sergey 02.08.2013 for ITS#181512
       var i = 0;
       for (i; i < LayersList.count(); i++)
       {
          LayersList.at(i).layer.state = "out"
       }
    }

    function show()
    {
       // { added by Sergey 02.08.2013 for ITS#181512
       disappearTimer.restart()
       bg.opacity = 1
       optionmenubase.visible = true 
       // } added by Sergey 02.08.2013 for ITS#181512
       var layer = component.createObject(optionmenubase, {"x": 1280, "visible": true } )
       LayersList.add(layer, menumodel)
       layer.menumodel = function() { return optionmenubase.menumodel }
       layer.destroyed.connect(onDestroyed)
       layer.setDefaultFocusbyLevelMenu()
       if (autoHiding) disappearTimer.restart()
    }

    // quickly destroy options menu when user selected something
    function quickHide()
    {
       if (autoHiding) disappearTimer.stop()
       var i = 0;
       for (i; i < LayersList.count(); i++)
       {
          LayersList.at(i).layer.destroy()
       }
       LayersList.clear()
       menumodel.clearModels(true)
       isHidden()
    }

    function destroyTopLayer()
    {
       indentLayers(false)
       // removed by Sergey 10.09.13 for ITS 183788
       if (LayersList.count() > 0)
       {
          LayersList.top().layer.disabled = true // added by Sergey 10.09.13 for ITS 183788
          // layers is still in destoying process, need to place previous layers in a queue
          if (!LayersList.top().layer.pendingDestroy)
          {
             LayersList.top().layer.state = "out"
          }
          else
          {
             // mark previous layer for destroy
             var i = LayersList.count() - 1;
             for (i; i >= 0; i--)
             {
                if (!LayersList.at(i).layer.pendingDestroy)
                {
                   LayersList.at(i).layer.pendingDestroy = true
                   break;
                }
             }
          }
       }
    }

    function backLevel()
    {
       destroyTopLayer()
       if (autoHiding) disappearTimer.restart()
    }

    function onDestroyed()
    {
       // remove layer from list and make menu hidden if list is empty
       // { added by Sergey 10.09.13 for ITS 183788
       // enable previous layer - hide focus & disable jog control
       if (LayersList.count() > 1)
       {
          LayersList.previous().layer.disabled = false
          LayersList.previous().layer.focus_visible = function() { return optionmenubase.focus_visible }
          LayersList.previous().layer.setDefaultFocusbyLevelMenu()
       }
       // } added by Sergey 10.09.13 for ITS 183788
       LayersList.remove();
       if (LayersList.count() > 0)
       {
          menumodel.clearModels(false)
          if (LayersList.top().layer.pendingDestroy) LayersList.top().layer.state = "out"
       }
       if (LayersList.count() == 0)
       {
          if (autoHiding) disappearTimer.stop()
          isHidden();
       }
       __LOG("ZZZ LayersList.count() = " + LayersList.count())
    }

    function indentLayers(inc)
    {
       // indent previous layers
       // don't touch this function
       var i = 0;
       for (i; i < LayersList.count(); i++)
       {
          if (!LayersList.at(i).layer.pendingDestroy)
          {
             if (inc)
             {
                LayersList.at(i).layer.anchors.rightMargin += CONST.const_OPTION_MENU_DELTA
             }
             else
             {
                LayersList.at(i).layer.anchors.rightMargin -= LayersList.at(i).layer.anchors.rightMargin + ((LayersList.count() - 2 - i) * CONST.const_OPTION_MENU_DELTA)
             }
          }
       }
    }

    Component.onCompleted:
    {
       // defines component, objects of this component are menu layers
       component = Qt.createComponent("DHAVN_OptionMenu.qml");
    }

	// removed by Sergey 02.08.2013 for ITS#181512


    Timer
    {
        id: disappearTimer
        running: autoHiding // modified by Sergey 02.08.2013 for ITS#181512
        interval: 10000
        onTriggered:
        {
            //{added by junam 2013.07.06 for timeover
            if(optionmenubase.pressed)
                return;
            //}added by junam

            hide()
        }
    }
}
// } modified by Sergey 09.11.2013 for ITS#207936
