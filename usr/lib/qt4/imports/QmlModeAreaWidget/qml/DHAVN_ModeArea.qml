import Qt 4.7
import QtQuick 1.1 // added by ravikanth 03-05-13
import AppEngineQMLConstants 1.0
import "DHAVN_ModeArea.js" as MODEAREA

Image
{
    id: mode_area
    width: MODEAREA.const_WIDGET_WIDTH;
    height: MODEAREA.const_WIDGET_HEIGHT;
    x: 0; y: MODEAREA.const_WIDGET_Y;
    source: isTrBG? MODEAREA.const_WIDGET_BG_IMG_TR : MODEAREA.const_WIDGET_BG_IMG;

    property bool isTrBG: modeAreaModel.isTrBG || false

    property bool button_pressed: false
    property int focus_index: -1
    property bool isTabButtonsEnabled: modeAreaModel.isTabBtnsDisable ? false : true
    property bool search_visible: modeAreaModel.search_visible || false
    property bool image_type_visible: modeAreaModel.image_type_visible || false // added by eugene 2012.12.12 for NewUX - Photo #5-2
    property bool isFolder: modeAreaModel.isFolder || false // added by eugene 2012.12.12 for NewUX - Photo #5-2
    property bool isListMode: modeAreaModel.isListMode || false // added by eugene 2012.12.12 for NewUX - Photo #5-2
    property bool counter_visible: modeAreaModel.counter_visible || false
    property bool right_text_visible: modeAreaModel.right_text_visible || false
    property bool right_text_visible_f: modeAreaModel.right_text_visible_f || false //added by aettie 2012.12.20 for new ux
    property bool rb_visible: modeAreaModel.rb_visible || false
    property bool mb_visible: modeAreaModel.mb_visible || false // added by minho 20120821 for NEW UX: Added menu button on ModeArea
    property bool bb_visible: ( modeAreaModel.bb_visible == false ) ? false : true
    property bool isMusicState: modeAreaModel.isMusicState || false // added by lssanh 2012.09.22 for music_tab
    property bool mirrored_layout: modeAreaModel.mirrored_layout || false // added by ravikanth 03-05-13 for mirror layout

    property string mode_area_text: modeAreaModel.text || ""
    property string mode_area_file_count: modeAreaModel.file_count || ""  //added by yungi 2013.03.06 for New UX FileCount
    property string mode_area_image: modeAreaModel.image || ""
    property string mode_area_right_text: modeAreaModel.mode_area_right_text || ""
    property string mode_area_right_text_f: modeAreaModel.mode_area_right_text_f || "" //added by aettie 2012.12.20 for new ux
    property string mode_area_right_menu_text: modeAreaModel.mode_area_right_menu_text || ""  // added by minho 20120821 for NEW UX: Added menu button on ModeArea
    property string mode_area_counter_number: modeAreaModel.mode_area_counter_number || 0
    property string mode_area_counter_total: modeAreaModel.mode_area_counter_total || 0
    property string mode_area_icon: modeAreaModel.icon || "" //added by aettie 2012.12.20 for new ux
    property string mode_area_icon_folder: modeAreaModel.icon_cat_folder || "" //added by aettie 2012.12.20 for new ux

    property bool is_pbc_menu: modeAreaModel.is_pbc_menu || false //added by aettie.ji for ISV 67968
    property bool is_popup_shown: false // added by cychoi 2014.01.09 for ITS 218953

    LayoutMirroring.enabled: mirrored_layout // added by ravikanth 03-05-13 for mirror layout
    LayoutMirroring.childrenInherit: mirrored_layout // added by ravikanth 03-05-13 for mirror layout

    /** Incoming ListModel parameters */
    property ListModel modeAreaModel: ListModel{}

    /** Output parameters */
    property int titleWidth: mode_area_title.width
    property variant titleFont: mode_area_title.font

    /** Public properties */
    property int currentSelectedIndex: -1
    property bool focus_visible: false
    property int focus_id: -1
    property bool is_focusable: true
    property bool is_lockoutMode: false //added by edo.lee 2013.09.07
    property bool is_MP3CDReadComplete: false //added by eunhye 2013.04.23
    property bool isListDisabled: false  // added by by junam 2013.05.02 for disable list
    property bool bAutoBeep: true // added by Sergey 19.11.2013 for beep issue
    property bool isSameScreem: true
    property bool isAVPMode: false // DUAL_KEY
    property string name_fr: modeAreaModel.name_fr || "" // modified by cychoi 2014.07.17 for ITS 242695 (ITS 236729) title suffix // added by AVP 2014.04.24 for KH GUI
    property bool isFMMode: false //added for ITS 241667 2014.06.30
    property bool isPhotoMode: false

    /** Signals */
    signal modeArea_RightBtn;
    signal modeArea_MenuBtn; // added by minho 20120821 for NEW UX: Added menu button on ModeArea
    signal modeArea_BackBtn(bool isJogDial, bool bRRC); //modified by aettie 20130620 for Backkey
    signal modeArea_TabClicked; // added by yongkyun.lee 2012.09.25 : CR 13733 : Sound Path
    signal modeArea_Tab( variant tabId );
    signal modeArea_SearchBar;
    signal lostFocus( int arrow, int focusID );
    signal modeArea_BtnPressed;
    signal jogEvent(int arrow, int status); // added by Sergey 03.10.2013 for ITS#193201
    signal beep(); // added by Sergey 19.11.2013 for beep issue
    signal qmlLog(string Log); // added by oseong.kwon 2014.08.04 for show log

    // { added by oseong.kwon 2014.08.04 for show log
    function __LOG(Log)
    {
       qmlLog( "DHAVN_ModArea.qml: " + Log );
    }
    // } added by oseong.kwon 2014.08.04

    /** Public function */
    function retranslateUI( context )
    {
    }

    /** Focus interface functions */
    function hideFocus() { focus_visible = false; button_pressed = false; }
    function showFocus() { focus_visible = true; button_pressed = false; }
    function handleJogEvent( arrow, status ) {}

    function setDefaultFocus( arrow )
    {
        var res = -1
        switch ( arrow )
        {
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            case UIListenerEnum.JOG_UP: // added by cychoi 2014.07.11 for ITS 241667 default focus when mode area has focus
            {
                focus_index = -1
                res = focusNext( arrow )
                break;
            }
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
                focus_index = modeAreaModel.count + MODEAREA.BACK_BTN
                res = focusPrev( arrow )
                break;
            }
            default:
            {
                if ( focus_index >= 0 ) focus_index--;
                res = focusNext( arrow )
                break;
            }
        }
        return res;
    }

/*----------------------------------------------------------------*/
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*----------------------------------------------------------------*/
/* ------------- Private mothods and functions ------------------ */
/*----------------------------------------------------------------*/


    onModeAreaModelChanged: focus_index = -1
    onIs_lockoutModeChanged:
    {
        if(is_lockoutMode)
        {
            focus_index = modeAreaModel.count + MODEAREA.BACK_BTN;
            button_pressed = false; //added by Micahel.Kim 2013.10.14 for ITS 194827
        }
    }

    function focusNext( dir )
    {
        var  focusIndex = focus_index + 1;

        for( focusIndex; focusIndex < modeAreaModel.count; focusIndex++ )
        {
            if ( !modeAreaModel.isTabBtnsDisable &&
                 !modeAreaModel.get( focusIndex ).isDisable &&
                  modeAreaModel.get( focusIndex ).isVisible 
                  && modeAreaModel.get( focusIndex ).bFocusAble) //{ added by yongkyun.lee 20130221 for : NO CR  , modearea focus

            {
                focus_index = focusIndex;
                return focus_id
            }
        }

        focusIndex -= modeAreaModel.count

        if ( focusIndex == MODEAREA.SEARCH_BAR )
        {
            if ( mode_area.search_visible )
            {
                focus_index = modeAreaModel.count + MODEAREA.SEARCH_BAR;
                return focus_id;
            }
            focusIndex++
        }
        // added by minho 20120821
        // { for NEW UX: Added menu button on ModeArea
        if ( focusIndex == MODEAREA.RIGHT_BTN )
        {
	// { modified by eunhye 2013.04.23
	    //if ( mode_area.rb_visible )
            if ( mode_area.rb_visible && !r_btn.bDisabled )
            {
                focus_index = modeAreaModel.count + MODEAREA.RIGHT_BTN;
                return focus_id;
            }
            else  if ( mode_area.mb_visible && !m_btn.bDisabled) // Added by Radhakrushna , Fix : No Focus , if only one item in mode area , 2013.05.11
            {
                focus_index = modeAreaModel.count + MODEAREA.MENU_BTN;
	// } modified by eunhye 2013.04.23
                return focus_id;
            }
            focusIndex++
        }
        if ( focusIndex == MODEAREA.MENU_BTN )
        {
            if ( mode_area.mb_visible && !m_btn.bDisabled)//added by edo.lee 2013.09.07 ITS 187822
            {
                focus_index = modeAreaModel.count + MODEAREA.MENU_BTN;
                return focus_id;
            }
            focusIndex++
        }

        if ( focusIndex == MODEAREA.BACK_BTN && mode_area.bb_visible )
        {
            focus_index = modeAreaModel.count + MODEAREA.BACK_BTN;
            return focus_id;
        }

        // commented below code for ITS 0191073, changes for removal of cyclic rotation of buttons focus
        //if( focusIndex != MODEAREA.MENU_BTN )
        //{
        //    if(rb_visible && !r_btn.bDisabled)// modified by eunhye 2013.04.23
        //        focus_index = modeAreaModel.count + MODEAREA.RIGHT_BTN;
        //    else if (mb_visible && !m_btn.bDisabled ) // // Added by Radhakrushna, Fix : No Focus jumps, if only one item in mode area , 2013.05.11
        //        focus_index = modeAreaModel.count + MODEAREA.MENU_BTN;
        //    else{}
        //    return focus_id;
        //}
        return -1
    }

    function focusPrev( dir )
    {
        var  focusIndex = focus_index - modeAreaModel.count - 1;
        // added by minho 20120821
        // { for NEW UX: Added menu button on ModeArea
        if ( focusIndex == MODEAREA.BACK_BTN )
        {
             if ( mode_area.bb_visible )
             {                
                 focus_index = modeAreaModel.count + MODEAREA.BACK_BTN;
                 return focus_id;
             }
             focusIndex--
        }
        if ( focusIndex == MODEAREA.MENU_BTN  && !m_btn.bDisabled)//added by edo.lee 2013.09.07 ITS 187822
        {
             if ( mode_area.mb_visible )
             {
                 focus_index = modeAreaModel.count + MODEAREA.MENU_BTN;
                 return focus_id;
             }
             focusIndex--
        }

        if ( focusIndex == MODEAREA.RIGHT_BTN && !r_btn.bDisabled )// modified by eunhye 2013.04.23
        {
             if ( mode_area.rb_visible )
             {
                 focus_index = modeAreaModel.count + MODEAREA.RIGHT_BTN;
                 return focus_id;
             }
             focusIndex--
        }
        if ( focusIndex == MODEAREA.SEARCH_BAR &&
             mode_area.search_visible )
        {
            focus_index = modeAreaModel.count + MODEAREA.SEARCH_BAR;
            return focus_id;
        }

        focusIndex = ( ( focus_index - 1 ) >= modeAreaModel.count ) ?
                         modeAreaModel.count - 1 :
                         focus_index - 1

        for( ; focusIndex > -1 && focusIndex < modeAreaModel.count; focusIndex--)
        {
              if ( !modeAreaModel.isTabBtnsDisable &&
                   !modeAreaModel.get( focusIndex ).isDisable &&
                    modeAreaModel.get(focusIndex).isVisible
                   && modeAreaModel.get( focusIndex ).bFocusAble) //{ added by yongkyun.lee 20130221 for : NO CR  , modearea focus
              {
                  focus_index = focusIndex;
                  return focus_id
              }
        }

        // commented below code for ITS 0191073, changes for removal of cyclic rotation of buttons focus
        //if ( focusIndex != MODEAREA.BACK_BTN )
        //{
        //     focus_index = modeAreaModel.count + MODEAREA.BACK_BTN;
        //     return focus_id;
        //}
        return -1
    }

    Connections
    {
        target: focus_visible&&isSameScreem ? (isAVPMode?EngineListener:UIListener) : null

// modified by Dmitry 15.05.13
        onSignalJogNavigation:
        {
            jogEvent(arrow, status); // added by Sergey 03.10.2013 for ITS#193201

             //{modified by taihyun.ahn for ITS 218397 2014.01.08
            if(isAVPMode)
            {
                __LOG("disp = " + SM.disp + " bRRC = " +bRRC)
                if(!((SM.disp == 0 && !bRRC) || (SM.disp == 1 && bRRC)) && !EngineListenerMain.getCloneState4QML())//moeified by taihyun.ahn 2014.01.13
                {
                    return;
                }
            }
             //}modified by taihyun.ahn for ITS 218397 2014.01.08
            if ( status == UIListenerEnum.KEY_STATUS_PRESSED )
            {
                __LOG("DUAL_KEY ModeArea onSignalJogNavigation PRESSED " + status + " lockout = " + is_lockoutMode)
                switch ( arrow )
                {
                    case UIListenerEnum.JOG_LEFT:
                    case UIListenerEnum.JOG_RIGHT:
                    {   
                        button_pressed = false;
                        break;
                    }
                    case UIListenerEnum.JOG_CENTER:
                    {   
                        if(is_popup_shown == false) button_pressed = true; // added by cychoi 2015.09.23 for ITS 269113
                        break;
                    }
                    case UIListenerEnum.JOG_WHEEL_LEFT:
                    {
                        button_pressed = false
                        mirrored_layout ? focusNext( arrow ) : focusPrev( arrow ) // modified by ravikanth 03-05-13 for mirror layout
                        break;
                    }
                    case UIListenerEnum.JOG_WHEEL_RIGHT:
                    {
                        button_pressed = false
                        mirrored_layout ? focusPrev( arrow ) : focusNext( arrow ) // modified by ravikanth 03-05-13 for mirror layout
                        break;
                    }
		    //modified by aettie Focus moves when pressed 20131015
                    default: 
                    { 
                        // { added by cychoi 2014.07.11 for no lost focus on JOP_UP event
                        if(arrow == UIListenerEnum.JOG_UP)
                        {
                            // should not lost focus on JOG_UP event
                            break;
                        }
                        // } added by cychoi 2014.07.11
                        mode_area.lostFocus( arrow, focus_id ); 
                        break;
                    }
                }
            }
            else if ( status == UIListenerEnum.KEY_STATUS_RELEASED )
            {
                __LOG("DUAL_KEY ModeArea onSignalJogNavigation RELEASED " + status)
                switch ( arrow )
                {
                    case UIListenerEnum.JOG_CENTER:
                    {
                        //{ added 2014.01.08 for ITS_NA_218502
                        if(button_pressed == false)
                        {
                            __LOG("released without pressed event - ignore")
                            break;
                        }
                        //} added 2014.01.08 for ITS_NA_218502

                        button_pressed = false; // added by Sergey 2013.09.26 for ITS#191449
                        if ( focus_index >=0 && focus_index < modeAreaModel.count )
                        {
                           mode_area.modeArea_TabClicked()
                           currentSelectedIndex = focus_index;
                        }
                        else
                        {
                            switch ( mode_area.focus_index - modeAreaModel.count )
                            {
                                case MODEAREA.SEARCH_BAR: { mode_area.modeArea_SearchBar(); break; }
                                case MODEAREA.RIGHT_BTN: { mode_area.modeArea_RightBtn(); break;  }
                                case MODEAREA.MENU_BTN: {  mode_area.modeArea_MenuBtn(); break;  } // added by minho 20120821 for NEW UX: Added menu button on ModeArea
                                case MODEAREA.BACK_BTN: 
                                { 
                                        mode_area.modeArea_BackBtn(true, bRRC); //modified by aettie 20130620 for Backkey
                                }
                            }
                            mode_area.modeArea_BtnPressed(); // modified by ravikanth for ITS 0190633
                        }
                        // removed by Sergey 2013.09.26 for ITS#191449
                        break;
                    }
                    case UIListenerEnum.JOG_LEFT:
                    case UIListenerEnum.JOG_RIGHT:
                    {   
                        button_pressed = false; 
                        break;
                    }
		    //moved
                }
            }
// added by Dmitry 18.08.13 for ITS0176369
            else if ( status == UIListenerEnum.KEY_STATUS_CANCELED )
            {
                __LOG("DUAL_KEY ModeArea onSignalJogNavigation CANCELED " + status)
                switch ( arrow )
                {
                    case UIListenerEnum.JOG_CENTER:
                    {
                       button_pressed = false;
                       break;
                    }

                    default:
                       break;
                }
            }
        }
    }
// modified by Dmitry 15.05.13

    /** Right buttons + file count */
    Row
    {
        id: rightAlignment
        anchors.right: parent.right
        anchors.rightMargin: MODEAREA.const_WIDGET_RIGHTMARGIN
        //anchors.verticalCenter: parent.verticalCenter //removed by hyejin.noh for 20140701 ITS 0241396
        spacing: MODEAREA.const_WIDGET_SPACING

        /** Search widget */
        Image
        {
            anchors.verticalCenter: parent.verticalCenter
            source: search_visible ? MODEAREA.const_WIDGET_SEARCH_IMG : ""
            visible: search_visible

            Text
            {
                id: search_text_cmp
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: MODEAREA.const_WIDGET_SEARCH_TEXT_LEFTMARGIN
                color: MODEAREA.const_WIDGET_SEARCH_TEXT_COLOR
                font.pointSize: MODEAREA.const_WIDGET_SEARCH_TEXT_PT //modified by aettie.ji 2012.12.12 for uxlaunch
                text: search_visible ? qsTranslate( LocTrigger.empty + MODEAREA.const_WIDGET_LANGCONTEXT, "STR_MEDIA_SEARCH" ):
                      ""
            }

            MouseArea
            {
                anchors.fill: parent
                onPressed: search_text_cmp.visible = false
                onReleased: search_text_cmp.visible = true
                onClicked: mode_area.modeArea_SearchBar()
            }

            Rectangle
            {
                anchors.fill: parent
                anchors.margins: -5
                color: "transparent"
                border { color: MODEAREA.const_WIDGET_SEARCH_FOCUS_COLOR; width: 5 }
                radius: 3
                smooth: true
                visible: ( mode_area.focus_index == modeAreaModel.count + MODEAREA.SEARCH_BAR ) && focus_visible
            }
        }
	
	// { added by eugene 2012.12.12 for NewUX - Photo #5-2
	Image 
        {
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: MODEAREA.const_WIDGET_CATEGORY_ICON_VERTICAL_OFFSET 
            source: isFolder ? MODEAREA.const_FOLDER_IMAGE_ICON_IMG : 
                        (image_type_visible)? MODEAREA.const_PHOTO_IMAGE_ICON_IMG: MODEAREA.const_VIDEO_IMAGE_ICON_IMG
            visible: fileCount.visible
            anchors.right: fileCount.right
            anchors.rightMargin: fileCount.text.length*18 + 5  
	}
	//}  added by eugene 2012.12.12 for NewUX - Photo #5-2
        
	/** file count */
        Text
        {
            id: fileCount //added by aettie.ji 2012.12.20 for new ux
            font.pointSize: MODEAREA.const_WIDGET_COUNTER_TEXT_PIXEL_SIZE   //modified by aettie.ji 2012.12.12 for uxlaunch
            anchors.verticalCenter: parent.verticalCenter
            color: MODEAREA.const_WIDGET_RB_COLOR
            font.family: MODEAREA.const_WIDGET_COUNTER_TEXT_FONT_FAMILY_NEW
            text: mirrored_layout ? mode_area_counter_total + "/" + mode_area_counter_number:
                                mode_area_counter_number + "/" + mode_area_counter_total //modified by taewoong.jeon 2013.08.31 ITS 185789 // added by ravikanth 03-05-13 for mirror layout
            style: Text.Sunken
            clip: true
            visible: counter_visible
            anchors.right: rb_visible ? r_btn.left : (mb_visible? m_btn.left : b_btn.left)
            anchors.rightMargin: 15
        }

        Image
        {
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: MODEAREA.const_WIDGET_CATEGORY_ICON_VERTICAL_OFFSET
            source: mode_area_icon_folder
            visible: right_text_visible_f
            anchors.right: rightText_folder.right
            anchors.rightMargin: rightText_folder.text.length*18 + 5
        }

        /** right text for folder category */
        Text
        {
            id: rightText_folder
            font.pointSize: MODEAREA.const_WIDGET_COUNTER_TEXT_PIXEL_SIZE   
            anchors.verticalCenter: parent.verticalCenter
            color: MODEAREA.const_WIDGET_RB_COLOR
            font.family: MODEAREA.const_WIDGET_COUNTER_TEXT_FONT_FAMILY_NEW
            text: mode_area_right_text_f
            style: Text.Sunken
            clip: true
            visible: right_text_visible_f
            anchors.right: rightText_icon.left
            anchors.rightMargin: 15
        }
	
        Image
        {
            id: rightText_icon
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: MODEAREA.const_WIDGET_CATEGORY_ICON_VERTICAL_OFFSET
            source: mode_area_icon
            visible: right_text_visible
            anchors.right: rightText.right // modified by Sergey 08.05.2013
            anchors.rightMargin: rightText.text.length*18 + 5 // correct this margin if the font is changed // modified by Sergey 08.05.2013
        }
        //}added by aettie.ji 2012.12.20 for new ux
	
        /** right text */
        Text
        {
            id: rightText   //added by aettie.ji 2012.12.20 for new ux
            font.pointSize: MODEAREA.const_WIDGET_COUNTER_TEXT_PIXEL_SIZE   //modified by aettie.ji 2012.12.12 for uxlaunch
            anchors.verticalCenter: parent.verticalCenter
            color: MODEAREA.const_WIDGET_RB_COLOR
            font.family: MODEAREA.const_WIDGET_COUNTER_TEXT_FONT_FAMILY_NEW
            text: mode_area_right_text
            style: Text.Sunken
            clip: true
            visible: right_text_visible
            anchors.right: rb_visible ? r_btn.left : (mb_visible? m_btn.left : b_btn.left)
            anchors.rightMargin: 15
        }


        /** Right button */
        DHAVN_ModeArea_Button
        {
            id: r_btn  //added by aettie.ji 2011.11.11 for New UX

            bg_img_n: (is_pbc_menu)? MODEAREA.const_WIDGET_PBC_BUTTON_NORMAL : MODEAREA.const_WIDGET_RB_IMG_NORMAL
            bg_img_p: (is_pbc_menu)? MODEAREA.const_WIDGET_PBC_BUTTON_PRESSED : MODEAREA.const_WIDGET_RB_IMG_PRESSED
            bg_img_f: (is_pbc_menu)? MODEAREA.const_WIDGET_PBC_BUTTON_FOCUSED : MODEAREA.const_WIDGET_RB_FOCUS_IMG
            //} modified by aettie.ji for ISV 67968

            icon_n: modeAreaModel.rb_icon_n || ""
            icon_p: modeAreaModel.rb_icon_p || ""
            caption: qsTranslate( LocTrigger.empty + MODEAREA.const_WIDGET_LANGCONTEXT, ( modeAreaModel.rb_text || "") )
            bAutoBeep: mode_area.bAutoBeep // added by Sergey 19.11.2013 for beep issue

            onBtnClicked: { mode_area.beep(); mode_area.modeArea_RightBtn() } // added by Sergey 19.11.2013 for beep issue
            onBtnPressed: { mode_area.modeArea_BtnPressed() } // modified by ravikanth for ITS 0190633

            bFocused: (( mode_area.focus_index == modeAreaModel.count + MODEAREA.RIGHT_BTN ) && focus_visible
                      && !(mode_area.is_MP3CDReadComplete || mode_area.isListDisabled)) && !bPressed

            visible: rb_visible;
            bFocusAble: is_lockoutMode ? false : true //added by edo.lee 2013.09.07 ITs 187822

            anchors.right: rb_visible ? ((is_pbc_menu)? b_btn.left : m_btn.left) : b_btn.left
            anchors.rightMargin:-3 //add by youngsim.jo back btn and space modify
            bDisabled: mode_area.is_MP3CDReadComplete || mode_area.isListDisabled || is_lockoutMode //added by edo.lee 2013.09.07 ITS 187822
        }

        Text
        {
            font.pointSize: MODEAREA.const_WIDGET_COUNTER_TEXT_PIXEL_SIZE   //modified by aettie.ji 2012.12.12 for uxlaunch
            anchors.verticalCenter: parent.verticalCenter
            color: MODEAREA.const_WIDGET_RB_COLOR 
            font.family: MODEAREA.const_WIDGET_COUNTER_TEXT_FONT_FAMILY_NEW
            text: mode_area_right_menu_text
            style: Text.Sunken
            clip: true
            visible: right_text_visible
        }

        /** Menu button */
        DHAVN_ModeArea_Button
        {
            id: m_btn   //added by aettie.ji 2011.11.11 for New UX
            bg_img_n: MODEAREA.const_WIDGET_MB_IMG_NORMAL
            bg_img_p: MODEAREA.const_WIDGET_MB_IMG_PRESSED
            bg_img_f: MODEAREA.const_WIDGET_MB_FOCUS_IMG
            icon_n: modeAreaModel.rb_icon_n || ""
            icon_p: modeAreaModel.rb_icon_p || ""
            caption: qsTranslate( LocTrigger.empty + MODEAREA.const_WIDGET_LANGCONTEXT, ( modeAreaModel.mb_text || "") )
            bAutoBeep: mode_area.bAutoBeep // added by Sergey 19.11.2013 for beep issue

            onBtnClicked: { mode_area.beep(); mode_area.modeArea_MenuBtn() } // added by Sergey 19.11.2013 for beep issue
            onBtnPressed: { mode_area.modeArea_BtnPressed() } // modified by ravikanth for ITS 0190633
            bFocused: ( ( mode_area.focus_index == modeAreaModel.count + MODEAREA.MENU_BTN ) && focus_visible ) && !bPressed
            visible: mb_visible            
            bFocusAble: is_lockoutMode ? false : true   //{ added by yongkyun.lee 20130221 for : NO CR  , modearea focus
            bDisabled: is_lockoutMode //added by edo.lee 2013.09.07 ITS 187822
            anchors.right:b_btn.left //add by youngsim.jo back btn and space modify
            anchors.rightMargin:-3 //add by youngsim.jo back btn and space modify
        }
        // } added by minho
        /** Back button */
        DHAVN_ModeArea_Button
        {
            id: b_btn   //added by aettie.ji 2011.11.11 for New UX
            bg_img_n: MODEAREA.const_WIDGET_BB_IMG_NORMAL
            bg_img_p: MODEAREA.const_WIDGET_BB_IMG_PRESSED
            bg_img_f: MODEAREA.const_WIDGET_BB_IMG_FOCUS // added by minho 20120829 for display focus on back button
            bAutoBeep: mode_area.bAutoBeep // added by Sergey 19.11.2013 for beep issue

            onBtnClicked: { 
                __LOG("[MP][VP][QML] ModeArea::Back_key: modeArea_BackBtn notJog touch ");
                mode_area.beep(); // added by Sergey 19.11.2013 for beep issue
                mode_area.modeArea_BackBtn(false, true);
            }
            onBtnPressed: { mode_area.modeArea_BtnPressed() } // modified by ravikanth for ITS 0190633

            bFocused: ( ( mode_area.focus_index == modeAreaModel.count + MODEAREA.BACK_BTN ) && focus_visible ) && !bPressed
            visible: bb_visible
            bFocusAble: true;   //{ added by yongkyun.lee 20130221 for : NO CR  , modearea focus
            bMirror: mirrored_layout // added by ravikanth 03-05-13 for mirror layout
        }
    }


    Component
    {
        id: btnDelegate

        Image
        {
            width: MODEAREA.const_WIDGET_WIDTH
            height: MODEAREA.const_WIDGET_HEIGHT
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            visible: isVisible
            Text
            {
                id: basic_view_mode_area_title // added by AVP 2014.04.28 for VI GUI
                height: MODEAREA.const_WIDGET_HEIGHT
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: MODEAREA.const_WIDGET_TITLE_TEXT_LEFTMARGIN
                text: ( name.substring( 0, 4 ) == "STR_" ) ?
                    qsTranslate( LocTrigger.empty + MODEAREA.const_WIDGET_LANGCONTEXT, ( name || "" ) ) : name
                font.pointSize: MODEAREA.const_WIDGET_TITLE_TEXT_SIZE
                font.family: MODEAREA.const_WIDGET_TAB_TEXT_FONT_FAMILY_NEW
                color: MODEAREA.const_WIDGET_TITLE_COLOR
                verticalAlignment: Text.AlignVCenter
                style: Text.Sunken
                clip: true
            }
            // added by AVP 2014.04.28 for VI GUI
            Text
            {
                id: basic_view_mode_area_title_fr // modified by cychoi 2014.07.17 for ITS 242695 (ITS 236729) title suffix // added by AVP 2014.04.24 for KH GUI
                height: MODEAREA.const_WIDGET_HEIGHT
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: basic_view_mode_area_title.right
                anchors.leftMargin: MODEAREA.const_WIDGET_TITLE_TEXT_LEFTMARGIN_BASIC_VIEW
                text: ( name_fr.substring( 0, 4 ) == "STR_" )?
                    qsTranslate( LocTrigger.empty + MODEAREA.const_WIDGET_LANGCONTEXT, ( name_fr || "" ) ) : name_fr
                font.pointSize: MODEAREA.const_WIDGET_TITLE_TEXT_SIZE
                font.family: MODEAREA.const_WIDGET_TAB_TEXT_FONT_FAMILY_NEW
                color: MODEAREA.const_WIDGET_TITLE_DIMMED_GREY
                verticalAlignment: Text.AlignVCenter
                style: Text.Sunken
                clip: true

            }       
            Component.onCompleted: { if ( model.selected || false ) mode_area.currentSelectedIndex = index }
        }
    }

    Row
    {
        id: leftAlignment
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        anchors.leftMargin: MODEAREA.const_WIDGET_LEFTMARGIN
        anchors.bottomMargin: MODEAREA.const_WIDGET_TAB_BUTTON_BOTTOM_MARGIN
        anchors.verticalCenter: parent.verticalCenter // added by lssanh 2013.04.03 ISV77811
        spacing: MODEAREA.const_WIDGET_SPACING
        Repeater { model: modeAreaModel; delegate: btnDelegate }
    }

    /** Title */
    Text
    {
        id: mode_area_title
        anchors.left: leftAlignment.right
        anchors.leftMargin: MODEAREA.const_WIDGET_TITLE_TEXT_LEFTMARGIN
        
        text: ( mode_area_text.substring( 0, 4 ) == "STR_" ) ?
              qsTranslate( LocTrigger.empty + MODEAREA.const_WIDGET_LANGCONTEXT, ( mode_area_text ) ):
              mode_area_text


        verticalAlignment: Text.AlignVCenter
        height: MODEAREA.const_WIDGET_HEIGHT;
        color: MODEAREA.const_WIDGET_TITLE_COLOR;
        font.pointSize: MODEAREA.const_WIDGET_TITLE_TEXT_SIZE   //modified by aettie.ji 2012.12.11 for new ux launch
        font.family:MODEAREA.const_WIDGET_TAB_TEXT_FONT_FAMILY_NEW
        style: Text.Sunken
        clip: true
    }
    // { added by yungi 2013.03.06 for New UX FileCount
    Text
    {
        id: mode_area_title_file_count
        anchors.left: leftAlignment.right
        anchors.leftMargin: MODEAREA.const_WIDGET_TITLE_TEXT_LEFTMARGIN + mode_area_title.paintedWidth + 15 //modified by aettie 20130826 for ISV 89604

        text: mode_area_file_count

        verticalAlignment: Text.AlignVCenter
        height: MODEAREA.const_WIDGET_HEIGHT;
	
	//modified by aettie 20130826 for ISV 89604
        //color: MODEAREA.const_WIDGET_TITLE_COLOR;
        //font.pointSize: MODEAREA.const_WIDGET_TITLE_TEXT_SIZE
        color: MODEAREA.const_WIDGET_TITLE_COUNTER_COLOR
        font.pointSize: MODEAREA.const_WIDGET_TITLE_COUNTER_TEXT_SIZE
        font.family:MODEAREA.const_WIDGET_TAB_TEXT_FONT_FAMILY_NEW
        style: Text.Sunken
        clip: true
    }
    // } added by yungi 2013.03.06 for New UX FileCount

    onCurrentSelectedIndexChanged:
    {
        if ( ( mode_area.currentSelectedIndex < modeAreaModel.count ) &&
             ( mode_area.currentSelectedIndex >= 0 ) )
        {
            mode_area.modeArea_Tab( modeAreaModel.get( mode_area.currentSelectedIndex ).tab_id )
        }
    }

    function focusedItemClick()
    {
        focusedClick()
    }

    onFocus_visibleChanged:
    {
        if(!focus_visible)
        {
            button_pressed = false; // modified for ITS 0209200
        }
    }
}
