// modified by Dmitry 08.05.13
import Qt 4.7
import QtQuick 1.1
import AppEngineQMLConstants 1.0
import "DHAVN_OptionMenu.js" as CONST

ListView
{
    id: listarea

    clip: true
    focus: true
//    boundsBehavior: Flickable.StopAtBounds

    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
    property int focus_id: -1
    property bool itemPresed: false
    property bool centerPressed: false
    property bool middleEast: optionmenubase.middleEast // added by Dmitry 29.04.13
    property bool scrollingTicker: optionmenubase.scrollingTicker //[ISV][64532][C](aettie.ji)
    property int focus_index:  0 //[KOR][ITS][178060][minor](aettie.ji)
    property int pressIndex: -1

    /** --- Signals --- */
    signal textItemSelect( variant itemId )
    signal checkBoxSelect( variant itemId, variant flag )
    signal radioBtnSelect( variant itemId )
    signal nextMenuSelect( variant itemId, variant itemIndex )

    signal itemJogCenterClicked()
    signal nextLevel() // added by Dmitry 19.05.13

    onVisibleChanged:
    {
        itemPresed = false
        centerPressed = false
    }

    function setFG()
    {
        itemPresed = false
        centerPressed = false
    }

    function setDefaultFocus( arrow )
    {
        var ret = focus_id
        if ( count <= 0 )
        {
            optionmenubase.onLostFocus( arrow, focus_id )
            ret = -1
        }
        switch ( arrow )
        {
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            {
                focus_index = -1
                ret = focusNext( arrow )
            }
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
                focus_index = listarea.count - 1
                ret = focusPrev( arrow )
            }
            default:
            {
                if ( focus_index >= 0 ) focus_index--;
                ret = focusNext( arrow );
            }
        }
        return ret
    }
//[KOR][ITS][178060][minor](aettie.ji)

// modified by Dmitry 19.05.13
    Connections
    {
        target: root_menu.focus_visible && !root_menu.disabled ? UIListener : null

        onSignalJogNavigation:
        {
            if (autoHiding) disappearTimer.restart()

            if( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               switch (arrow)
               {
               case UIListenerEnum.JOG_CENTER:
               {
                  listarea.currentIndex = focus_index;
                  centerPressed = true;
                  break;
               }

               case UIListenerEnum.JOG_WHEEL_RIGHT:
               {
                     itemPresed = false
                     centerPressed = false
                     if ( middleEast ) focusPrev( arrow );
                     else focusNext( arrow );
                  break;
               }

               case UIListenerEnum.JOG_WHEEL_LEFT:
               {
                     itemPresed = false
                     centerPressed = false
                     if ( middleEast ) focusNext( arrow );
                     else focusPrev( arrow )
                  break;
               }

               default:
                  break;
               }
            }
            else if( status == UIListenerEnum.KEY_STATUS_RELEASED )
            {
               switch (arrow)
               {
                  case UIListenerEnum.JOG_CENTER:
                  {
                     listarea.currentIndex = focus_index;
                     centerPressed = false;
                     itemJogCenterClicked();
                     break;
                  }

                  case UIListenerEnum.JOG_LEFT:
                  {
                     if (!middleEast)
                        optionmenubase.destroyTopLayer()
                     else
                        nextLevel()
                     break;
                  }

                  case UIListenerEnum.JOG_RIGHT:
                  {
                     if (middleEast)
                        optionmenubase.destroyTopLayer()
                     else
                        nextLevel()
                     break;
                  }

                  default:
                     break;
               }
            }
            else if( status == UIListenerEnum.KEY_STATUS_CANCELED )
            {
               switch (arrow)
               {
                  case UIListenerEnum.JOG_CENTER:
                  {
                     centerPressed = false;
                     itemPresed = false;
                     break;
                  }
                  default:
                     break;
               }
            }
        }
    }
// modified by Dmitry 19.05.13

    function focusNext( dir )
    {
        //{changed by junam for 2013.07.11 for ISV_NA_87303
    //[ISV][64532][C](aettie.ji) //modified by Michael.Kim 2013.07.10 for ITS Issue #0178892
      /*  for( var i = focus_index + 1; i < listarea.count +1 ; i++ ) // modified fby ravikanth 09-07-13 for ITS 0178926
        {
            if(listarea.model.getEnabled(i) == false)
                continue
            else
            {
               // listarea.currentIndex = focus_index // added by Dmitry 19.05.13
               if( listarea.currentIndex  >= 0 && listarea.currentIndex < listarea.count - 1 ) // modified by eugene.seo 2013.03.07
                {
                        focus_index = i
                }
                else if(vScroll.visible)
                {
                        focus_index = 0;
                        i = 0;
                }
                listarea.currentIndex = focus_index
                console.log("optionfocus focusNext focus_index = "+ focus_index);
                return focus_id
            }
        }*/
        if(vScroll.visible)
        {
            //Looping logic
            for( var i = 0; i < listarea.count ; i++ )
            {
                if(listarea.model.getEnabled( ( i + focus_index + 1) % listarea.count) == false)
                    continue;
                focus_index =  ( i + focus_index + 1 ) % listarea.count;
                listarea.currentIndex = focus_index
                console.log("optionfocus focusNext focus_index = "+ focus_index);
                return focus_id
            }
        }
        else
        {
             for( var i = focus_index + 1; i < listarea.count; i++ )
             {
                 if(listarea.model.getEnabled(i) == false)
                     continue
                 focus_index = i
                 listarea.currentIndex = focus_index
                 console.log("optionfocus focusNext focus_index = "+ focus_index);
                 return focus_id
             }
             return focus_id
        }
        //}changed by junam

        optionmenubase.onLostFocus( dir, focus_id )
        return -1;
    }

    function focusPrev( dir )
    {
        //{changed by junam for 2013.07.11 for ISV_NA_87303
    //[ISV][64532][C](aettie.ji)
        /*for( var i = focus_index - 1; i >= -1; i-- )
        {
            if(listarea.model.getEnabled(i) == false)
                continue
            else
            {
                //[KOR][ITS][178060][minor](aettie.ji)
                if( listarea.currentIndex > 0 && (i != -1))
                {
                    focus_index = i
                }
                else if(vScroll.visible)
                {
                    if( listarea.count > 0){
                            focus_index = listarea.count - 1;
                         i = listarea.count - 1;
                    }
                       else {
                            focus_index = 0;
                         i = 0;
                       }
                }
                   listarea.currentIndex = focus_index

                console.log("optionfocus focusPrev focus_index = "+ focus_index);
                return focus_id
            }
        }*/

        if(vScroll.visible)
        {
            //Looping logic
            for( var i = 0; i < listarea.count ; i++ )
            {
                if(listarea.model.getEnabled( ( focus_index + listarea.count - 1 - i ) % listarea.count) == false)
                    continue;
                focus_index =  (focus_index + listarea.count - 1 - i ) % listarea.count;
                listarea.currentIndex = focus_index
                console.log("optionfocus focusNext focus_index = "+ focus_index);
                return focus_id
            }
        }
        else
        {
            for( var i = focus_index - 1; i >= 0; i-- )
            {
                if(listarea.model.getEnabled(i) == false)
                    continue
                focus_index = i
                listarea.currentIndex = focus_index
                console.log("optionfocus focusNext focus_index = "+ focus_index);
                return focus_id
            }
            return focus_id
        }
        //}changed by junam

        optionmenubase.onLostFocus( dir, focus_id )
        return -1
    }

// modified by Dmitry 19.05.13
    function setDefaultFocusbyLevelMenu()
    {
       if (previousFocusIndex == -1)
       {
       //[KOR][ITS][178060][minor](aettie.ji)
           for( var i = 0; i < listarea.count ; i++ ){
                if(listarea.model.getSelected(i)&&(listarea.model.isCheckBox(i)||listarea.model.isRadioBtn(i))){
                   focus_index = i
                   return
                }
           }
           for( var i = 0; i < listarea.count ; i++ )
           {
               if(listarea.model.getEnabled(i) == false)
                   continue
               else
               {
                   focus_index = i
                   return
               }
           }
       }
       else
       {
          focus_index == previousFocusIndex
       }
    }
// modified by Dmitry 19.05.13

    delegate: Item
    {
        id: listItem
        height: 78//CONST.const_OPTION_MENU_ITEM_HEIGTH
        width: CONST.const_OPTION_MENU_ITEM_WIDTH_L0
        anchors.left: parent.left
        anchors.leftMargin: CONST.const_OPTION_MENU_LIST_LEFT_MARGIN

        enabled: bEnabled


        /** Focuse image */
        Image
        {
            id: focuse_img
            height: 81//parent.height+3
            anchors.top: parent.top
            anchors.topMargin: -3
//            anchors.topMargin:  focus_index == index ?  -3 : -10
            anchors.left: parent.left
            anchors.leftMargin: CONST.const_OPTION_MENU_LIST_ITEM_IMAGE_LEFT_MARGIN
            source: ( pressIndex == index && focus_visible) || ( centerPressed && focus_index == index) ? CONST.const_OPTION_MENU_LIST_PRESS
                                                                                           : focus_index == index && focus_visible  ? CONST.const_OPTION_MENU_LIST_FOCUS
                                                                                                                                    : ""
            Image
            {
                id: press_img
                anchors.top: parent.top
                anchors.topMargin: -3
                anchors.left: parent.left
                anchors.bottom: parent.bottom+1
                anchors.leftMargin: CONST.const_OPTION_MENU_LIST_ITEM_IMAGE_LEFT_MARGIN
                visible:  pressIndex == index && focus_visible || ( centerPressed && focus_index == index)
                source: CONST.const_OPTION_MENU_LIST_PRESS
            }

            Image
            {
                id: separator

                anchors.bottom: parent.bottom// modified by Dmitry 24.05.13
                anchors.left: parent.left
//                anchors.bottomMargin: -3

                source:  CONST.const_OPTION_MENU_DELIMITER_1
                visible: parent.source == "" && index == 1//!focuse_img.visible // isSeparate // modified by Dmitry 24.05.13
            }


//            visible: ( focus_index == index && focus_visible ) //modified by aettie.ji 2013.04.30 for pressed image

        }

        /** Delimiter item section */
//        Image
//        {
//            id: separator

//            anchors.bottom: parent.bottom// modified by Dmitry 24.05.13
//            anchors.bottomMargin: -3
//            anchors.horizontalCenter: parent.horizontalCenter

//            source:  CONST.const_OPTION_MENU_DELIMITER_1
//            visible: !focuse_img.visible // isSeparate // modified by Dmitry 24.05.13
//        }

        /** Press image */
        // Foucs 되지 않은 press 이미지
//        Image
//        {
//            id: highlight_img
//            height: parent.height
//            anchors.top: parent.top
//            anchors.topMargin: -3
//            anchors.left: parent.left
//            anchors.bottom: parent.bottom+1
//            anchors.leftMargin: CONST.const_OPTION_MENU_LIST_ITEM_IMAGE_LEFT_MARGIN
//            visible: itemPresed && pressIndex == index && focus_visible && focus_index != index
//            source: CONST.const_OPTION_MENU_LIST_PRESS
//        }



// modified by Dmitry 22.05.13
        // icon in front of text (for ex, in pandora)
        Image
        {
            id: item_icon
            anchors.left: parent.left
            anchors.leftMargin: CONST.const_OPTION_MENU_LIST_ITEM_TEXT_LEFT_MARGIN

            anchors.verticalCenter: parent.verticalCenter
            source: iconFile
            visible: iconFile != ""
        }

        /** Text item */
        //[EU][IVS][84553][84633][c][EU][ITS][167240][comment](aettie.ji)
           DHAVN_OptionMenu_Marquee_Text
            {
                id: item_text

                 text: ( itemName.substring( 0, 4 ) == "STR_" ) ?
                        qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, itemName ):
                        itemName

                 anchors.left: parent.left // modified by Dmitry 03.05.13
                 anchors.leftMargin: !item_icon.visible ? CONST.const_OPTION_MENU_LIST_ITEM_TEXT_LEFT_MARGIN :
                                                     CONST.const_OPTION_MENU_LIST_ITEM_TEXT_LEFT_MARGIN + 61

                 scrollingTicker: listarea.scrollingTicker && ( focus_index == index ) && focus_visible

                 color: bEnabled ? ( focus_index == index || (itemPresed && pressIndex == index)) ? CONST.const_OPTION_MENU_TEXT_BRIGHTGREY_COLOR
                                                                            : CONST.const_OPTION_MENU_TEXT_SUBTEXTGREY_COLOR
                                        : "#9E9E9E"

                 anchors.verticalCenter: parent.verticalCenter

                 fontSize: CONST.const_OPTION_MENU_TEXT_PT
                 fontFamily: vehicleVariant == 1 ? "KH_HDR" : "DH_HDR"
                 width: (item_icon.visible || item_arrow.visible) ? 324 : 375

            }

        /** arrow icon for sub menu*/
        Image
        {
            id: item_arrow

            anchors.verticalCenter: parent.verticalCenter
// modified by Dmitry 03.05.13
            anchors.right: highlight_img.right
            anchors.rightMargin: CONST.const_OPTION_MENU_LIST_ITEM_TEXT_LEFT_MARGIN
            mirror: middleEast
// modified by Dmitry 03.05.13

            source: CONST.const_OPTION_MENU_ARRAOW

            visible: hasNextLevel
        }

        /** Checkbox item section */
        Image
        {
            id: item_check

            anchors.verticalCenter: parent.verticalCenter

            anchors.right: highlight_img.right
            anchors.rightMargin: 15


            source: !checkBox ? "" : ( isSelected ) ?
                                       CONST.const_OPTION_MENU_CHECKED :
                                       CONST.const_OPTION_MENU_UNCHECKED
        }

        /** Radio button item section */
        Image
        {
            id: item_radio
            anchors.verticalCenter: parent.verticalCenter
// modified by Dmitry 03.05.13
            anchors.right: highlight_img.right
            anchors.rightMargin: 15
            visible: radioButton
// modified by Dmitry 03.05.13
            source: !radioButton ? "" : ( isSelected ) ?
                                        CONST.const_OPTION_MENU_RADIO_ON :
                                        CONST.const_OPTION_MENU_RADIO_OFF
        }


        MouseArea
        {
            id: pressedArea
            anchors.fill: parent
            enabled: !root_menu.disabled && !appUserManual.touchLock


            onClicked:
            {
               focus_index = index
               if ( hasNextLevel )
               {
                  listarea.nextMenuSelect( itemId, index );
               }

               if ( checkBox )
               {
                   listarea.model.checkBoxSelected( index, !isSelected );
                   listarea.checkBoxSelect( itemId, isSelected )
               }

               if ( radioButton )
               {
                   listarea.model.radioButtonSelected( index );
                   listarea.radioBtnSelect( itemId );
               }

               if ( !hasNextLevel && !checkBox && !radioButton )
               {
                  listarea.textItemSelect( itemId );
               }
            }

            onPressed:
            {
                console.log("OptionMenu_Item_List.qml :: mouseArea onPressed")
//                listarea.currentIndex = index;
                itemPresed = true;
                pressIndex = index
            }

            onReleased:
            {
                console.log("OptionMenu_Item_List.qml :: mouseArea onReleased")
                listarea.currentIndex = index;
                pressIndex = -1
                itemPresed = false;
            }
            onExited:
            {
                console.log("OptionMenu_Item_List.qml :: mouseArea onExited")
            }

            onCanceled:
            {
                console.log("OptionMenu_Item_List.qml :: mouseArea onCanceled")
               itemPresed = false;
               pressIndex  = -1
//               focus_index = -1; //[KOR][ITS][175487][comment](aettie.ji)
            }
        }

        Connections
        {
            target: ( index == focus_index && bEnabled ) ? listarea : null

            onItemJogCenterClicked:
            {
               if ( hasNextLevel )
               {
                  listarea.nextMenuSelect( itemId, focus_index );
               }

               if ( checkBox )
               {
                   listarea.model.checkBoxSelected( focus_index, !isSelected );
                   listarea.checkBoxSelect( itemId, isSelected )
               }

               if ( radioButton )
               {
                   listarea.model.radioButtonSelected( focus_index );
                   listarea.radioBtnSelect( itemId );
               }

               if ( !hasNextLevel && !checkBox && !radioButton )
               {
                  listarea.textItemSelect( itemId );
               }
            }

// added by Dmitry 19.05.13
            onNextLevel:
            {
               if ( hasNextLevel )
               {
                  listarea.nextMenuSelect( itemId, focus_index );
               }
            }
// added by Dmitry 19.05.13
        }
    }

    DHAVN_OptionMenu_Item_VerticalScrollBar
    {

        id: vScroll  //[ISV][64532][C](aettie.ji)
       height: parent.height
       anchors.right: parent.right
       position: parent.visibleArea.yPosition
       pageSize: parent.visibleArea.heightRatio
       visible: parent.visibleArea.heightRatio < 1
       onPositionChanged:
       {
          if (autoHiding) disappearTimer.restart()
       }
    }

    onFocus_indexChanged:
    {
        listarea.positionViewAtIndex ( focus_index, ListView.Contain  )
    }

    function _LOG( logText )
    {
       console.log( " DHAVN_OptionMenu_Item_List.qml: " + logText )
    }
}
// modified by Dmitry 08.05.13

