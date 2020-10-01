import Qt 4.7
import AppEngineQMLConstants 1.0
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES

ListView
{
    id: listArea

    /** --- Input parameters --- */
    property ListModel listModel: ListModel {}

    property int itemHeight: 0
    property string separatorPath: ""
    property int focus_id: -1
    property int focus_index: 0
    property bool focus_visible: false

    /** --- Signals --- */
    signal lostFocus( int arrow, int focusID );
    signal switchPressed( variant index, bool value )

    /** --- Internal Signals --- */
    signal clickOnActivitySlider( variant focusIndex );
    signal moveLeftRightActivitySlider( variant focusIndex, bool value );

    /** --- Internal property --- */
    property bool bDebug: true
    property bool bIsClickActivitySlider: false

    function setDefaultFocus( arrow )
    {
        var ret = focus_id
        if ( count <= 0 )
        {
            lostFocus( arrow, focus_id )
            ret = -1
        }
        return ret
    }

    Connections
    {
        target: focus_visible ? UIListener : null

        onSignalJogNavigation:
        {
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                if ( arrow == UIListenerEnum.JOG_RIGHT || arrow == UIListenerEnum.JOG_WHEEL_RIGHT )
                {
                    log( "onSignalJogNavigation: arrow = UIListenerEnum.JOG_RIGHT" );

                    bIsClickActivitySlider = true
                    listArea.moveLeftRightActivitySlider( focus_index, true )
                    return
                }

                if (  arrow == UIListenerEnum.JOG_LEFT || arrow == UIListenerEnum.JOG_WHEEL_LEFT )
                {
                    log( "onSignalJogNavigation: arrow = UIListenerEnum.JOG_LEFT" );

                    bIsClickActivitySlider = true
                    listArea.moveLeftRightActivitySlider( focus_index, false )
                    return
                }

                if ( arrow == UIListenerEnum.JOG_UP && focus_index > 0 )
                {
                    log( "onSignalJogNavigation: arrow = UIListenerEnum.JOG_UP" );

                    focus_index--
                    return
                }

                if ( arrow == UIListenerEnum.JOG_DOWN && focus_index < listModel.count - 1 )
                {
                    log( "onSignalJogNavigation: arrow = UIListenerEnum.JOG_DOWN" );

                    focus_index++
                    return
                }

                listArea.lostFocus( arrow, focus_id )
            }
            else if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            {
                if ( arrow == UIListenerEnum.JOG_CENTER )
                {
                    log( "onSignalJogNavigation: arrow = UIListenerEnum.JOG_CENTER" );
                    listArea.clickOnActivitySlider( focus_index )
                    return
                }
            }

            else if (status == UIListenerEnum.KEY_STATUS_LONG_PRESSED)
            {
                if ( arrow == UIListenerEnum.JOG_DOWN)
                {
                    focus_index = listModel.count - 1
                    UIListener.ManualBeep();
//		    controller.callBeepSound();
                    return
                }

                if ( arrow == UIListenerEnum.JOG_UP)
                {
                    focus_index = 0
//                    UIListener.ManualBeep();
                    UIListener.ManualBeep();
                    return
                }
            }
        }
    }

    function log( logText )
    {
       if ( bDebug ) console.log( "[SystemPopUp] DHAVN_PopUp_Item_ASList: " + logText )
    }

    /** --- Object property --- */
    clip: true
    focus: true
    model: listModel
    boundsBehavior: Flickable.StopAtBounds

    /** --- Child object --- */
    delegate: Item
    {
        id: listItem
        height: itemHeight
        width: separator.sourceSize.width
        anchors.horizontalCenter: parent.horizontalCenter

        Text
        {
            id: item_text
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            text:   (listArea.listModel.get( index ).text).substring(0, 4) == "STR_" ?
                    qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, listArea.listModel.get( index ).text ) :
                    listArea.listModel.get( index ).text
            color: CONST.const_TEXT_COLOR
            font.pixelSize: CONST.const_TEXT_PT
        }

        Image
        {
            id: separator
            visible: index
            source: separatorPath
            anchors.top: parent.top
        }

        /** Focused Img */
        Image
        {
            id: focus
            height: parent.height
            width: focus.sourceSize.width
            anchors.centerIn: parent
            source: RES.const_POPUP_LIST_ITEM_FOCUSED_IMG
            visible: focus_index == index && focus_visible
        }

        Image
        {
           id: background_activitySlider

           anchors.verticalCenter: parent.verticalCenter
           anchors.right: parent.right

           /** true - current value "off", false - current value "on"*/
           property bool bCurrentActivitySlider: listArea.listModel.get( index ).bVisible
           /** true - value changes are possible. false - are not possible */
           property bool bEnabled: listArea.listModel.get( index ).bHideable
           /** false - big type, true - small type*/
           property bool bActivitySliderSmall: false

           property bool bInActivitySliderEneabled: false

           property string sFocusedColor: Qt.rgba( 0, 0.5, 1, 0.6 )

           source: bActivitySliderSmall ? "/app/share/images/autocare/bg_info_switch.png" :
                                          "/app/share/images/settings/bg_switch.png"

           Connections
           {
               target: listArea

               onClickOnActivitySlider:
               {
                   if ( focusIndex < listArea.count - 1 &&
                        listArea.bIsClickActivitySlider &&
                        listArea.listModel.get( focusIndex ).bHideable )
                   {
                       listArea.bIsClickActivitySlider = false;
                       listArea.listModel.get( focusIndex ).bVisible = !listArea.listModel.get( focusIndex ).bVisible;
                       listArea.switchPressed( focusIndex, bVisible );
                   }
               }

               onMoveLeftRightActivitySlider:
               {
                   if ( focusIndex < listArea.count - 1 &&
                        listArea.bIsClickActivitySlider &&
                        listArea.listModel.get( focusIndex ).bHideable )
                   {
                       listArea.bIsClickActivitySlider = false;
                       listArea.listModel.get( focusIndex ).bVisible = value;
                       listArea.switchPressed( focusIndex, bVisible );
                   }
               }
           }

           Image
           {
              id: tumbler
              y: -1
              source: background_activitySlider.bActivitySliderSmall ? "/app/share/images/autocare/info_switch.png" :
                                                                       "/app/share/images/settings/switch.png"
              transitions: Transition {
                  PropertyAnimation { id: animate_slider; target: tumbler; properties: "x"; duration: 0 }
              }
              state: background_activitySlider.bCurrentActivitySlider ? "off" : "on"
              states: [
                 State {
                    name: "on"
                    PropertyChanges { target: tumbler; x: 1 }
                 },
                 State {
                    name: "off"
                    PropertyChanges { target: tumbler; x: tumbler.sourceSize.width - 2 }
                 }
              ]
           }

           MouseArea
           {
              anchors.fill: parent
              enabled: background_activitySlider.bEnabled
              beepEnabled: false
              onPositionChanged:
              {
                 if ( mouseX <= tumbler.sourceSize.width )
                 {
                          listArea.listModel.get( index ).bVisible = false
                 }
                 else
                 {
                          listArea.listModel.get( index ).bVisible = true
                 }

                 listArea.switchPressed( index, bVisible );
              }
              onClicked:
              {
                  UIListener.ManualBeep();
                 if ( mouseX <= tumbler.sourceSize.width )
                 {
                          listArea.listModel.get( index ).bVisible = false
                 }
                 else
                 {
                          listArea.listModel.get( index ).bVisible = true
                 }

                 listArea.switchPressed( index, listArea.listModel.get( index ).bVisible );
              }
           }

           Component.onCompleted: { animate_slider.duration = 200 }
        }
    }

    DHAVN_PopUp_Item_VerticalScrollBar
    {
        anchors.right: listArea.right
        anchors.rightMargin: CONST.const_V_SCROLLBAR_RIGHT_MARGIN
        anchors.top:listArea.top
        anchors.topMargin: CONST.const_V_SCROLLBAR_TOP_MARGIN
        position: parent.visibleArea.yPosition
        pageSize: (listModel.count == 0) ? 0 : ((listArea.height / itemHeight) / listModel.count)
        visible: listModel.count * itemHeight > listArea.height
        list_count: listModel.count
    }

    onFocus_indexChanged:
    {
        listArea.positionViewAtIndex ( listArea.focus_index, ListView.Contain  )
    }
}
