import Qt 4.7
import QtQuick 1.1
import "DHAVN_AppPandoraConst.js" as PR

/** Button background image */
Image
{
    id: btn

    property string bg_img_n
    property string bg_img_p
    property string bg_img_s
    property string bg_img_f
    property string bg_img_d

    property bool bSelected: false
    property bool bFocused: false
    property bool bPressed: false
    property bool bDisabled: false
    property bool bFocusAble: false
    property string caption
    property bool btn_pressed: false
    property variant btnId
    property string textColor: ""
    property string searchButton : ""



    signal btnClicked( variant btnId )

    source: bg_img_n
    width: sourceSize.width

    /* Image on button */
    Image {
        id: name
        visible: (searchButton.length > 0)
        source: searchButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
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
            }           
        }
    }
    /** Focus image for button */
    Loader
    {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: bFocused && searchButton.length != 0 ? focus_search : null
        Component
        {
            id: focus_search
            Image
            {
                id: bt_image
                source: searchButton
            }
        }
    }

    MouseArea
    {
        id: mouseArea
        beepEnabled: false
        anchors.fill: parent
        enabled: !bDisabled
        onClicked: 
        {
            UIListener.ManualBeep();
            if ( bDisabled == false ) 
                btn.btnClicked( btn.btnId ) 
        }
    }

    states: [
        State
        {
            name: "disable"; when: bDisabled
            PropertyChanges { target: btn; source: bSelected ? "" : bg_img_n; /*icon_cur: icon_n*/ }
        },
        State
        {
            name: "pressed"; when: bPressed || mouseArea.pressed ||(button_pressed && bFocused) // for pressed image
            PropertyChanges { target: btn; source: bg_img_p; /*icon_cur: icon_p*/ }
        },
        State
        {
            name: "selected"; when: ( !bDisabled && bSelected && ( !bPressed || !mouseArea.pressed || !button_pressed) ) // for pressed image
            PropertyChanges { target: btn; source: bg_img_s; /*icon_cur: icon_n*/ }
        },
        State
        {
            name: "normal"; when: ( !bDisabled && !bSelected && ( !bPressed || !mouseArea.pressed || !button_pressed) ) //for pressed image
            PropertyChanges { target: btn; source: bg_img_n; /*icon_cur: icon_n*/ }
        }
    ]
}
