import Qt 4.7
import QtQuick 1.1
import AppEngineQMLConstants 1.0
import "DHAVN_MP_PopUp_Constants.js" as CONST
import "DHAVN_MP_PopUp_Resources.js" as RES

Image
{
    id: img_btn

    mirror: EngineListenerMain.middleEast

    /** --- Input parameters --- */
    property string bg_img_n: ""
    property string bg_img_p: ""
    property string bg_img_s: ""
    property string bg_img_f: ""
    property string icon_n: ""
    property string icon_p: ""
    property string icon_s: ""

    property bool bFocused: false
    property bool bPressed: false
    property bool is_dimmed: false // modified by ravikanth 07-07-13 for ITS 0178184

    property string caption: ""
    property variant btnId
    property string connectionTarget: "UIListener" // added by suilyou 20140430 for ITS 0236256
    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal btnPressed( variant btnId )
    signal btnReleased( variant btnId )
    signal btnPressAndHold( variant btnId )
    signal btnDoubleClicked( variant btnId )
    signal focusHide(variant btnId)

    onVisibleChanged: bPressed = false

// modified by Dmitry 15.05.13
    function doJogNavigation( arrow, status )
    {
        // "bReleased" to make sure key release happen on same ui control
        if ( status === UIListenerEnum.KEY_STATUS_RELEASED
                && arrow === UIListenerEnum.JOG_CENTER  && bPressed) // modified by ravikanth 18-05-13 // { modified by hyejin.noh 20140522 for ITS 0238204
        {
            img_btn.btnClicked( img_btn.btnId )
            img_btn.btnReleased( img_btn.btnId )
            bPressed = false // } modified by hyejin.noh 20140522
            //UIListener.ManualBeep(); // modified by ravikanth 07-09-13 for ISV 90694
        }
// added by Dmitry 22.08.13 for ITS0185046
        else if (status === UIListenerEnum.KEY_STATUS_CANCELED && arrow === UIListenerEnum.JOG_CENTER)
        {
           bPressed = false
        }
        // { added by hyejin.noh 20140522 for ITS 0238204
        else if( status === UIListenerEnum.KEY_STATUS_PRESSED && arrow === UIListenerEnum.JOG_CENTER )
        {            
            img_btn.btnPressed( img_btn.btnId )
            bPressed = true
        }
        // } added by hyejin.noh 20140522
    }

    Connections
    {
        target: bFocused ? (connectionTarget == "EngineListener" ? EngineListener : UIListener) : null // changed
        /** { deleted by hyejin.noh 20140522 for ITS 0238204
        onSignalJogCenterPressed:
        {
            btnPressed( img_btn.btnId )
            bPressed = true;
        }
        onSignalJogCenterReleased:
        {
           btnReleased( img_btn.btnId )
           bPressed = false
        }
        */// } deleted by hyejin.noh 20140522
        onSignalJogNavigation: { doJogNavigation( arrow, status ); } // added bReleased by ravikanth 18-05-13
        onSignalJogCenterLongPressed: { img_btn.btnPressAndHold( img_btn.btnId ) }
        onSignalJogCenterCriticalPressed: { img_btn.btnDoubleClicked( img_btn.btnId ) }
	
//        onSignalPopupJogCenterPressed: { bPressed = true; }
//        onSignalPopupJogCenterReleased: { bPressed = false; bReleased = true; } // added bReleased by ravikanth 18-05-13
//        onSignalPopupJogNavigation: { doJogNavigation( arrow, status ); bReleased = false; } // added bReleased by ravikanth 18-05-13
//        onSignalPopupJogCenterLongPressed: { img_btn.btnPressAndHold( img_btn.btnId ) }
//        onSignalPopupJogCenterCriticalPressed: { img_btn.btnDoubleClicked( img_btn.btnId ) }
    }

    /** --- Object property --- */
    width: img_btn.sourceSize.width
    height: img_btn.sourceSize.height
    /** Focus image for button */

    Image{
        id: id_light
        source: RES.const_POPUP_BUTTON_ICON_F

        mirror: EngineListenerMain.middleEast
        visible: bFocused
        anchors.left: parent.left
        //anchors.leftMargin: getFocusIconMargin()
        anchors.verticalCenter: parent.verticalCenter
    }

    /** Text on button */
    Text
    {
        color: is_dimmed ? CONST.const_RADIO_CONTENT_TEXT_COLOR : Qt.rgba(250/255, 250/255, 250/255, 1) // modified by ravikanth 07-07-13 for ITS 0178184
        font.pixelSize: CONST.const_BUTTON_TEXT_PT
        //font.family: CONST.const_TEXT_FONT_FAMILY
	//modified by aettie 20130905 for pop btn alignment
        anchors.horizontalCenter : parent.horizontalCenter
        anchors.horizontalCenterOffset : 15
        font.family: CONST.const_TEXT_FONT_FAMILY_NEW
        width: img_btn.sourceSize.width - id_light.sourceSize.width
        height:parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        //anchors.centerIn: parent
        text: caption.substring(0, 4) == "STR_" ?
                    qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, caption ) :
                    caption
        style: Text.Sunken
//        width: 210
    }

    /** Icon on button */
    Image
    {
        id: icon_btn
        mirror: EngineListenerMain.middleEast
        source: img_btn.icon_n
        anchors{ centerIn: parent; /*horizontalCenterOffset: -3*/ }
    }

    MouseArea
    {
        id: mouseArea

        anchors.fill: parent
        enabled: !is_dimmed // modified by ravikanth 07-07-13 for ITS 0178184
        beepEnabled: false //added by junam 2013.12.18 for ITS_ME_216243
        // modified by Dmitry 22.08.13 for ITS0185767
        //onClicked: { img_btn.btnClicked( img_btn.btnId ) }
        onDoubleClicked: { img_btn.btnDoubleClicked( img_btn.btnId ) }
        onPressAndHold: { img_btn.btnPressAndHold( img_btn.btnId ) }
        onPressed: { bPressed = true;img_btn.focusHide(img_btn.btnId) }
        onReleased:
        {
            if (bPressed)
            {
                EngineListenerMain.ManualBeep(); //added by junam 2013.12.18 for ITS_ME_216243
                img_btn.btnClicked( img_btn.btnId )
            }
           bPressed = false;
        }
        onExited: { bPressed = false; }

    }
// modified by Dmitry 15.05.13
    states: [
        State
        {
            name: "pressed"; when: ( bPressed )
            PropertyChanges { target: img_btn; source: img_btn.bg_img_p }
            PropertyChanges { target: icon_btn; source: img_btn.icon_p }
        },
        State
        {
            name: "normal"; when: ( !bPressed && !bFocused )
            PropertyChanges { target: img_btn; source: img_btn.bg_img_n }
            PropertyChanges { target: icon_btn; source: img_btn.icon_n }
        },
        State
        {
            name: "focused"; when: ( bFocused )
            PropertyChanges { target: img_btn; source: bg_img_f || RES.const_POPUP_LIST_ITEM_FOCUSED_IMG }
            PropertyChanges { target: icon_btn; source: img_btn.icon_s || img_btn.icon_n }
        }
    ]

    function getFocusIconMargin(){
        switch(bg_img_n){
        case RES.const_POPUP_A_01_BUTTON_N:
             return CONST.const_BUTTON_A_1_FOCUS_ICON_LEFT_MARGIN
        case RES.const_POPUP_B_01_BUTTON_N:
            return CONST.const_BUTTON_B_1_FOCUS_ICON_LEFT_MARGIN;

        case RES.const_POPUP_A_02_01_BUTTON_N:
        case RES.const_POPUP_A_02_02_BUTTON_N:
            return CONST.const_BUTTON_A_2_FOCUS_ICON_LEFT_MARGIN
        case RES.const_POPUP_B_02_01_BUTTON_N:
        case RES.const_POPUP_B_02_02_BUTTON_N:
            return CONST.const_BUTTON_B_2_FOCUS_ICON_LEFT_MARGIN

        case RES.const_POPUP_B_03_01_BUTTON_N:
        case RES.const_POPUP_B_03_03_BUTTON_N:
            return CONST.const_BUTTON_3_FOCUS_ICON_LEFT_MARGIN
        case RES.const_POPUP_B_03_02_BUTTON_N:
            return CONST.const_BUTTON_3_FOCUS_ICON_LEFT_MARGIN + 12

        case RES.const_POPUP_B_04_01_BUTTON_N:
        case RES.const_POPUP_B_04_04_BUTTON_N:
            return CONST.const_BUTTON_4_FOCUS_ICON_LEFT_MARGIN
        case RES.const_POPUP_B_04_02_BUTTON_N:
        case RES.const_POPUP_B_04_03_BUTTON_N:
            return CONST.const_BUTTON_4_FOCUS_ICON_LEFT_MARGIN + 13

            default: CONST.const_BUTTON_A_1_FOCUS_ICON_LEFT_MARGIN
        }
    }
}
