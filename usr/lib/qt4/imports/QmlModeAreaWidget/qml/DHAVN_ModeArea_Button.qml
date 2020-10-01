import Qt 4.7
import QtQuick 1.1 // added by ravikanth 03-05-13
import "DHAVN_ModeArea.js" as MODEAREA

/** Button background image */
Image
{
    id: btn

    property string bg_img_n
    property string bg_img_p
    property string bg_img_s
    property string bg_img_f
    property string bg_img_d

    property string icon_n
    property string icon_p
    property string icon_s
    property string icon_cur

    property bool bSelected: false
    property bool bFocused: false
    property bool bPressed: false
    property bool bDisabled: false
    property bool bFocusAble: false //{ added by yongkyun.lee 20130221 for : NO CR  , modearea focus
    property string caption
    property bool btn_pressed: false
    property variant btnId
    property bool bMirror: false // added by ravikanth 03-05-13 for mirror layout
    property bool bAutoBeep: true // added by Sergey 19.11.2013 for beep issue

    signal btnPressed( variant btnId )
    signal btnClicked( variant btnId )

    source: bg_img_n
    width: sourceSize.width
    mirror: bMirror // added by ravikanth 03-05-13 for mirror layout

    /** Text on button */
    Text
    {
        //{modified by HWS 2013.04.11 for New UX  //{modified by hyejin.noh 20140701 for ITS 0241396 
        x:9 
        width:123; height:74
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        //anchors.centerIn: parent
        //anchors.horizontalCenter: parent.horizontalCenter
        //anchors.top: parent.top
        //anchors.topMargin: 11
        //}modified by HWS 2013.04.11 for New UX //}modified by hyejin.noh 20140701
        color: bDisabled ? MODEAREA.const_WIDGET_RB_COLOR_DISABLED : MODEAREA.const_WIDGET_RB_COLOR
        //font.pixelSize: MODEAREA.const_WIDGET_RB_FONT_SIZE
        font.pointSize: MODEAREA.const_WIDGET_RB_FONT_SIZE //modified by aettie.ji 2012.12.12 for uxlaunch        
        //style: Text.Sunken  // modified by HWS 2013.04.19 for New UX
        // modified by minho 20120821
        // { for NEW UX: Added active tab on media
        // modified by minho 20121205 for removed tab on modearea.
        text: ( caption.substring(0, 8) != "file:///" ) ? caption : ""
        // text: ( caption.substring(0, 8) != "file:///" && caption.substring(0, 18) != "/app/share/images/" ) ? caption : ""
        // modified by minho
        // } modified by minho
        //font.family: MODEAREA.const_WIDGET_BUTTON_TEXT_FONT_FAMILY  //added by aettie.ji 2012.11.22 for New UX
        font.family: MODEAREA.const_WIDGET_BUTTON_TEXT_FONT_FAMILY_NEW  //added by aettie.ji 2012.11.22 for New UX
    }

    /** Image on button */
    Image
    {
        anchors.centerIn: parent
        // modified by minho 20120821
        // { for NEW UX: Added active tab on media
        // modified by minho 20121205 for removed tab on modearea.
        source: ( caption.substring(0, 8) == "file:///" ) ? caption : ""
        // source: ( caption.substring(0, 18) == "/app/share/images/" ) ? caption : ""
        // modified by minho
        // } modified by minho
    }

    /** Icon on button */
    Loader
    {
        sourceComponent: btn.icon_cur ? icon_cmp : null
        Component
        {
            id: icon_cmp
            Image
            {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -3
                source: btn.icon_cur
            }
        }
    }

    /** Focus image for button */
    Loader
    {
        anchors.centerIn: parent
        sourceComponent: bFocused && !is_popup_shown ? focus_img_cmp : null // modified by cychoi 2014.01.09 for ITS 218953
        Component
        {
            id: focus_img_cmp
            Image
            {
                id: img_focus
                source: button_pressed? bg_img_p : bg_img_f //modified by aettie.ji 2013.04.30 for pressed image
                mirror: bMirror // added by ravikanth 03-05-13 for mirror layout
            }
        }
    }

    //{ added by yongkyun.lee 20130215 for :  ISV 73369
    /** Focus image for button */
    Loader
    {
        //{modified by HWS 2013.04.11 for New UX//HWS
        //anchors.centerIn: parent
        // { commented by cychoi 2014.07.14 for ITS 0241396 
        //anchors.horizontalCenter: parent.horizontalCenter
        //anchors.top: parent.top
        //anchors.topMargin: 11
        // } commented by cychoi 2014.07.14
        sourceComponent: bFocused && btn.caption != "" && !is_popup_shown ? focus_txt_cmp : null // modified by cychoi 2014.01.09 for ITS 218953
        Component
        {
            id: focus_txt_cmp
            Text
            {
                id: txt_focus
                text: caption
                // { added by cychoi 2014.07.14 for ITS 241396 
                x:9 
                width:123; height:74
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                // } added by cychoi 2014.07.14
                //anchors.centerIn: parent
                color: bDisabled ? MODEAREA.const_WIDGET_RB_COLOR_DISABLED : MODEAREA.const_WIDGET_RB_COLOR
                //font.pixelSize: MODEAREA.const_WIDGET_RB_FONT_SIZE
                font.pointSize: MODEAREA.const_WIDGET_RB_FONT_SIZE //modified by aettie.ji 2012.12.12 for uxlaunch
                //style: Text.Sunken
                //font.family: MODEAREA.const_WIDGET_BUTTON_TEXT_FONT_FAMILY  //added by aettie.ji 2012.11.22 for New UX
                font.family: MODEAREA.const_WIDGET_BUTTON_TEXT_FONT_FAMILY_NEW
            }
        }
        //}modified by HWS 2013.04.11 for New UX
    }
    //} added by yongkyun.lee 20130215 

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        enabled: !bDisabled
        beepEnabled: btn.bAutoBeep // added by Sergey 19.11.2013 for beep issue

        onPressed: { if(bDisabled == false) bPressed = true; btn.btnPressed( btn.btnId ) }

        // { modified by Sergey 2013.09.26 for ITS#191449
        onClicked:
        {
            if ( bDisabled == false )
            {
                bPressed = false;
                btn.btnClicked( btn.btnId )
            }
        }
		// } modified by Sergey 2013.09.26 for ITS#191449

        // { modified by Sergey 05.12.2013 for ITS#212579
         onReleased: { if ( bDisabled == false || bPressed ) bPressed = false/*btn.btnClicked( btn.btnId )*/ }
         onCanceled: { if ( bDisabled == false || bPressed )bPressed = false}
         onExited:{ if ( bDisabled == false || bPressed ) bPressed = false}
         // } modified by Sergey 05.12.2013 for ITS#212579
         noClickAfterExited: true
    }

    states: [
        State
        {
            name: "disable"; when: bDisabled
            PropertyChanges { target: btn; source: bSelected ? "" : bg_img_n; icon_cur: icon_n } //modified by edo.lee 2013.03.12
        },
        State
        {
            name: "pressed"; when: bPressed  ||(button_pressed && bFocused) //modified by aettie.ji 2013.04.30 for pressed image
            PropertyChanges { target: btn; source: bg_img_p; icon_cur: icon_p }
        },
        State
        {
            name: "selected"; when: ( (!bDisabled && bSelected && ( !bPressed  || !button_pressed)) && !is_popup_shown ) // modified by cychoi 2014.01.09 for ITS 218953 //modified by aettie.ji 2013.04.30 for pressed image
            PropertyChanges { target: btn; source: bg_img_s; icon_cur: icon_n }
        },
        State
        {
            name: "normal"; when: ( (!bDisabled && !bSelected && ( !bPressed  || !button_pressed)) || is_popup_shown ) // modified by cychoi 2014.01.09 for ITS 218953 //modified by aettie.ji 2013.04.30 for pressed image
            PropertyChanges { target: btn; source: bg_img_n; icon_cur: icon_n }
        }
    ]
}
