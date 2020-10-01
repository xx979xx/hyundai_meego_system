//import Qt 4.7
import QtQuick 1.1

import AppEngineQMLConstants 1.0
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES

Image
{
    id: img_btn

    z:0
    /** --- Input parameters --- */
    property string bg_img_n: ""
    property string bg_img_p: ""
    property string bg_img_s: ""
    property string bg_img_f: ""
    property string icon_n: ""
    property string icon_p: ""
    property string icon_s: ""

    property bool highlighted: false
    property bool bFocused: false
    property bool bPressed: false

    property string caption: ""
    property string _fontFamily
    property variant btnId
    property int count

    property int langID: UIListener.GetLanguageFromQML()

    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal btnPressed( variant btnId )
    signal btnReleased( variant btnId )
    signal btnPressAndHold( variant btnId )
    signal btnDoubleClicked( variant btnId )
    signal focusHide(variant btnId)
    signal stopPopupTimer(variant btnId)
    signal restartPopupTimer(variant btnId)

    property bool bClicked: false

     function doJogNavigation( arrow, status )
    {
         if(status === UIListenerEnum.KEY_STATUS_PRESSED &&
                 arrow === UIListenerEnum.JOG_CENTER){
             bPressed = true;
             stopPopupTimer(img_btn.btnId);
         }
         else if ( status === UIListenerEnum.KEY_STATUS_RELEASED &&
             arrow === UIListenerEnum.JOG_CENTER &&
             bPressed)
        {
             bPressed = false;
            img_btn.btnClicked( img_btn.btnId )
             restartPopupTimer(img_btn.btnId)
//            UIListener.ManualBeep()
        }
        else if( status == UIListenerEnum.KEY_STATUS_CANCELED )
        {
            console.log("[SystemPopUp] KEY_STATUS_CANCELED")
            bPressed = false;
        }
    }

    Connections
    {
        target: bFocused ? UIListener : null
//        onSignalJogCenterPressed: {bPressed = true }
//        onSignalJogCenterCanceled:{ bPressed = false }
//        onSignalJogCenterReleased: {
//            if(bPressed == false)
//                return;
//            else{
//                bPressed = false;
//                bClicked = true ;
//            }
//        }
//        onSignalJogCenterClicked: {bClicked = true }
        onSignalJogNavigation: { doJogNavigation( arrow, status ); }
       // onSignalJogCenterLongPressed: { img_btn.btnPressAndHold( img_btn.btnId ) }
        onSignalJogCenterCriticalPressed: {img_btn.btnDoubleClicked( img_btn.btnId ) }
	
//        onSignalPopupJogCenterPressed: {bPressed = true }
//        onSignalPopupJogCenterReleased: {bPressed = false; bClicked = true }
//        onSignalPopupJogCenterClicked: {bClicked = true }
        onSignalPopupJogNavigation: { doJogNavigation( arrow, status ); }
      //  onSignalPopupJogCenterLongPressed: { img_btn.btnPressAndHold( img_btn.btnId ) }
        onSignalPopupJogCenterCriticalPressed: { img_btn.btnDoubleClicked( img_btn.btnId ) }

        onSignalLanguageChanged:{
            langID = lang;
        }
    }

    /** --- Object property --- */
    width: img_btn.sourceSize.width
    height: img_btn.sourceSize.height
    /** Focus image for button */
//    Image
//    {
//        id: img_focus

//        visible: bFocused
//        source: bg_img_f || RES.const_POPUP_LIST_ITEM_FOCUSED_IMG
//        anchors{ centerIn: img_btn; fill: img_btn }
////        onVisibleChanged: {
////            if(img_focus.visible == true)
////                img_btn.source=""
////        }
//    }


    Image{
        id: id_light
        source: RES.const_POPUP_BUTTON_ICON_F
        z:2
        visible:bFocused
        anchors.left: parent.left
        anchors.leftMargin: getFocusIconMargin()
        anchors.verticalCenter: parent.verticalCenter
    }

    /** Text on button */
    Text
    {
        id : id_caption
        color: Qt.rgba(250/255, 250/255, 250/255, 1)
        font.pixelSize:{
            if(count == 4) {
                if(id_caption.lineCount == 1) {
                    return const_BUTTON_TEXT_PT //36
                } else {
                    return 28
                }
            } else {
                if (id_caption.lineCount == 1)
                  return CONST.const_BUTTON_TEXT_PT //36
                else if (id_caption.lineCount > 1)
                  return 32
            }
        }

        y: {
            (img_btn.sourceSize.height / 2) - (font.pixelSize / 2)
        }

        font.family: _fontFamily
        width:210
        maximumLineCount: {
            if(count == 3) { //Button 3개일 경우만 3Line
                3
            } else {
                2
            }
        }

       lineHeight : {
           if(id_caption.lineCount > 1) {
               0.625
           } else {
               1
           }
       }
       height:font.pixelSize

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        anchors.left: parent.left
        anchors.leftMargin: langID != 20  ?  52 : 51 - 25
        //clip: true
        style:Text.Sunken
        text: caption.substring(0, 4) == "STR_" ?
                    qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, caption ) :
                    caption
        wrapMode: Text.Wrap
    }
//    Rectangle{
//        anchors.fill: id_caption
//        color: "RED"
//        opacity:0.5
//        visible: id_caption.lineCount>1
//    }

    /** Icon on button */
    Image
    {
        id: icon_btn
        source: img_btn.icon_n
        anchors{ centerIn: parent; /*horizontalCenterOffset: -3*/ }
    }



    MouseArea
    {
        id: mouseArea

        anchors.fill: parent
        beepEnabled: false

        onClicked: { img_btn.btnClicked( img_btn.btnId ) }
        onDoubleClicked: { img_btn.btnDoubleClicked( img_btn.btnId ) }
        //  onPressAndHold: {/* img_btn.btnPressAndHold( img_btn.btnId )*/img_btn.btnClicked( img_btn.btnId ) }
        onPressed: { bPressed = true;stopPopupTimer(img_btn.btnId);img_btn.focusHide(img_btn.btnId); }
        onReleased: {
            UIListener.ManualBeep();
            if(bPressed == false)
                return;
            else{
                bPressed = false;
                bClicked = false ;
                restartPopupTimer(img_btn.btnId)
            }
        }
        onExited:{
            bPressed = false;
            restartPopupTimer(img_btn.btnId)
        }
    }

    states: [
        State
        {
            name: "pressed"; when: ( bPressed || (bPressed&&bFocused) )
            PropertyChanges { target: img_btn; source: img_btn.bg_img_p }
            PropertyChanges { target: icon_btn; source: img_btn.icon_p }
            //PropertyChanges { target: img_focus; visible: false }
        },
        State
        {
            name: "normal"; when: (!bPressed&& !bFocused)
            PropertyChanges { target: img_btn; source: img_btn.bg_img_n }
            PropertyChanges { target: icon_btn; source: img_btn.icon_n }
//            PropertyChanges { target: id_light; visible: false }
        },
        State
        {
            name: "focused"; when: (!bPressed &&bFocused)
            PropertyChanges { target: img_btn; source: img_btn.bg_img_f }
            PropertyChanges { target: icon_btn; source: img_btn.icon_f }
//            PropertyChanges { target: id_light; visible: false }
        }
        /*,
        State
        {
            name: "highlight"; when: ( highlighted && ( bPressed == false ) )
            PropertyChanges { target: img_btn; source: img_btn.bg_img_s }
            PropertyChanges { target: icon_btn; source: img_btn.icon_s || img_btn.icon_n }
//            PropertyChanges { target: id_light; visible: true }
        }*/
    ]

    onBPressedChanged:
    {
        if ( bPressed ) img_btn.btnPressed( img_btn.btnId )
        else img_btn.btnReleased( img_btn.btnId )
    }

    function getFocusIconMargin(){
        switch(bg_img_n){
        case RES.const_POPUP_A_01_BUTTON_N:
             return CONST.const_BUTTON_A_1_FOCUS_ICON_LEFT_MARGIN;
        case RES.const_POPUP_A_01_BUTTON_N_REVERSE:
             return CONST.const_BUTTON_A_1_FOCUS_ICON_LEFT_MARGIN_REVERSE;
        case RES.const_POPUP_B_01_BUTTON_N:
            return CONST.const_BUTTON_B_1_FOCUS_ICON_LEFT_MARGIN;

        case RES.const_POPUP_A_02_01_BUTTON_N:
        case RES.const_POPUP_A_02_02_BUTTON_N:
            return CONST.const_BUTTON_A_2_FOCUS_ICON_LEFT_MARGIN;
        case RES.const_POPUP_A_02_01_BUTTON_N_REVERSE:
        case RES.const_POPUP_A_02_02_BUTTON_N_REVERSE:
            return CONST.const_BUTTON_A_2_FOCUS_ICON_LEFT_MARGIN_REVERSE
        case RES.const_POPUP_B_02_01_BUTTON_N:
        case RES.const_POPUP_B_02_02_BUTTON_N:
            return CONST.const_BUTTON_B_2_FOCUS_ICON_LEFT_MARGIN
        case RES.const_POPUP_B_02_01_BUTTON_N_REVERSE:
        case RES.const_POPUP_B_02_02_BUTTON_N_REVERSE:
            return CONST.const_BUTTON_B_2_FOCUS_ICON_LEFT_MARGIN_REVERSE

        case RES.const_POPUP_B_03_01_BUTTON_N:
        case RES.const_POPUP_B_03_03_BUTTON_N:
            return CONST.const_BUTTON_3_FOCUS_ICON_LEFT_MARGIN;
        case RES.const_POPUP_B_03_01_BUTTON_N_REVERSE:
        case RES.const_POPUP_B_03_03_BUTTON_N_REVERSE:
            return CONST.const_BUTTON_3_FOCUS_ICON_LEFT_MARGIN_REVERSE;
        case RES.const_POPUP_B_03_02_BUTTON_N:
            return CONST.const_BUTTON_3_FOCUS_ICON_LEFT_MARGIN + 12
        case RES.const_POPUP_B_03_02_BUTTON_N_REVERSE:
            return CONST.const_BUTTON_3_FOCUS_ICON_LEFT_MARGIN_REVERSE - 12;

        case RES.const_POPUP_B_04_01_BUTTON_N:
        case RES.const_POPUP_B_04_04_BUTTON_N:
            return CONST.const_BUTTON_4_FOCUS_ICON_LEFT_MARGIN
        case RES.const_POPUP_B_04_02_BUTTON_N:
        case RES.const_POPUP_B_04_03_BUTTON_N:
            return CONST.const_BUTTON_4_FOCUS_ICON_LEFT_MARGIN + 13

        case RES.const_POPUP_B_04_01_BUTTON_N_REVERSE:
        case RES.const_POPUP_B_04_04_BUTTON_N_REVERSE:
            return CONST.const_BUTTON_4_FOCUS_ICON_LEFT_MARGIN_REVERSE
        case RES.const_POPUP_B_04_02_BUTTON_N_REVERSE:
        case RES.const_POPUP_B_04_03_BUTTON_N_REVERSE:
            return CONST.const_BUTTON_4_FOCUS_ICON_LEFT_MARGIN_REVERSE - 13
        }
    }

}
