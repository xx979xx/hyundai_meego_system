// modified by Dmitry 08.05.13
//modified by edo.lee 13.11.22
import Qt 4.7
import QtQuick 1.1
import AppEngineQMLConstants 1.0
import "DHAVN_OptionMenu.js" as CONST

// modified by Sergey 19.08.13 for ITS#182988
ListView
{
    id: listarea

    clip: true
    focus: true
    // interactive: vScroll.visible // added by Dmitry 18.08.13 for ITS0184411 //removed by aettie 20130828 following UX scanario
    highlightMoveDuration: 1
    // removed by Sergey 10.09.13 for ITS 183788
    snapMode: ListView.SnapToItem // added Sergey 09.11.2013 for ITS#207973

    property int focus_id: -1
    property bool itemPresed: false
    property bool middleEast: optionmenubase.middleEast // added by Dmitry 29.04.13
    property bool scrollingTicker: optionmenubase.scrollingTicker //[ISV][64532][C](aettie.ji)
    property bool radioItemReleased : false
    property bool _bAVPMode: false
    property bool itemReleased : false// added by taihyun.ahn 2013.12.03
    
    /** --- Signals --- */
    signal textItemSelect( variant itemId )
    signal checkBoxSelect( variant itemId, variant flag )
    signal radioBtnSelect( variant itemId )
    signal nextMenuSelect( variant itemId, variant itemIndex )

    signal itemJogCenterClicked()
    signal nextLevel() // added by Dmitry 19.05.13

    // { added by oseong.kwon 2014.08.04 for show Log
    function __LOG(Log)
    {
        optionmenubase.qmlLog("DHAVN_OptionMenu_Item_List.qml: " + Log );
    }
    // } added by oseong.kwon 2014.08.04

    onVisibleChanged:
    {
        itemPresed = false

        if(!visible) // modified by Sergey for syntax issue
            scrollTimer.stop(); // added by Sergey 27.09.2013 for ITS#189873
        else
        {
            radioItemReleased = false;
            itemReleased = false;// added by taihyun.ahn 2013.12.03
        }
    }

    // { added by Sergey 22.11.2013. Focus is out of view after dragging. 
    onMovementEnded:
    {
        if(visibleArea.heightRatio >= 1)
            return;

        var tmp_start_index = indexAt(100, contentY + 10)
        var tmp_end_index = indexAt(100, contentY + listarea.height - 10)

        if(!((currentIndex >= tmp_start_index) && (currentIndex <= tmp_end_index)))
        {
            currentIndex = tmp_start_index
            // modified for ITS 0215817
            if(listarea.model.getEnabled(tmp_start_index) == false)
            {
                focusNext(UIListenerEnum.JOG_WHEEL_RIGHT, false);
            }
        }
    }
    // } added by Sergey 22.11.2013. Focus is out of view after dragging.

    
    function setDefaultFocus( arrow )
    {
        var ret = focus_id
        if ( count <= 0 )
        {
            optionmenubase.onLostFocus( arrow, focus_id )
            ret = -1
        }
        if(radioItemReleased == true)
        {
            __LOG("optionfocus setDefaultFocus radioItemReleased = "+ radioItemReleased);
            return;
        }

        if(itemReleased == true)
        {
            __LOG("optionfocus setDefaultFocus itemReleased = "+ itemReleased);
            return;
        }

        switch ( arrow )
        {
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            {
	    //modified by aettie CCP wheel direction for ME 20131014	           
                if(middleEast)
                {
                    listarea.currentIndex = listarea.count - 1
                    ret = focusPrev( arrow, true ) // modified by Sergey 09.10.2013 for ITS#194180
                }
                else
                {
                    listarea.currentIndex = -1
                    ret = focusNext( arrow, true ) // modified by Sergey 09.10.2013 for ITS#194180
                }
                break // added by Dmitry 06.11.13 for ITS0206859
            }
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
	    //modified by aettie CCP wheel direction for ME 20131014
                if(middleEast)
                {
                    listarea.currentIndex = -1
                    ret = focusNext( arrow, true ) // modified by Sergey 09.10.2013 for ITS#194180
                }
                else
                {
                    listarea.currentIndex = listarea.count - 1
                    ret = focusPrev( arrow, true ) // modified by Sergey 09.10.2013 for ITS#194180
                }
                break // added by Dmitry 06.11.13 for ITS0206859
            }
            default:
            {
                if ( listarea.currentIndex >= 0 ) listarea.currentIndex--;
                ret = focusNext( arrow, true ); // modified by Sergey 09.10.2013 for ITS#194180
            }
        }
        return ret
    }
//[KOR][ITS][178060][minor](aettie.ji)

// modified by Dmitry 19.05.13
    Connections
    {
        target: root_menu.focus_visible && !root_menu.disabled ? (optionmenubase.bAVPMode? EngineListener : UIListener) : null

        onSignalJogNavigation:
        {
            __LOG("DUAL_KEY OptionMenu onSignalJogNavigation")

            //{modified by taihyun.ahn for ITS 218397 2014.01.08
            if(optionmenubase.bAVPMode)
            {
                // added by sangmin.seol 2014.06.26 Exception Code for AVP Crash Issue
                if( root_menu.focus_visible != true || root_menu.disabled == true || root_menu.visible != true )
                {
                    EngineListenerMain.qmlCritical("onSignalJogNavigation Exception!! focus_visible="  + root_menu.focus_visible + ",disabled=" + root_menu.disabled + ",visible=" + root_menu.visible);
                    return;
                }

                if(!((SM.disp == 0 && !bRRC) || (SM.disp == 1 && bRRC)) && !EngineListenerMain.getCloneState4QML())
                {
                    return;
                }
            }
            //}modified by taihyun.ahn for ITS 218397 2014.01.08

            if (autoHiding) disappearTimer.restart()
			

            if( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
               switch (arrow)
               {
               case UIListenerEnum.JOG_CENTER:
               {
                  optionmenubase.pressed = true // added by Dmitry 17.07.2013 for ITS0179862
                  itemPresed = true;
                  break;
               }

               case UIListenerEnum.JOG_WHEEL_RIGHT:
               {
                   if (flicking || moving || itemPresed || radioItemReleased || itemReleased) return // modified by edo.lee 2013.11.20 ITS 0207978
                   //modified by aettie CCP wheel direction for ME 20131014
                   if(middleEast)
                   {
                       //itemPresed = false// modified by edo.lee 2013.11.20 ITS 0207978
                       focusPrev( arrow, true ) // modified by Sergey 09.10.2013 for ITS#194180
                   }
                   else
                   {
                       //itemPresed = false// modified by edo.lee 2013.11.20 ITS 0207978
                       focusNext( arrow, true ); // modified by Sergey 09.10.2013 for ITS#194180
                   }
                   break;
               }
               case UIListenerEnum.JOG_WHEEL_LEFT:
               {
                   if (flicking || moving || itemPresed || radioItemReleased || itemReleased) return // modified by edo.lee 2013.11.20 ITS 0207978
                   //modified by aettie CCP wheel direction for ME 20131014
                   if(middleEast)
                   {
                       //itemPresed = false// modified by edo.lee 2013.11.20 ITS 0207978
                       focusNext( arrow, true ); // modified by Sergey 09.10.2013 for ITS#194180
                   }
                   else
                   {
                       //itemPresed = false// modified by edo.lee 2013.11.20 ITS 0207978
                       focusPrev( arrow, true ) // modified by Sergey 09.10.2013 for ITS#194180
                   }
                   break;
               }

               default:
                   break;
               }
            }
            else if( status == UIListenerEnum.KEY_STATUS_RELEASED )
            {
                scrollTimer.stop(); // added by Sergey 27.09.2013 for ITS#189873
                itemPresed = false;// modified by edo.lee 2013.11.20 ITS 0207978
                switch (arrow)
                {
                case UIListenerEnum.JOG_CENTER:
                {
                    optionmenubase.pressed = false // added by Dmitry 17.07.2013 for ITS0179862
                    //itemPresed = false;// modified by edo.lee 2013.11.20 ITS 0207978
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
            // added by Dmitry 18.08.13 for ITS0176369
            else if ( status == UIListenerEnum.KEY_STATUS_CANCELED )
            {
               scrollTimer.stop(); // added by Sergey 27.09.2013 for ITS#189873
               
               switch (arrow)
               {
                  case UIListenerEnum.JOG_CENTER:
                  {
                     optionmenubase.pressed = false
                     itemPresed = false;
                     break;
                  }
                  default:
                     break;
               }
            }
            // { added by Sergey 27.09.2013 for ITS#189873
            else if ( status == UIListenerEnum.KEY_STATUS_LONG_PRESSED )
            {
                scrollTimer.lastPressed = arrow;
                scrollTimer.start();
            }
            // } added by Sergey 27.09.2013 for ITS#189873
        }
    }
// modified by Dmitry 19.05.13

    function focusNext( dir, isLoop ) // modified by Sergey 09.10.2013 for ITS#194180
    {
        if(vScroll.visible && isLoop) // modified by Sergey 09.10.2013 for ITS#194180
        {
            //Looping logic
            for( var i = 0; i < listarea.count ; i++ )
            {
                if(listarea.model.getEnabled( ( i + listarea.currentIndex + 1) % listarea.count) == false)
                    continue;
                listarea.currentIndex =  ( i + listarea.currentIndex + 1 ) % listarea.count;
                __LOG("optionfocus focusNext listarea.currentIndex = "+ listarea.currentIndex);
                return focus_id
            }
        }
        else
        {
            for( var i = listarea.currentIndex + 1; i < listarea.count; i++ )
            {

                if(listarea.model.getEnabled(i) == false)
                    continue
                listarea.currentIndex = i
                //__LOG("optionfocus focusNext listarea.currentIndex = "+ listarea.currentIndex);
                return focus_id
            }
            return focus_id
        }
        //}changed by junam

        optionmenubase.onLostFocus( dir, focus_id )
        return -1;
    }

    function focusPrev( dir, isLoop ) // modified by Sergey 09.10.2013 for ITS#194180
    {
        if(vScroll.visible && isLoop) // modified by Sergey 09.10.2013 for ITS#194180
        {
            //Looping logic
            for( var i = 0; i < listarea.count ; i++ )
            {
                if( listarea.model.getEnabled( ( listarea.currentIndex + listarea.count - 1 - i ) % listarea.count) == false)
                    continue;
                listarea.currentIndex =  (listarea.currentIndex + listarea.count - 1 - i ) % listarea.count;
                __LOG("optionfocus focusPrev listarea.currentIndex = "+ listarea.currentIndex);
                return focus_id
            }
        }
        else
        {
            for( var i = listarea.currentIndex - 1; i >= 0; i-- )
            {
                
                if( listarea.model.getEnabled(i) == false)
                    continue
                listarea.currentIndex = i
                __LOG("optionfocus focusPrev listarea.currentIndex = "+ listarea.currentIndex);
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
           for( var i = 0; i < listarea.count ; i++ )
           {
               if(listarea.model.getEnabled(i) == false)
                   continue
               if((listarea.model.isCheckBox(i) || listarea.model.isRadioBtn(i)) && //modified by cychoi 2013.12.20 ITS 216925
                  listarea.model.getSelected(i)) //added by junam 2013.09.10 ITS_KOR_185229
               {
                   continue
               }
               else
               {
                   listarea.currentIndex = i
                   return
               }
           }

           //{added by junam 2013.09.10 ITS_KOR_185229
           //if default index cannot find with previouse two condition. try again with one condition.
           for( var i = 0; i < listarea.count ; i++ )
           {
               if(listarea.model.getEnabled(i) == false)
                   continue
               else
               {
                   listarea.currentIndex = i
                   return
               }
           }
           //}added by junam
       }
       else
       {
          listarea.currentIndex == previousFocusIndex
       }
    }
// modified by Dmitry 19.05.13

    delegate: Item
    {
        id: listItem
        height: CONST.const_OPTION_MENU_ITEM_HEIGTH
        width: CONST.const_OPTION_MENU_ITEM_WIDTH_L0
        anchors.left: parent.left
        anchors.leftMargin: CONST.const_OPTION_MENU_LIST_LEFT_MARGIN

        property bool isPressed: pressedArea.pressed // added by Sergey 13.01.2013 for ITS#219044

        enabled: bEnabled
	//modified for list focus image 20131029
        /** Delimiter item section */
        Image
        {
            id: separator

            anchors.horizontalCenter: parent.horizontalCenter
            source:  CONST.const_OPTION_MENU_DELIMITER_1
            y: CONST.const_OPTION_MENU_ITEM_HEIGTH
        }
        
        /** Press image */
        Image
        {
            id: highlight_img
            anchors.left: parent.left
            anchors.leftMargin: CONST.const_OPTION_MENU_LIST_ITEM_IMAGE_LEFT_MARGIN
	    //modified for list focus image 20131029
            anchors.top: separator.top
            anchors.topMargin: -80
            anchors.bottom: separator.bottom     
            anchors.bottomMargin: -2.5       
            z:10

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            visible: bEnabled
            source :( ( itemPresed &&
                        ( listarea.currentIndex == index ) ) || pressedArea.pressed ) ? CONST.const_OPTION_MENU_LIST_PRESS : ""
        }

        /** Focuse image */
        Image
        {
            id: focuse_img
            anchors.left: parent.left
            anchors.leftMargin: CONST.const_OPTION_MENU_LIST_ITEM_IMAGE_LEFT_MARGIN
	    //modified for list focus image 20131029
            anchors.top: separator.top
            anchors.topMargin: -80
            anchors.bottom: separator.bottom            
            anchors.bottomMargin: -2.5  
            
            source: CONST.const_OPTION_MENU_LIST_FOCUS
            visible: ( listarea.currentIndex == index ) && focus_visible && ! ( itemPresed || pressedArea.pressed )

        }

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
            z:15    // modified by yongkyun.lee 2014-12-11 for : ITS 253983 
        }

        /** Text item */
	
        DHAVN_OptionMenu_Marquee_Text
        {
            id: item_text

            text: ( itemName.substring( 0, 4 ) == "STR_" ) ?
                      qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, itemName ):
            itemName

            anchors.left: parent.left // modified by Dmitry 03.05.13
            anchors.leftMargin: !item_icon.visible ? CONST.const_OPTION_MENU_LIST_ITEM_TEXT_LEFT_MARGIN :
            CONST.const_OPTION_MENU_LIST_ITEM_TEXT_LEFT_MARGIN + 61

            scrollingTicker: listarea.scrollingTicker && ( listarea.currentIndex == index ) && focus_visible

            color: updateColor(bEnabled, listarea.currentIndex, listItem.isPressed) // added by Sergey 13.01.2013 for ITS#219044

            anchors.verticalCenter: parent.verticalCenter

            fontSize: CONST.const_OPTION_MENU_TEXT_PT
            fontFamily: CONST.const_OPTION_MENU_TEXT_FONT_FAMILY_NEW_HDR

            width: (item_icon.visible || item_arrow.visible || item_radio.visible) ? 324 : 375

            z: 11 //modified for list focus image 20131029

            // { added by Sergey 13.01.2013 for ITS#219044
            function updateColor(isItemEnabled, focusedIndex, isItemPressed)
            {
                var result = CONST.const_OPTION_MENU_TEXT_COLOR_NORMAL;

                if(isItemEnabled)
                {
                    var isItemFocused = focusedIndex == index;

                    if(isItemFocused || isItemPressed)
                    {
                        result = CONST.const_OPTION_MENU_TEXT_COLOR_FOCUS;
                    }
                }
                else
                {
                    // { added by cychoi 2014.03.04 for ITS 228111
                    if(itemName.substring( 0, 23 ) == "STR_SETTING_DVD_CHANGE_" ||
                            (index == 0 && itemName.substring( 0, 23 ) == "STR_MEDIA_VOICE_SETTING"))  // modified by AVP 2014.04.14 for ITS 234469 GUI Fix
                    {
                        result = CONST.const_OPTION_MENU_TEXT_COLOR_FOCUS;
                    }
                    else
                    {
                        result = CONST.const_OPTION_MENU_TEXT_COLOR_DISABLE;
                    }
                    // } added by cychoi 2014.03.04
                }

                return result;
            }
            // } added by Sergey 13.01.2013 for ITS#219044
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
            z: 12 // added by Sergey for 14.01.2014 for ITS#219469
            opacity: (bEnabled == true) ? 1.0 : 0.5 // added by cychoi 2014.02.19 for (HMC Request)
        }

        /** Checkbox item section */
        Image
        {
            id: item_check

            anchors.verticalCenter: parent.verticalCenter

            anchors.right: highlight_img.right
            anchors.rightMargin: 15
            z: 12 // added by yungi 2014.01.13 for ITS 219465
            opacity: (bEnabled == true) ? 1.0 : 0.5 // added by cychoi 2014.02.19 for (HMC Request)


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
            z: 12 // added by yungi 2014.01.13 for ITS 219465
// modified by Dmitry 03.05.13
            opacity: (bEnabled == true) ? 1.0 : 0.5 // added by cychoi 2014.02.19 for (HMC Request)
            source: !radioButton ? "" : ( isSelected ) ?
                                        CONST.const_OPTION_MENU_RADIO_ON :
                                        CONST.const_OPTION_MENU_RADIO_OFF
        }

//modified for list focus image 20131029

        MouseArea
        {
            id: pressedArea
            anchors.fill: parent
            enabled: !root_menu.disabled

            beepEnabled: false

            onClicked:
            {
               listarea.currentIndex = index;
	       //{modified by aettie 20130829 for ITS 187113
                if ( hasNextLevel )
               {
                  listarea.nextMenuSelect( itemId, listarea.currentIndex );
               }

               if ( checkBox )
               {
                   listarea.model.checkBoxSelected( listarea.currentIndex, !isSelected );
                   listarea.checkBoxSelect( itemId, isSelected )
               }

               if ( radioButton )
               {
                   listarea.radioItemReleased = true;
                   listarea.model.radioButtonSelected( listarea.currentIndex );
                   listarea.radioBtnSelect( itemId );
               }

               if ( !hasNextLevel && !checkBox && !radioButton )
               {
                   listarea.itemReleased = true;// added by taihyun.ahn 2013.12.03
                  listarea.textItemSelect( itemId );
               }

                optionmenubase.beep();

            }

            onCanceled:
            {                                    
               itemPresed = false;
            }

            onExited:
            {
                itemPresed = false;
            }
        }

        Connections
        {
            target: ( index == listarea.currentIndex && bEnabled ) ? listarea : null

            onItemJogCenterClicked:
            {
               if ( hasNextLevel )
               {
                  listarea.nextMenuSelect( itemId, listarea.currentIndex );
               }

               if ( checkBox )
               {
                   listarea.model.checkBoxSelected( listarea.currentIndex, !isSelected );
                   listarea.checkBoxSelect( itemId, isSelected )
               }

               if ( radioButton )
               {
                   listarea.radioItemReleased = true;
                   listarea.model.radioButtonSelected( listarea.currentIndex );
                   listarea.radioBtnSelect( itemId );
               }

               if ( !hasNextLevel && !checkBox && !radioButton )
               {
                   listarea.itemReleased = true;// added by taihyun.ahn 2013.12.03
                  listarea.textItemSelect( itemId );
               }
            }

// added by Dmitry 19.05.13
            onNextLevel:
            {
               if ( hasNextLevel )
               {
                  listarea.nextMenuSelect( itemId, listarea.currentIndex );
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

    // deleted by oseong.kwon 2014.08.04 for show log

    // { added by Sergey 03.10.2013 for ITS#189873, 193212
    Timer
    {
       id: scrollTimer
       interval: 100
       running: false
       repeat: true
       triggeredOnStart: true
       property int lastPressed: -1

       onTriggered:
       {
           if (lastPressed == UIListenerEnum.JOG_UP)
           {
               focusPrev(UIListenerEnum.JOG_WHEEL_LEFT, false); // modified by Sergey 09.10.2013 for ITS#194180
           }
           else if (lastPressed == UIListenerEnum.JOG_DOWN)
           {
               focusNext(UIListenerEnum.JOG_WHEEL_RIGHT, false); // modified by Sergey 09.10.2013 for ITS#194180
           }
       }
    }
    // } added by Sergey 03.10.2013 for ITS#189873, 193212

}
// modified by Sergey 19.08.13 for ITS#182988


