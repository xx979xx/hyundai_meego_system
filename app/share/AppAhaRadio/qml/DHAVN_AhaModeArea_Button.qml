import Qt 4.7
import QtQuick 1.1
import "DHAVN_AhaModeArea.js" as AHAMODEAREA    //wsuk.kim title_bar

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
    property bool bExited: false  //added by jaehwan 2014.01.28 for fixing abnormal button click
    property bool bDisabled: false
    property bool bFocusAble: false //{ added by yongkyun.lee 20130221 for : NO CR  , modearea focus
    property bool bCancel: false    //wsuk.kim 131112 ITS_207932 modeArea SK pressed, menu HK make cancel.
    property string caption
    property bool btn_pressed: false
    property variant btnId

    signal btnClicked( variant btnId )

    source: bg_img_n
    width: sourceSize.width

    /** Text on button */
    Text
    {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 11

        color: bDisabled ? AHAMODEAREA.const_WIDGET_RB_COLOR_DISABLED : AHAMODEAREA.const_WIDGET_RB_COLOR
        font.pointSize: AHAMODEAREA.const_WIDGET_RB_FONT_SIZE //modified by aettie.ji 2012.12.12 for uxlaunch
        text: ( caption.substring(0, 8) != "file:///" ) ? caption : ""
        font.family: AHAMODEAREA.const_WIDGET_BUTTON_TEXT_FONT_FAMILY  //added by aettie.ji 2012.11.22 for New UX
    }

    /** Image on button */
    Image
    {
        anchors.centerIn: parent

        source: ( caption.substring(0, 8) == "file:///" ) ? caption : ""
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
        sourceComponent: bFocused ? focus_img_cmp : null
        Component
        {
            id: focus_img_cmp
            Image
            {
                id: img_focus
                source: button_pressed? bg_img_p : bg_img_f
                width: (r_btn.bFocused) ? r_btn.width:sourceSize.width;
            }
        }
    }

        /** Focus image for button */
        Loader
        {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 11

            sourceComponent: bFocused && btn.caption != "" ? focus_txt_cmp : null
            Component
            {
                id: focus_txt_cmp
                Text
                {
                    id: txt_focus
                    text: caption

                    color: bDisabled ? AHAMODEAREA.const_WIDGET_RB_COLOR_DISABLED : AHAMODEAREA.const_WIDGET_RB_COLOR
                    font.pointSize: AHAMODEAREA.const_WIDGET_RB_FONT_SIZE //modified by aettie.ji 2012.12.12 for uxlaunch
                    font.family: AHAMODEAREA.const_WIDGET_BUTTON_TEXT_FONT_FAMILY  //added by aettie.ji 2012.11.22 for New UX
                }
            }
        }

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        enabled: !bDisabled && !bCancel //wsuk.kim 131112 ITS_207932 modeArea SK pressed, menu HK make cancel.
        onPressed: {
            if(bDisabled == false) bPressed = true
            bExited = false  //added by jaehwan 2014.01.28 for fixing abnormal button click
        }
        onClicked: { if ( bDisabled == false && !bExited ) btn.btnClicked( btn.btnId ) }  //modified by jaehwan 2014.01.28 for fixing abnormal button click
       //added by edo.lee 2013.06.23
         onReleased: { if ( bDisabled == false ) bPressed = false/*btn.btnClicked( btn.btnId )*/ }
         onCanceled: {
             if ( bDisabled == false ) bPressed = false;
             if ( bCancel ) bCancel = false;    //wsuk.kim 131112 ITS_207932 modeArea SK pressed, menu HK make cancel.
         }
         onExited:{
             if ( bDisabled == false ) bPressed = false
             bExited = true  //added by jaehwan 2014.01.28 for fixing abnormal button click
         }
    }

    states: [
        State
        {
            name: "disable"; when: bDisabled
            PropertyChanges { target: btn; source: bSelected ? "" : bg_img_n; icon_cur: icon_n } //modified by edo.lee 2013.03.12
        },
        State   //wsuk.kim 131112 ITS_207932 modeArea SK pressed, menu HK make cancel.
        {
            name: "cancel"; when: bCancel
            PropertyChanges { target: btn; source: bg_img_n }
        },
        State
        {
            name: "pressed"; when: bPressed  ||(button_pressed && bFocused) //modified by aettie.ji 2013.04.30 for pressed image
            PropertyChanges { target: btn; source: bg_img_p; icon_cur: icon_p }
        },
        State
        {
            name: "selected"; when: ( !bDisabled && bSelected && ( !bPressed  || !button_pressed) ) //modified by aettie.ji 2013.04.30 for pressed image
            PropertyChanges { target: btn; source: bg_img_s; icon_cur: icon_n }
        },
        State
        {
            name: "normal"; when: ( !bDisabled && !bSelected && ( !bPressed  || !button_pressed) ) //modified by aettie.ji 2013.04.30 for pressed image
            PropertyChanges { target: btn; source: bg_img_n; icon_cur: icon_n }
        }
    ]
}
