import Qt 4.7
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

    property string caption
    property bool btn_pressed: false
    property variant btnId

    signal btnClicked( variant btnId )

    source: bg_img_n
    width: sourceSize.width


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

    /** Text on button */
    Text
    {
        id: txtBtn
        anchors.centerIn: parent
        color: bDisabled ? MODEAREA.const_WIDGET_RB_COLOR_DISABLED : MODEAREA.const_WIDGET_RB_COLOR
        //font.pixelSize: MODEAREA.const_WIDGET_RB_FONT_SIZE
        font.pointSize: MODEAREA.const_WIDGET_RB_FONT_SIZE //modified by aettie.ji 2012.12.12 for uxlaunch
        style: Text.Sunken
        // modified by minho 20120821
        // { for NEW UX: Added active tab on media
        // modified by minho 20121205 for removed tab on modearea.
        text: ( caption.substring(0, 8) != "file:///" ) ? caption : ""
        // text: ( caption.substring(0, 8) != "file:///" && caption.substring(0, 18) != "/app/share/images/" ) ? caption : ""
        // modified by minho
        // } modified by minho
        font.family: MODEAREA.const_WIDGET_BUTTON_TEXT_FONT_FAMILY  //added by aettie.ji 2012.11.22 for New UX
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
                source: bg_img_f
            }
        }
    }

    /** Focus image for button */
    Loader
    {
        anchors.centerIn: parent
        sourceComponent: bFocused && btn.caption != "" ? focus_txt_cmp : null
        Component
        {
            id: focus_txt_cmp
            Text
            {
                id: txt_focus
                text: caption
                anchors.centerIn: parent
                color: bDisabled ? MODEAREA.const_WIDGET_RB_COLOR_DISABLED : MODEAREA.const_WIDGET_RB_COLOR
                //font.pixelSize: MODEAREA.const_WIDGET_RB_FONT_SIZE
                font.pointSize: MODEAREA.const_WIDGET_RB_FONT_SIZE //modified by aettie.ji 2012.12.12 for uxlaunch
                style: Text.Sunken
                font.family: MODEAREA.const_WIDGET_BUTTON_TEXT_FONT_FAMILY  //added by aettie.ji 2012.11.22 for New UX
            }
        }
    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        enabled: !bDisabled
        onClicked: { if ( bDisabled == false ) btn.btnClicked( btn.btnId ) }
    }

    states: [
        State
        {
            name: "disable"; when: bDisabled
            PropertyChanges { target: btn; source: bSelected ? "" : bg_img_d; icon_cur: icon_n } // modified by eugeny.novikov 2012.11.01 for CR 14047
        },
        State
        {
            name: "pressed"; when: bPressed || mouseArea.pressed
            PropertyChanges { target: btn; source: bg_img_p; icon_cur: icon_p }
        },
        State
        {
            name: "selected"; when: ( !bDisabled && bSelected && ( !bPressed || !mouseArea.pressed) )
            PropertyChanges { target: btn; source: bg_img_s; icon_cur: icon_n }
        },
        State
        {
            name: "normal"; when: ( !bDisabled && !bSelected && ( !bPressed || !mouseArea.pressed) )
            PropertyChanges { target: btn; source: bg_img_n; icon_cur: icon_n }
        }
    ]
}
