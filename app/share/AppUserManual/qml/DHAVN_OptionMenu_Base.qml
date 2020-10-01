import QtQuick 1.0
import "DHAVN_OptionMenu.js" as CONST
import "DHAVN_LayersList.js" as LayersList
import QmlStatusBar 1.0 //modified by edo.lee 2013.04.04
import Qt.labs.gestures 2.0

Item
{
    id: optionmenubase

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

//private
    property variant component
    property bool middleEast: appUserManual.langId == 20 // added by Dmitry 29.04.13
    property bool scrollingTicker //[ISV][64532][C](aettie.ji)
    property bool pressed: false //added by junam 2013.07.06 for timeover

//signals
    signal textItemSelect( variant itemId )
    signal checkBoxSelect( variant itemId, variant flag )
    signal radioBtnSelect( variant itemId )
    signal nextMenuSelect( variant itemId )
    signal isHidden();
    signal lostFocus( int arrow, int focusID );

    function hideFocus() { focus_visible = false }
    function showFocus() { focus_visible = true }

    function setFG()
    {
        if (LayersList.count > 0)
           LayersList.top().layer.setFG()
    }

    function setDefaultFocus( arrow )
    {
       if (LayersList.count > 0)
          LayersList.top().layer.setDefaultFocus( arrow )
    }

    function onLostFocus(arrow, focusID)
    {
       lostFocus(arrow, focusID)
    }

    x:0
    y:93
    width: CONST.const_DISPLAY_WIDHT
    height: CONST.const_DISPLAY_HEIGTH
        //added by edo.lee 2013.05.03
//        QmlStatusBar {
//                id: statusBar
//                x: 0;
//                y: -93;
//                z: 1000
//                width: 1280;
//                height: 93;
//                homeType: "button"
//                middleEast: optionmenubase.middleEast //[ME][ITS][177647][minor](aettie.ji)
//        }//added by edo.lee 2013.05.03

    Rectangle
    {
        width: CONST.const_DISPLAY_WIDHT
        height: CONST.const_DISPLAY_HEIGTH
        color: "transparent" //Qt.rgba( 0, 0, 0, CONST.const_OPTION_MENU_BLACKOUT_1 )
        opacity: (optionmenubase.visible) ? 1 : 0

        Behavior on opacity { PropertyAnimation { duration: 100 } } // modified by Sergey 28.05.2013
        //{modified by aettie 20130528 ITS 166747
        MouseArea
        {
           anchors.fill: parent
           enabled: !appUserManual.touchLock
           beepEnabled: false
           onClicked:
           {
               console.log("OptionMenu_Base.qml :: Rectangle onClicked")
             // hide()
           }
        }

        GestureArea
        {
           anchors.fill: parent
           enabled: !appUserManual.touchLock
           Tap
            {
                onStarted: {
                    optionmenubase.pressed = true; //added by junam 2013.07.06 for timeover
                    console.log("OptionMenu_Base.qml :: Tap onStarted")
                }

                onFinished:
                {
                    console.log("OptionMenu_Base.qml :: Tap onFinished")
                    //{added by junam 2013.07.06 for timeover
                    optionmenubase.pressed = false
                    if (autoHiding)
                        disappearTimer.restart()
                    //}added by junam
                    //[NA][ITS][177761][comment](aettie.ji)
                    if (!middleEast)
                    {
                        console.log("OptionMenu_Base.qml :: Tap onFinished")
                        if ( (gesture.position.y >= 93  && gesture.position.y <= CONST.const_DISPLAY_HEIGTH) &&
                            (gesture.position.x >= 0 && gesture.position.x <= CONST.const_DISPLAY_WIDHT - CONST.const_OPTION_MENU_ITEM_WIDTH_L1_TAP_AREA)) {
                            hide()
                            EngineListener.playAudioBeep()
                            }
                        else if((gesture.position.y >= 93  && gesture.position.y <= CONST.const_DISPLAY_HEIGTH) &&
                            (gesture.position.x >= CONST.const_DISPLAY_WIDHT - CONST.const_OPTION_MENU_ITEM_WIDTH_L1_TAP_AREA && gesture.position.x <= CONST.const_DISPLAY_WIDHT - CONST.const_OPTION_MENU_ITEM_WIDTH_L0)) {
                            destroyTopLayer()
                            EngineListener.playAudioBeep()
                            }
                    }
                    else
                    {
                        if ( (gesture.position.y >= 93  && gesture.position.y <= CONST.const_DISPLAY_HEIGTH) &&
                            (gesture.position.x >= CONST.const_OPTION_MENU_ITEM_WIDTH_L1_TAP_AREA && gesture.position.x <= CONST.const_DISPLAY_WIDHT )) {
                            hide()
                            EngineListener.playAudioBeep()
                            }
                        else if ( (gesture.position.y >= 93  && gesture.position.y <= CONST.const_DISPLAY_HEIGTH) &&
                            (gesture.position.x >= CONST.const_OPTION_MENU_ITEM_WIDTH_L0 && gesture.position.x <= CONST.const_OPTION_MENU_ITEM_WIDTH_L1_TAP_AREA )) {
                            destroyTopLayer()
                            EngineListener.playAudioBeep()
                            }
                    }
                }
           }

            Pan
            {
                onFinished:
                {
                    //{added by junam 2013.07.06 for timeover
                    console.log("OptionMenu_Base.qml :: Pan onFinished")
                    optionmenubase.pressed = false
                    if (autoHiding)
                        disappearTimer.restart()
                    //}added by junam

                    if (!middleEast){

                        if (gesture.offset.x > 100 && Math.abs(gesture.offset.y) < 300) {
                            destroyTopLayer()
                            EngineListener.playAudioBeep()
                        }
                    }
                    else
                    {
                         if (gesture.offset.x < -100 && Math.abs(gesture.offset.y) < 300) {
                            destroyTopLayer()
                            EngineListener.playAudioBeep()
                         }
                    }
                }
            }
        }
        //}modified by aettie 20130528 ITS 166747
    }

    function onNextMenuSelect(itemId, itemIndex)
    {
       console.log("onNextMenu")
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
       console.log("ZZZ LayersList.count() = " + LayersList.count())
    }

    // hide with animation
    function hide()
    {
       var i = 0;
       for (i; i < LayersList.count(); i++)
       {
          LayersList.at(i).layer.state = "out"
       }
    }

    function show()
    {
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
       // enable previous layer - hide focus & disable jog control
       if (LayersList.count() > 1)
       {
          LayersList.previous().layer.disabled = false
          LayersList.previous().layer.focus_visible = function() { return optionmenubase.focus_visible }
          LayersList.previous().layer.setDefaultFocusbyLevelMenu()
       }
       if (LayersList.count() > 0)
       {
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
       console.log("ZZZ onDestroyed")
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
       console.log("ZZZ LayersList.count() = " + LayersList.count())
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

    onVisibleChanged:
    {
       if (visible)
       {
          show()
       }
       else
       {
          // just destroy everything
          if (LayersList.count() > 0)
          {
             quickHide()
          }
       }
    }

    Timer
    {
        id: disappearTimer
        running: autoHiding
        interval: 1000
        onTriggered:
        {
            //{added by junam 2013.07.06 for timeover
            console.log("OptionMenu_Base.qml :: disappearTimer onTriggered")
            if(optionmenubase.pressed)
                return;
            //}added by junam

            hide()
        }
    }
}

