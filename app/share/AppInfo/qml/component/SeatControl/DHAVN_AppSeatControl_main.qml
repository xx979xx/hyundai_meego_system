import Qt 4.7
import QtQuick 1.0
import Qt.labs.gestures 2.0

//import QmlStatusBarWidget 1.0
//import QmlModeAreaWidget 1.0
import QmlBottomAreaWidget 1.0
import AppEngineQMLConstants 1.0
import QmlSimpleItems 1.0
import QmlStatusBar 1.0

import "../../component/QML/DH" as MComp
import "../../component/system/DH" as MSystem
import "../../component/Info/JavaScript/InfoOperation.js" as MInfoOperation



//FocusScope {
MComp.MComponent{
    id : idSeatMain
    x: 0; y:0//-93
    width : 1280; height : 720
    focus : true
    signal backFromListSignal()
    Keys.onPressed:{
        switch( event.key )
        {
            case Qt.Key_Left :
            case Qt.Key_Right :
            case Qt.Key_Up :
            case Qt.Key_Down :
            case Qt.Key_Minus:
            case Qt.Key_Equal:
            {
                console.log("seatcontrol keys pressed")
                event.accepted=true;
            }break;
            case Qt.Key_Backspace:
            {
                uiListener.handleBackKey();
                event.accepted=true;
                break;
            }

        }
    }//onPressed
    Keys.onReleased:{
        switch( event.key )
        {
            case Qt.Key_Left :
            case Qt.Key_Right :
            case Qt.Key_Up :
            case Qt.Key_Down :
            case Qt.Key_Minus:
            case Qt.Key_Equal:
            {
                console.log("seatcontrol keys onReleased")
                event.accepted=true;
            }break;


        }
    }//onReleased
    property int countryVariant: uiListener.getVariant();
    // Def. of Text Color
    property color colorWhite:          Qt.rgba(255,255,255,1)
    property color colorBlack:          Qt.rgba(0,0,0,1)
    property color colorBrightGrey:     Qt.rgba(250/255,250/255,250/255,1)
    property color colorSubTextGrey:    Qt.rgba(212/255,212/255,212/255,1)
    property color colorGrey:           Qt.rgba(193/255,193/255,193/255,1)
    property color colorDimmedGrey:     Qt.rgba(158/255,158/255,158/255,1)
    property color colorDisableGrey:    Qt.rgba(91/255,91/255,91/255,1)
    property color colorFocusGrey:      Qt.rgba(72/255,72/255,72/255,1)
    property color colorButtonGrey:     Qt.rgba(47/255,47/255,47/255,1)
    property color colorProgressBlue:   Qt.rgba(0/255,135/255,239/255,1)
    property color colorDimmedBlue:     Qt.rgba(68/255,124/255,173/255,1)
    property color colorIndicatorOn:    Qt.rgba(124/255,189/255,255/255,1)
    property string transparent:        "transparent"

    property string txtBtnLumbar     : qsTr("STR_SEATCONTROL_BTN_LUMBAR")
    property string txtBtnBolster       : qsTr("STR_SEATCONTROL_BTN_BOLSTER")
    property string txtBtnCushion       : qsTr("STR_SEATCONTROL_BTN_CUSHION")
    property string txtDescLumbar       : qsTr("STR_SEATCONTROL_DESC_LUMBAR")
    property string txtDescLumbarUp       : qsTr("STR_SEATCONTROL_DESC_LUMBAR_UP")
    property string txtDescLumbarDown       : qsTr("STR_SEATCONTROL_DESC_LUMBAR_DOWN")
    property string txtDescLumbarLeft       : qsTr("STR_SEATCONTROL_DESC_LUMBAR_LEFT")
    property string txtDescLumbarRight       : qsTr("STR_SEATCONTROL_DESC_LUMBAR_RIGHT")
    property string txtDescBolster      : qsTr("STR_SEATCONTROL_DESC_BOLSTER")
    property string txtDescBolsterLeft      : qsTr("STR_SEATCONTROL_DESC_BOLSTER_LEFT")
    property string txtDescBolsterRight      : qsTr("STR_SEATCONTROL_DESC_BOLSTER_RIGHT")
    property string txtDescCushion      : qsTr("STR_SEATCONTROL_DESC_CUSHION")
    property string txtDescCushionLeft      : qsTr("STR_SEATCONTROL_DESC_CUSHION_LEFT")
    property string txtDescCushionRight      : qsTr("STR_SEATCONTROL_DESC_CUSHION_RIGHT")
    property string txtModeTitle        : qsTr("STR_SEATCONTROL_MODE_TITLE")
    property int langId: UIListener.GetLanguageFromQML();
    //property string fontFamily: (UIListener.GetLanguageFromQML() >= 3 && UIListener.GetLanguageFromQML() <=5) ? "CHINESS_HDB" : "NewHDB"
    property string fontFamily: "DH_HDB"
    Image {
        id : imgBg
        source:  countryVariant == 4 ? imgFolderSeatControl + "bg_seat_me.png" :  imgFolderSeatControl + "bg_seat.png"
        MouseArea{
            anchors.fill: parent
            beepEnabled: false
            onReleased: {
                console.log("seatcontrol : onReleased");
            }
            onPressed: {
                console.log("seatcontrol : onPressed");
            }
        }//MouseArea

        QmlStatusBar {
                             id: statusBar
                             x: 0; y: 0; width: 1280; height: 93
                             homeType: "button"
                             visible:true
                             middleEast: countryVariant == 4 ? true : false
                   }



    function retranslateUi(languageId)
    {
        console.log("UIListener::onRetranslateUi - retranslateUi")
        txtBtnLumbar     = qsTr("STR_SEATCONTROL_BTN_LUMBAR");
        txtBtnBolster   = qsTr("STR_SEATCONTROL_BTN_BOLSTER");
        txtBtnCushion   = qsTr("STR_SEATCONTROL_BTN_CUSHION");
        txtDescLumbar   = qsTr("STR_SEATCONTROL_DESC_LUMBAR");
        txtDescLumbarUp   = qsTr("STR_SEATCONTROL_DESC_LUMBAR_UP");
        txtDescLumbarDown   = qsTr("STR_SEATCONTROL_DESC_LUMBAR_DOWN");
        txtDescLumbarLeft   = qsTr("STR_SEATCONTROL_DESC_LUMBAR_LEFT");
        txtDescLumbarRight   = qsTr("STR_SEATCONTROL_DESC_LUMBAR_RIGHT");
        txtDescBolster  = qsTr("STR_SEATCONTROL_DESC_BOLSTER");
        txtDescBolsterLeft  = qsTr("STR_SEATCONTROL_DESC_BOLSTER_LEFT");
        txtDescBolsterRight  = qsTr("STR_SEATCONTROL_DESC_BOLSTER_RIGHT");
        txtDescCushion  = qsTr("STR_SEATCONTROL_DESC_CUSHION");
        txtDescCushionLeft  = qsTr("STR_SEATCONTROL_DESC_CUSHION_LEFT");
        txtDescCushionRight  = qsTr("STR_SEATCONTROL_DESC_CUSHION_RIGHT");
        txtModeTitle    = qsTr("STR_SEATCONTROL_MODE_TITLE");

    }

    Connections{
        target: uiListener
        onRetranslateUi: {
            console.log("UIListener::onRetranslateUi" + languageId)
            langID = UIListener.GetLanguageFromQML();
            //fontFamily = (langID >= 3 && langID <=5) ? "CHINESS_HDB" : "NewHDB"
            fontFamily = "DH_HDB"
            idSeatMain.retranslateUi(languageId);
            LocTrigger.retrigger();
        }
    }


///////////////////////////////////////
///// BackBtn remove...
//    QmlModeAreaWidget {
//        id: modeAreaWidget
//        modeAreaModel: modeArea

//        onModeArea_BackBtn:  {
//            UIListener.HandleBackKey();
//            UIListener.setAudioBeepPlay();
//        }
//    }
    
//    ListModel {
//    id: modeArea
//    property string text: txtModeTitle
//    }
///// BackBtn remove...
///////////////////////////////////////


    Item {
        id: titleMode
        Image {
            id: img_title
            x:0; y:93
            //width: idSeatMain.width
            source: imgFolderSeatControl + "bg_title.png"
            Text {
                //x: 38+18; y:93//+12
                anchors.left: parent.left
                anchors.leftMargin: countryVariant == 4  ? 464 : 46
                anchors.verticalCenter: parent.verticalCenter
                text:txtModeTitle
                font.pointSize: 40
                font.family: idSeatMain.fontFamily//UIListener.GetLanguageFromQML() >=3 && UIListener.GetLanguageFromQML() <= 5 ? "CHINESS_HDB" : "HDB"
                color: colorBrightGrey
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: countryVariant == 4  ? Text.AlignRight : Text.AlignLeft
                height:img_title.height
                width: 770
            }
        }
    }



    /*
      0x0 : Off / 0x1 : Lumber Support Control / 0x2 : Side Bolster Control / 0x3 : Cushion Extension Control / 0xF:Invalid /
      */
    Item {
        id: btnSeatMode
        anchors.fill: parent
        Image {
            id: img_btn_lumbar
            anchors.top: parent.top
            anchors.topMargin:232
            anchors.left: parent.left
            anchors.leftMargin: countryVariant == 4  ? 944 : 38

            source: (canDB.SeatCtrlMode == 0x01)?imgFolderSeatControl+"btn_seat_s.png":imgFolderSeatControl+"btn_seat_n.png"
            Text {
                id:id_lumbar_text
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: countryVariant == 4  ? 12 : 18
                wrapMode: Text.WordWrap;  textFormat: Text.RichText
                horizontalAlignment:  countryVariant == 4  ? Text.AlignRight : Text.AlignLeft
                text: txtBtnLumbar
                font.pointSize: 30
                font.family: fontFamily
                color: (canDB.SeatCtrlMode == 0x01)?colorBlack:colorBrightGrey
                width: 180
            }
            Image {
                id: ico_lumbar
                //x:  countryVariant == 4  ? 944+12+169+11 : 38+18+169+11; y: 232+9
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: id_lumbar_text.right
                anchors.leftMargin: -11//countryVariant == 4  ? 12 + 169 : 18 + 169
                source: imgFolderSeatControl+"ico_lumbar.png"
            }
        }

        Image {
            id: img_btn_bolster
            anchors.top: img_btn_lumbar.top
            anchors.topMargin: 145
            anchors.left: img_btn_lumbar.left
            source: (canDB.SeatCtrlMode == 0x02)?imgFolderSeatControl+"btn_seat_s.png":imgFolderSeatControl+"btn_seat_n.png"
            Text {
                id: id_bolster_text
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: countryVariant == 4  ? 12 : 18
                wrapMode: Text.WordWrap;  textFormat: Text.RichText
                horizontalAlignment:  countryVariant == 4  ? Text.AlignRight : Text.AlignLeft
                text: txtBtnBolster//"<div style=\"line-height:80%\">" + txtBtnBolster + "</div>"
                font.pointSize: 30
                font.family: fontFamily
                color: (canDB.SeatCtrlMode == 0x02)?colorBlack:colorBrightGrey
                width: 180
            }
            Image {
                id: ico_bolster
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: id_bolster_text.right
                anchors.leftMargin: -11//countryVariant == 4  ? 12 + 169 : 18 + 169
                source: imgFolderSeatControl+"ico_side_bolster.png"
            }
        }

        Image {
            id: img_btn_cushion
            anchors.top: img_btn_bolster.top
            anchors.topMargin: 145
            anchors.left: img_btn_bolster.left
            source: (canDB.SeatCtrlMode == 0x03)?imgFolderSeatControl+"btn_seat_s.png":imgFolderSeatControl+"btn_seat_n.png"
            Text {
                id: id_cushion_text
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: countryVariant == 4  ? 12 : 18
                wrapMode: Text.WordWrap;  textFormat: Text.RichText
                horizontalAlignment:  countryVariant == 4  ? Text.AlignRight : Text.AlignLeft
                text: txtBtnCushion//"<div style=\"line-height:80%\">" + txtBtnCushion + "</div>"
                font.pointSize: 30
                font.family: fontFamily
                color: (canDB.SeatCtrlMode == 0x03)?colorBlack:colorBrightGrey
                width: 180
            }
            Image {
                id: ico_cushion
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: id_cushion_text.right
                anchors.leftMargin: -11//countryVariant == 4  ? 12 + 169 : 18 + 169
                source: imgFolderSeatControl+"ico_cushion.png"
            }
        }

        Text {
            id: txt_des_lumbar
            //x:  countryVariant == 4 ? 501 : 402; y: 582;  //height: 42
            anchors.bottom: img_btn_cushion.bottom
            anchors.left: parent.left
            anchors.leftMargin: countryVariant == 4 ? 501 : 402
            wrapMode: Text.WordWrap; // textFormat: Text.RichText
            width: 377
            //text:txtDescLumbar
            // text: "<div style=\"line-height:80%\">" + txtDescLumbar + "</div>"
            text:
            {
                switch(canDB.SeatCtrlMode){
                    case 0x01:{
                        switch(canDB.MultiFuncSwitch){
                            case 0x01:
                                return txtDescLumbarUp
                            case 0x02:
                                return txtDescLumbarDown
                            case 0x03:
                                return txtDescLumbarLeft
                            case 0x04:
                                return txtDescLumbarRight
                            default:
                                return txtDescLumbar
                        }
                    }
                    case 0x02:{
                        switch(canDB.MultiFuncSwitch){
                            case 0x03:
                                return txtDescBolsterLeft
                            case 0x04:
                                return txtDescBolsterRight
                            default:
                                return txtDescBolster
                        }
                    }
                    case 0x03:{
                        switch(canDB.MultiFuncSwitch){
                            case 0x03:
                                return txtDescCushionLeft
                            case 0x4:
                                return txtDescCushionRight
                            default:
                                return txtDescCushion
                        }
                    }
                }
            }

            font.pointSize: 32
            font.family: fontFamily
            color: colorBrightGrey
            visible:true
        }
    }

    Item {
        id: lineJog

        Image {
            id: img_line_jog
            anchors.top:parent.top
            anchors.topMargin: 285
            anchors.left: parent.left
            anchors.leftMargin: countryVariant == 4 ? 842 : 332
            source :
            {
                if( canDB.SeatCtrlMode == 0x01 )        // Lumbar
                   imgFolderSeatControl +  "line_lumbar.png"
                else if ( canDB.SeatCtrlMode == 0x02 )  // Bolster
                    countryVariant == 4 ? imgFolderSeatControl +  "line_side_bolster_me.png" :  imgFolderSeatControl +  "line_side_bolster.png"
                else                                            // Cushion
                    countryVariant == 4 ? imgFolderSeatControl +  "line_cushion_me.png" :  imgFolderSeatControl +  "line_cushion.png"
            }
        }
    }

    /*
      0x0:Off / 0x1:Up / 0x2:Down / 0x3:Left / 0x4:Right / 0xF:Invalid /
    */
    Item {
        id: jog
        anchors.fill: parent
        Image {
            id: img_jog
            anchors.top:parent.top
            anchors.topMargin: 201
            anchors.left: parent.left
            anchors.leftMargin: countryVariant == 4 ? 685 : 408
            source: imgFolderSeatControl+"bg_knob.png"
            Image {
                id: img_arrow_up
                anchors.left: img_arrow_left.left
                anchors.leftMargin: 35
                anchors.top:parent.top
                anchors.topMargin: 8
                source: (canDB.MultiFuncSwitch == 0x01)? imgFolderSeatControl+"knob_arrow_u_f.png":imgFolderSeatControl+"knob_arrow_u_n.png"
                visible:
                {
                    if( canDB.SeatCtrlMode == 0x01)
                        true
                    else
                        false
                }
            }
            Image {
                id: img_arrow_down
                anchors.left: img_arrow_left.left
                anchors.leftMargin: 35
                anchors.top:img_arrow_left.top
                anchors.topMargin: 33
                source: (canDB.MultiFuncSwitch == 0x02)? imgFolderSeatControl+"knob_arrow_d_f.png":imgFolderSeatControl+"knob_arrow_d_n.png"
                visible:
                {
                    if( canDB.SeatCtrlMode == 0x01)
                        true
                    else
                        false
                }
            }
            Image {
                id: img_arrow_left
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                source: (canDB.MultiFuncSwitch == 0x3)? imgFolderSeatControl+"knob_arrow_l_f.png":imgFolderSeatControl+"knob_arrow_l_n.png"
                visible:
                {
                    if( canDB.SeatCtrlMode )
                        true
                    else
                        false
                }
            }
            Image {
                id: img_arrow_right
                anchors.left: img_arrow_up.left
                anchors.leftMargin: 36
                anchors.verticalCenter: parent.verticalCenter
                source: (canDB.MultiFuncSwitch == 0x4)?imgFolderSeatControl+"knob_arrow_r_f.png":imgFolderSeatControl+"knob_arrow_r_n.png"
                visible:
                {
                    if( canDB.SeatCtrlMode )
                        true
                    else
                        false
                }
            }
        }
    }

    Item {
        id: seat
        anchors.fill: parent
        Image {
            id: img_seat_lumbar
            anchors.top: parent.top
            anchors.topMargin: 427
            anchors.left: parent.left
            anchors.leftMargin: countryVariant == 4 ? 277 : 915
            source: imgFolderSeatControl+"seat_lumbar.png"
            visible:
            {
                if(canDB.SeatCtrlMode == 0x01)
                    true
                else
                    false
            }
        }
        Item {
            id: seat_arrow
            anchors.fill: parent
            Image {
                id: img_arrow_lumbar_up
                anchors.top:parent.top
                anchors.topMargin: 359
                anchors.left: parent.left
                anchors.leftMargin: countryVariant == 4 ? 134 + 72 : 772+72
                source:  (canDB.MultiFuncSwitch == 0x01) ?  imgFolderSeatControl+"arrow_lumbar_u_f.png" :  imgFolderSeatControl+"arrow_lumbar_u_n.png"
                visible:
                {
                    if(canDB.SeatCtrlMode == 0x01)
                        true
                    else
                        false
                }
            }

            Image {
                id: img_arrow_lumbar_down
                anchors.top:parent.top
                anchors.topMargin: 359+71+48
                anchors.left: parent.left
                anchors.leftMargin: countryVariant == 4 ? 134 + 72 : 772+72
                source:  (canDB.MultiFuncSwitch == 0x02) ?  imgFolderSeatControl+"arrow_lumbar_d_f.png" :  imgFolderSeatControl+"arrow_lumbar_d_n.png"
                visible:
                {
                    if(canDB.SeatCtrlMode == 0x01)
                        true
                    else
                        false
                }
            }
            Image {
                id: img_arrow_lumbar_left
                anchors.top:parent.top
                anchors.topMargin: 359+71
                anchors.left: parent.left
                anchors.leftMargin: countryVariant == 4 ? 134 : 772
                source:  (canDB.MultiFuncSwitch == 0x03) ?  imgFolderSeatControl+"arrow_lumbar_l_f.png" :  imgFolderSeatControl+"arrow_lumbar_l_n.png"
                visible:
                {
                    if(canDB.SeatCtrlMode == 0x01)
                        true
                    else
                        false
                }
            }
            Image {
                id: img_arrow_lumbar_right
                anchors.top:parent.top
                anchors.topMargin: 359+71
                anchors.left: parent.left
                anchors.leftMargin: countryVariant == 4 ? 134 + 72 + 43 : 772+72+43
                source:  (canDB.MultiFuncSwitch == 0x04) ?  imgFolderSeatControl+"arrow_lumbar_r_f.png" :  imgFolderSeatControl+"arrow_lumbar_r_n.png"
                visible:
                {
                    if(canDB.SeatCtrlMode == 0x01)
                        true
                    else
                        false
                }
            }
        }

        Image {
            id: img_seat_bloster
            anchors.top: parent.top
            anchors.topMargin: 317
            anchors.left: parent.left
            anchors.leftMargin: countryVariant == 4 ? 245 : 884
            source: imgFolderSeatControl+"seat_side_bolster.png"
            visible:
            {
                if(canDB.SeatCtrlMode == 0x02)
                    true
                else
                    false
            }
        }
        Image {
            id: img_arrow_bloster_left
            anchors.top: parent.top
            anchors.topMargin: 432
            anchors.left: parent.left
            anchors.leftMargin: countryVariant == 4 ? 303 : 938
            source: (canDB.MultiFuncSwitch == 0x03) ?  imgFolderSeatControl+"arrow_side_bolster_l_f.png" : imgFolderSeatControl+ "arrow_side_bolster_l_n.png"
            visible:
            {
                if(canDB.SeatCtrlMode == 0x02)
                    true
                else
                    false
            }
        }
        Image {
            id: img_arrow_bloster_right
            anchors.top: parent.top
            anchors.topMargin: 432
            anchors.left: parent.left
            anchors.leftMargin: countryVariant == 4 ? 303 + 90 : 938 + 95
            source: (canDB.MultiFuncSwitch == 0x04) ?  imgFolderSeatControl+"arrow_side_bolster_r_f.png" :  imgFolderSeatControl+"arrow_side_bolster_r_n.png"
            visible:
            {
                if(canDB.SeatCtrlMode == 0x02)
                    true
                else
                    false
            }
         }

        Image {
            id: img_seat_cushion
            anchors.top: parent.top
            anchors.topMargin: 513
            anchors.left: parent.left
            anchors.leftMargin: countryVariant == 4 ? 129 : 766
            source: imgFolderSeatControl+"seat_cushion.png"
            visible:
            {
                if(canDB.SeatCtrlMode == 0x03)
                    true
                else
                    false
            }
        }
        Image {
            id: img_arrow_cushion_left
            anchors.top: parent.top
            anchors.topMargin: 426 + 9
            anchors.left: parent.left
            anchors.leftMargin: countryVariant == 4 ? 120 : 757
            source: (canDB.MultiFuncSwitch == 0x03) ?  imgFolderSeatControl+"arrow_cushion_l_f.png" : imgFolderSeatControl+ "arrow_cushion_l_n.png"
            visible:
            {
                if(canDB.SeatCtrlMode == 0x03)
                    true
                else
                    false
            }
        }
        Image {
            id: img_arrow_cushion_right
            anchors.top: parent.top
            anchors.topMargin: 426
            anchors.left: parent.left
            anchors.leftMargin: countryVariant == 4 ? 120 + 114 : 757 + 114
            source: (canDB.MultiFuncSwitch == 0x04) ?  imgFolderSeatControl + "arrow_cushion_r_f.png" :  imgFolderSeatControl + "arrow_cushion_r_n.png"
            visible:
            {
                if(canDB.SeatCtrlMode == 0x03)
                    true
                else
                    false
            }
         }
    }
    }// Image imgBG
}
