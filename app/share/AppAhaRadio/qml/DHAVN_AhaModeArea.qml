import Qt 4.7
import AppEngineQMLConstants 1.0
import QtQuick 1.1 //hsryu_0516_change_modearea_button
import "DHAVN_AhaModeArea.js" as AHAMODEAREA    //wsuk.kim title_bar
import "DHAVN_AppAhaRes.js" as PR_RES   //wsuk.kim title_bar

Image
{
    id: mode_area
    width: AHAMODEAREA.const_WIDGET_WIDTH;
    height: AHAMODEAREA.const_WIDGET_HEIGHT;
    x: 0; y: AHAMODEAREA.const_WIDGET_Y;
    source: AHAMODEAREA.const_WIDGET_BG_IMG;

    //hsryu_0423_block_play_btcall
    property bool center_clicked: false
    property bool button_pressed: false
    property int focus_index: -1
    property bool isTabButtonsEnabled: modeAreaModel.isTabBtnsDisable ? false : true
    property bool search_visible: modeAreaModel.search_visible || false
    property bool image_type_visible: modeAreaModel.image_type_visible || false // added by eugene 2012.12.12 for NewUX - Photo #5-2
    property bool isFolder: modeAreaModel.isFolder || false // added by eugene 2012.12.12 for NewUX - Photo #5-2
    property bool isListMode: modeAreaModel.isListMode || false // added by eugene 2012.12.12 for NewUX - Photo #5-2
    property bool counter_visible: modeAreaModel.counter_visible || false
//wsuk.kim title_bar
    property bool right2_text_visible: modeAreaModel.right2_text_visible || false
    property bool rb2_visible: modeAreaModel.rb2_visible || false
    property bool right1_text_visible: modeAreaModel.right1_text_visible || false
    property bool rb1_visible: modeAreaModel.rb1_visible || false
//wsuk.kim title_bar
    property bool right_text_visible: modeAreaModel.right_text_visible || false
    property bool right_text_visible_f: modeAreaModel.right_text_visible_f || false //added by aettie 2012.12.20 for new ux
    property bool rb_visible: modeAreaModel.rb_visible || false
    property bool mb_visible: modeAreaModel.mb_visible || false // added by minho 20120821 for NEW UX: Added menu button on ModeArea
    property bool bb_visible: ( modeAreaModel.bb_visible == false ) ? false : true
    property bool isMusicState: modeAreaModel.isMusicState || false // added by lssanh 2012.09.22 for music_tab

    property string mode_area_text: modeAreaModel.text || ""
    property string mode_area_image: modeAreaModel.image || ""
    property string mode_area_right_text: modeAreaModel.mode_area_right_text || ""
    property string mode_area_right_text_f: modeAreaModel.mode_area_right_text_f || "" //added by aettie 2012.12.20 for new ux
    property string mode_area_right_menu_text: modeAreaMenuModel.mode_area_right_menu_text || ""  // added by minho 20120821 for NEW UX: Added menu button on ModeArea
    property int mode_area_counter_number: modeAreaModel.mode_area_counter_number || 0
    property int mode_area_counter_total: modeAreaModel.mode_area_counter_total || 0
    property string mode_area_icon: modeAreaModel.icon || "" //added by aettie 2012.12.20 for new ux
    property string mode_area_icon_folder: modeAreaModel.icon_cat_folder || "" //added by aettie 2012.12.20 for new ux

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
    property bool isListDisabled: false //wsuk.kim 140103 ITS_217672 during BT call, modeAreaButton disable.
    property bool isNoNetwork: false // ITS 225504

    /** Signals */
    signal modeArea_RightBtn2; //wsuk.kim title_bar
    signal modeArea_RightBtn1; //wsuk.kim title_bar
    signal modeArea_RightBtn;
    signal modeArea_MenuBtn; // added by minho 20120821 for NEW UX: Added menu button on ModeArea
    signal modeArea_BackBtn;
    signal modeArea_TabClicked; // added by yongkyun.lee 2012.09.25 : CR 13733 : Sound Path
    signal modeArea_Tab( variant tabId );
    signal modeArea_SearchBar;
    signal lostFocus( int arrow, int focusID );

    /** Public function */
    function retranslateUI( context )
    {
    }

    /** Focus interface functions */
    function hideFocus() {
        focus_visible = false;
        //ITS_0222243
        button_pressed = false;
    }

    function showFocus()
    {
        if(!rb2_visible && focus_index === 1)   //wsuk.kim 131021 call BTN disable, CCP up, focused.
        {
            focus_index = 2;
        }

        if(!rb2_visible && !rb1_visible && (focus_index === 1 || focus_index === 2) )
        {
            focus_index = 4;   // focus on MENU btn
        }

        focus_visible = true
    }
    function handleJogEvent( arrow, status ) {}
    function setDefaultFocus( arrow )
    {
        var res = -1
        switch ( arrow )
        {
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            {
                focus_index = -1
                res = focusNext( arrow )
            }
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
                focus_index = modeAreaModel.count + AHAMODEAREA.BACK_BTN
                res = focusPrev( arrow )
            }
            default:
            {
                if ( focus_index >= 0 ) focus_index--;
                res = focusNext( arrow )
            }
        }
        return res;
    }

//wsuk.kim 131112 ITS_207932 modeArea SK pressed, menu HK make cancel.
    function getButtonPressed()
    {
        var isPressed = 0;

        if(r_btn2.bPressed) isPressed = 1;
        else if(r_btn1.bPressed) isPressed = 1;
        else if(r_btn.bPressed) isPressed = 1;
        else if(m_btn.bPressed) isPressed = 1;
        else if(b_btn.bPressed) isPressed = 1;

        return isPressed;
    }

    function setButtonCancel(isCancel)
    {
        if(r_btn2.bPressed) r_btn2.bCancel = isCancel;
        else if(r_btn1.bPressed) r_btn1.bCancel = isCancel;
        else if(r_btn.bPressed) r_btn.bCancel = isCancel;
        else if(m_btn.bPressed) m_btn.bCancel = isCancel;
        else if(b_btn.bPressed) b_btn.bCancel = isCancel;
    }
//wsuk.kim 131112 ITS_207932 modeArea SK pressed, menu HK make cancel.
/*----------------------------------------------------------------*/
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*----------------------------------------------------------------*/
/* ------------- Private mothods and functions ------------------ */
/*----------------------------------------------------------------*/


    onModeAreaModelChanged: focus_index = -1

    onIsListDisabledChanged:    //wsuk.kim 140103 ITS_217672 during BT call, modeAreaButton disable.
    {
        if(isListDisabled)
        {
            focus_index = modeAreaModel.count + AHAMODEAREA.BACK_BTN;
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

        if ( focusIndex == AHAMODEAREA.SEARCH_BAR )
        {
            if ( mode_area.search_visible )
            {
                focus_index = modeAreaModel.count + AHAMODEAREA.SEARCH_BAR;
                return focus_id;
            }
            focusIndex++
        }
//wsuk.kim title_bar
        if ( focusIndex == AHAMODEAREA.RIGHT_BTN_2 )
        {
            if ( mode_area.rb2_visible )
            {
                focus_index = modeAreaModel.count + AHAMODEAREA.RIGHT_BTN_2;
                return focus_id;
            }
            focusIndex++
        }
        if ( focusIndex == AHAMODEAREA.RIGHT_BTN_1 )
        {
            if ( mode_area.rb1_visible )
            {
                focus_index = modeAreaModel.count + AHAMODEAREA.RIGHT_BTN_1;
                return focus_id;
            }
            focusIndex++
        }
//wsuk.kim title_bar
        // added by minho 20120821
        // { for NEW UX: Added menu button on ModeArea
        if ( focusIndex == AHAMODEAREA.RIGHT_BTN )
        {
            if ( mode_area.rb_visible )
            {
                focus_index = modeAreaModel.count + AHAMODEAREA.RIGHT_BTN;
                return focus_id;
            }
            focusIndex++
        }
        if ( focusIndex == AHAMODEAREA.MENU_BTN )
        {
            if ( mode_area.mb_visible )
            {
                focus_index = modeAreaModel.count + AHAMODEAREA.MENU_BTN;
                return focus_id;
            }
            focusIndex++
        }
        if ( focusIndex == AHAMODEAREA.BACK_BTN && mode_area.bb_visible )
        {
            focus_index = modeAreaModel.count + AHAMODEAREA.BACK_BTN;
            return focus_id;
        }

        mode_area.lostFocus( dir, focus_id );
        return -1
    }

    function focusPrev( dir )
    {
        var  focusIndex = focus_index - modeAreaModel.count - 1;
        // added by minho 20120821
        // { for NEW UX: Added menu button on ModeArea

        if ( focusIndex == AHAMODEAREA.BACK_BTN )
        {
             if ( mode_area.bb_visible )
             {                
                 focus_index = modeAreaModel.count + AHAMODEAREA.BACK_BTN;
                 return focus_id;
             }
             focusIndex--
        }
        if ( focusIndex == AHAMODEAREA.MENU_BTN  && !m_btn.bDisabled )	//wsuk.kim 140103 ITS_217672 during BT call, modeAreaButton disable.
        {
             if ( mode_area.mb_visible )
             {
                 focus_index = modeAreaModel.count + AHAMODEAREA.MENU_BTN;
                 return focus_id;
             }
             focusIndex--
        }
        if ( focusIndex == AHAMODEAREA.RIGHT_BTN && !r_btn.bDisabled )  //wsuk.kim 140103 ITS_217672 during BT call, modeAreaButton disable.
        {
             if ( mode_area.rb_visible )
             {
                 focus_index = modeAreaModel.count + AHAMODEAREA.RIGHT_BTN;
                 return focus_id;
             }
             focusIndex--
        }
//wsuk.kim title_bar
        if ( focusIndex == AHAMODEAREA.RIGHT_BTN_1 && !r_btn1.bDisabled)    //wsuk.kim 140103 ITS_217672 during BT call, modeAreaButton disable.
        {
             if ( mode_area.rb1_visible )
             {
                 focus_index = modeAreaModel.count + AHAMODEAREA.RIGHT_BTN_1;
                 return focus_id;
             }
             focusIndex--
        }
        if ( focusIndex == AHAMODEAREA.RIGHT_BTN_2 && !r_btn2.bDisabled)    //wsuk.kim 140103 ITS_217672 during BT call, modeAreaButton disable.
        {
             if ( mode_area.rb2_visible )
             {
                 focus_index = modeAreaModel.count + AHAMODEAREA.RIGHT_BTN_2;
                 return focus_id;
             }
             focusIndex--
        }
//wsuk.kim title_bar
        if ( focusIndex == AHAMODEAREA.SEARCH_BAR &&
             mode_area.search_visible )
        {
            focus_index = modeAreaModel.count + AHAMODEAREA.SEARCH_BAR;
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

        mode_area.lostFocus( dir, focus_id );
        return -1
    }

    Connections
    {
        target: focus_visible && !popUpTextVisible ? UIListener : null
        onSignalJogCenterPressed: button_pressed = true
        onSignalJogCenterReleased: button_pressed = false

        onSignalJogNavigation:
        {
            //hsryu_0502_jog_control
            if (arrow !== UIListenerEnum.JOG_CENTER && status === UIListenerEnum.KEY_STATUS_RELEASED )
            {
                switch ( arrow )
                {
//wsuk.kim 131105 block JOG LEFT/RIGHT on TrackView modeArea.   case UIListenerEnum.JOG_LEFT:
                    case UIListenerEnum.JOG_WHEEL_LEFT:
                    {
                        button_pressed = false
                        focusPrev( arrow )
                        break;
                    }
//wsuk.kim 131105 block JOG LEFT/RIGHT on TrackView modeArea.   case UIListenerEnum.JOG_RIGHT:
                    case UIListenerEnum.JOG_WHEEL_RIGHT:
                    {
                        button_pressed = false
                        focusNext( arrow )
                        break;
                    }

                    default: { mode_area.lostFocus( arrow, focus_id ) }
                }
            }

            //hsryu_0502_jog_control
            if (arrow === UIListenerEnum.JOG_CENTER && status == UIListenerEnum.KEY_STATUS_RELEASED )
            {
                if ( focus_index >=0 && focus_index < modeAreaModel.count )
                {
                   mode_area.modeArea_TabClicked()
                   currentSelectedIndex = focus_index;
                }
                else
                {
                    switch ( mode_area.focus_index - modeAreaModel.count )
                    {
                        case AHAMODEAREA.SEARCH_BAR: { mode_area.modeArea_SearchBar() }
    //hsryu_0423_block_play_btcall
                        case AHAMODEAREA.RIGHT_BTN_2: {center_clicked = true; mode_area.modeArea_RightBtn2() }
                        case AHAMODEAREA.RIGHT_BTN_1: {center_clicked = true; mode_area.modeArea_RightBtn1() }
    //hsryu_0423_block_play_btcall
                        case AHAMODEAREA.RIGHT_BTN: { mode_area.modeArea_RightBtn() }
                        case AHAMODEAREA.MENU_BTN: { center_clicked = true;  mode_area.modeArea_MenuBtn() }
                        case AHAMODEAREA.BACK_BTN: { mode_area.modeArea_BackBtn() }
                    }
                }
            }
        }
    }
    /** Right buttons + file count */
    Row
    {
        id: rightAlignment
        anchors.right: parent.right
        anchors.rightMargin: AHAMODEAREA.const_WIDGET_RIGHTMARGIN
        anchors.verticalCenter: parent.verticalCenter
        spacing: AHAMODEAREA.const_WIDGET_SPACING

        visible : !ahaController.noActiveStation //hsryu_0329_system_popup
        /** Search widget */
        Image
        {
            anchors.verticalCenter: parent.verticalCenter
            source: search_visible ? AHAMODEAREA.const_WIDGET_SEARCH_IMG : ""
            visible: search_visible

            Text
            {
                id: search_text_cmp
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: AHAMODEAREA.const_WIDGET_SEARCH_TEXT_LEFTMARGIN
                color: AHAMODEAREA.const_WIDGET_SEARCH_TEXT_COLOR
                font.pointSize: AHAMODEAREA.const_WIDGET_SEARCH_TEXT_PT //modified by aettie.ji 2012.12.12 for uxlaunch
                text: search_visible ? qsTranslate( LocTrigger.empty + AHAMODEAREA.const_WIDGET_LANGCONTEXT, "STR_MEDIA_SEARCH" ):
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
                border { color: AHAMODEAREA.const_WIDGET_SEARCH_FOCUS_COLOR; width: 5 }
                radius: 3
                smooth: true
                visible: ( mode_area.focus_index == modeAreaModel.count + AHAMODEAREA.SEARCH_BAR ) && focus_visible
            }
        }
	
	// { added by eugene 2012.12.12 for NewUX - Photo #5-2
	Image 
        {
            anchors.verticalCenter: parent.top
			anchors.verticalCenterOffset: AHAMODEAREA.const_WIDGET_CATEGORY_ICON_VERTICAL_OFFSET 
            source: isFolder ? AHAMODEAREA.const_FOLDER_IMAGE_ICON_IMG : AHAMODEAREA.const_PHOTO_IMAGE_ICON_IMG
            visible: image_type_visible
            anchors.right: fileCount.left 
            anchors.rightMargin: 5
	}
	//}  added by eugene 2012.12.12 for NewUX - Photo #5-2
        
	/** file count */
        Text
        {
            id: fileCount //added by aettie.ji 2012.12.20 for new ux
            font.pointSize: AHAMODEAREA.const_WIDGET_COUNTER_TEXT_PIXEL_SIZE   //modified by aettie.ji 2012.12.12 for uxlaunch
            anchors.verticalCenter: parent.verticalCenter
            color: AHAMODEAREA.const_WIDGET_RB_COLOR
            font.family: AHAMODEAREA.const_WIDGET_COUNTER_TEXT_FONT_FAMILY_NEW
            text: mode_area_counter_number + "/" + mode_area_counter_total
            style: Text.Sunken
            clip: true
            visible: counter_visible
            anchors.right: rb_visible ? r_btn.left : (mb_visible? m_btn.left : b_btn.left)
            anchors.rightMargin: 15
        }

        Image
        {
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: AHAMODEAREA.const_WIDGET_CATEGORY_ICON_VERTICAL_OFFSET
            source: mode_area_icon_folder
            visible: right_text_visible_f
            anchors.right: rightText_folder.left
            anchors.rightMargin: 5
        }

        /** right text for folder category */
        Text
        {
            id: rightText_folder
            font.pointSize: AHAMODEAREA.const_WIDGET_COUNTER_TEXT_PIXEL_SIZE   
            anchors.verticalCenter: parent.verticalCenter
            color: AHAMODEAREA.const_WIDGET_RB_COLOR
            font.family: AHAMODEAREA.const_WIDGET_COUNTER_TEXT_FONT_FAMILY_NEW
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
            anchors.verticalCenterOffset: AHAMODEAREA.const_WIDGET_CATEGORY_ICON_VERTICAL_OFFSET //hsryu_0516_change_modearea_button
            source: mode_area_icon
            visible: right_text_visible
            //hsryu_0516_change_modearea_button
            anchors.right: rightText.right // modified by Sergey 08.05.2013
            anchors.rightMargin: rightText.text.length*18 + 5
        }
        //}added by aettie.ji 2012.12.20 for new ux
	
        /** right text */
        Text
        {
            id: rightText   //added by aettie.ji 2012.12.20 for new ux
            font.pointSize: AHAMODEAREA.const_WIDGET_COUNTER_TEXT_PIXEL_SIZE   //modified by aettie.ji 2012.12.12 for uxlaunch
            anchors.verticalCenter: parent.verticalCenter
            color: AHAMODEAREA.const_WIDGET_RB_COLOR
            font.family: AHAMODEAREA.const_WIDGET_COUNTER_TEXT_FONT_FAMILY_NEW
            text: mode_area_right_text
            style: Text.Sunken
            clip: true
            visible: right_text_visible
            anchors.right: rb_visible ? r_btn.left : (mb_visible? m_btn.left : b_btn.left)
            anchors.rightMargin: 15
        }
//wsuk.kim title_bar
        DHAVN_AhaModeArea_Button
        {
            id: r_btn2
            bg_img_n: AHAMODEAREA.const_WIDGET_RB_IMG_NORMAL
            bg_img_p: AHAMODEAREA.const_WIDGET_RB_IMG_PRESSED
            bg_img_d: AHAMODEAREA.const_WIDGET_RB_IMG_NORMAL//wsuk.kim disable_icon   PR_RES.const_APP_AHA_TRACK_VIEW_PHONE_ICON_D
            bg_img_f: AHAMODEAREA.const_WIDGET_RB_FOCUS_IMG

            //hsryu_0618_trackmode_btn
            width : AHAMODEAREA.const_AHA_MODE_WIDGET_RB_WIDTH

            Image
            {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: isListDisabled? AHAMODEAREA.const_APP_AHA_TRACK_VIEW_ICON_CALL_D: (rb2_visible? AHAMODEAREA.const_APP_AHA_TRACK_VIEW_ICON_CALL_N: AHAMODEAREA.const_APP_AHA_TRACK_VIEW_ICON_CALL_D)//wsuk.kim disable_icon    AHAMODEAREA.const_APP_AHA_TRACK_VIEW_ICON_CALL
                visible: true   //wsuk.kim disable_icon rb2_visible
            }
            onBtnClicked: { center_clicked = false; mode_area.modeArea_RightBtn2(); } //hsryu_0423_block_play_btcall
            bFocused: ( mode_area.focus_index == modeAreaModel.count + AHAMODEAREA.RIGHT_BTN_2 ) && focus_visible && !bPressed
            visible: (rb1_visible || rb2_visible)? true:false
            bFocusAble: true
            bDisabled: !rb2_visible || isListDisabled    //wsuk.kim 140103 ITS_217672 during BT call, modeAreaButton disable.
        }
        DHAVN_AhaModeArea_Button
        {
            id: r_btn1
            bg_img_n: AHAMODEAREA.const_WIDGET_RB_IMG_NORMAL
            bg_img_p: AHAMODEAREA.const_WIDGET_RB_IMG_PRESSED
            bg_img_d: AHAMODEAREA.const_WIDGET_RB_IMG_NORMAL//wsuk.kim disable_icon PR_RES.const_APP_AHA_TRACK_VIEW_NAVIGATION_ICON_D
            bg_img_f: AHAMODEAREA.const_WIDGET_RB_FOCUS_IMG

            //hsryu_0618_trackmode_btn
            width : AHAMODEAREA.const_AHA_MODE_WIDGET_RB_WIDTH

            Image
            {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: isListDisabled? AHAMODEAREA.const_APP_AHA_TRACK_VIEW_ICON_NAVIGATION_D: (rb1_visible? AHAMODEAREA.const_APP_AHA_TRACK_VIEW_ICON_NAVIGATION_N:AHAMODEAREA.const_APP_AHA_TRACK_VIEW_ICON_NAVIGATION_D)//wsuk.kim disable_icon AHAMODEAREA.const_APP_AHA_TRACK_VIEW_ICON_NAVIGATION
                visible: true   //wsuk.kim disable_icon rb1_visible
            }
            onBtnClicked: { center_clicked = false; mode_area.modeArea_RightBtn1(); } //hsryu_0423_block_play_btcall
            bFocused: ( mode_area.focus_index == modeAreaModel.count + AHAMODEAREA.RIGHT_BTN_1 ) && focus_visible && !bPressed
            visible: (rb1_visible || rb2_visible)? true:false
            bFocusAble: true
            bDisabled: !rb1_visible || isListDisabled    //wsuk.kim 140103 ITS_217672 during BT call, modeAreaButton disable.
        }
//wsuk.kim title_bar
        /** Right button */
        DHAVN_AhaModeArea_Button
        {
            id: r_btn  //added by aettie.ji 2011.11.11 for New UX
            width: (caption.length > 8)? (AHAMODEAREA.const_AHA_MODE_WIDGET_CONTENTS_WIDTH+(caption.length-8)*10) : AHAMODEAREA.const_AHA_MODE_WIDGET_CONTENTS_WIDTH //hsryu_0618_trackmode_btn
            bg_img_n: AHAMODEAREA.const_WIDGET_RB_IMG_NORMAL
            bg_img_p: AHAMODEAREA.const_WIDGET_RB_IMG_PRESSED
            bg_img_f: AHAMODEAREA.const_WIDGET_RB_FOCUS_IMG
            icon_n: modeAreaModel.rb_icon_n || ""
            icon_p: modeAreaModel.rb_icon_p || ""
            caption: qsTranslate( LocTrigger.empty + AHAMODEAREA.const_WIDGET_LANGCONTEXT, ( modeAreaModel.rb_text || "") )
            onBtnClicked: { mode_area.modeArea_RightBtn() }
            bFocused: ( mode_area.focus_index == modeAreaModel.count + AHAMODEAREA.RIGHT_BTN ) && focus_visible && !bPressed
            visible: rb_visible
            bFocusAble: true
            bDisabled: isListDisabled	//wsuk.kim 140103 ITS_217672 during BT call, modeAreaButton disable.
        }

        /** menu text */
        Text
        {
            font.pointSize: AHAMODEAREA.const_WIDGET_COUNTER_TEXT_PIXEL_SIZE   //modified by aettie.ji 2012.12.12 for uxlaunch
            anchors.verticalCenter: parent.verticalCenter
            color: AHAMODEAREA.const_WIDGET_RB_COLOR
            font.family: AHAMODEAREA.const_WIDGET_COUNTER_TEXT_FONT_FAMILY_NEW
            text: mode_area_right_menu_text
            style: Text.Sunken
            clip: true
            visible: true   //0219  right_text_visible
        }

        /** Menu button */
        DHAVN_AhaModeArea_Button
        {
            id: m_btn   //added by aettie.ji 2011.11.11 for New UX
            bg_img_n: AHAMODEAREA.const_WIDGET_MB_IMG_NORMAL
            bg_img_p: AHAMODEAREA.const_WIDGET_MB_IMG_PRESSED
            bg_img_f: AHAMODEAREA.const_WIDGET_MB_FOCUS_IMG
            icon_n: modeAreaModel.rb_icon_n || ""
            icon_p: modeAreaModel.rb_icon_p || ""
            caption: qsTranslate( LocTrigger.empty + AHAMODEAREA.const_WIDGET_LANGCONTEXT, ( modeAreaModel.mb_text || "") )
            onBtnClicked: { mode_area.modeArea_MenuBtn() }
            bFocused: ( mode_area.focus_index == modeAreaModel.count + AHAMODEAREA.MENU_BTN ) && focus_visible && !bPressed
            visible: mb_visible
            bFocusAble: true
            bDisabled: isListDisabled && !isNoNetwork	//wsuk.kim 140103 ITS_217672 during BT call, modeAreaButton disable. // modified ITS 225504
        }
        // } added by minho
        /** Back button */
        DHAVN_AhaModeArea_Button
        {
            id: b_btn   //added by aettie.ji 2011.11.11 for New UX
            bg_img_n: AHAMODEAREA.const_WIDGET_BB_IMG_NORMAL
            bg_img_p: AHAMODEAREA.const_WIDGET_BB_IMG_PRESSED
            bg_img_f: AHAMODEAREA.const_WIDGET_BB_IMG_FOCUS // added by minho 20120829 for display focus on back button
            onBtnClicked: { mode_area.modeArea_BackBtn() }
            bFocused: ( mode_area.focus_index == modeAreaModel.count + AHAMODEAREA.BACK_BTN ) && focus_visible && !bPressed // added by minho 20120821 for NEW UX: Added menu button on ModeArea
            visible: bb_visible
            bFocusAble: true
        }
    }

    Component
    {
        id: btnDelegate

        Image
        {
            width: AHAMODEAREA.const_WIDGET_WIDTH
            height: AHAMODEAREA.const_WIDGET_HEIGHT
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            visible: isVisible
            Text
            {
                height: AHAMODEAREA.const_WIDGET_HEIGHT
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: AHAMODEAREA.const_WIDGET_TITLE_TEXT_LEFTMARGIN
                text: ( name.substring( 0, 4 ) == "STR_" ) ?
                    qsTranslate( LocTrigger.empty + AHAMODEAREA.const_WIDGET_LANGCONTEXT, ( name || "" ) ) : name
                font.pointSize: AHAMODEAREA.const_WIDGET_TITLE_TEXT_SIZE
                font.family: AHAMODEAREA.const_WIDGET_TAB_TEXT_FONT_FAMILY_NEW
                color: AHAMODEAREA.const_WIDGET_TITLE_COLOR
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

        anchors.leftMargin: AHAMODEAREA.const_WIDGET_LEFTMARGIN
        anchors.bottomMargin: AHAMODEAREA.const_WIDGET_TAB_BUTTON_BOTTOM_MARGIN
        anchors.verticalCenter: parent.verticalCenter //hsryu_0516_change_modearea_button
        spacing: AHAMODEAREA.const_WIDGET_SPACING
        Repeater { model: modeAreaModel; delegate: btnDelegate }
    }

    onCurrentSelectedIndexChanged:
    {
        if ( ( mode_area.currentSelectedIndex < modeAreaModel.count ) &&
             ( mode_area.currentSelectedIndex >= 0 ) )
        {
            mode_area.modeArea_Tab( modeAreaModel.get( mode_area.currentSelectedIndex ).tab_id )
        }
    }

    onRb2_visibleChanged:  // ITS 229480_229482
    {
        if( !rb2_visible && r_btn2.bFocused && rb1_visible)
            focus_index++;
    }

    function focusedItemClick()
    {
        focusedClick()
    }
}
