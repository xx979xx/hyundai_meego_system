/**
 * FileName: idMPopupTypeEPG.qml
 * Author: HYANG
 * Time: 2013-1
 *
 * - 2013-1-02 Initial Created by HYANG
 */

import QtQuick 1.1
import "../../QML/DH" as MComp

MComponent{
    id: idMPopupTypeSubscription
    x: 0; y: -systemInfo.statusBarHeight
    z: idMenuBar.z + 999
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight+systemInfo.statusBarHeight
    focus: true

    property string imgFolderPopup: imageInfo.imgFolderPopup

    property string popupBgImage: imgFolderPopup+"bg_type_b.png"
    property int popupBgImageX: 93
    property int popupBgImageY: 171//-systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: 379

    property int popupTextX: popupBgImageX + 69
    property int popupTextSpacing: 46
    property int popupTextY: popupBgImageY + 72 - 32/2
    property string popupFirstText: ""
    property string popupNinthText: ""
    property string popupTenthText: ""

    property string popupFirstBtnText: ""
    property string popupFirstBtnText2Line: ""
    property string popupSecondBtnText: ""
    property string popupSecondBtnText2Line: ""

    property int popupBtnCnt: 2    //# 1 or 2
    property int overContentCount: 0
    property bool secondBtnEnable: false
    
    property bool checkAntSig: idAppMain.statusAntSig
    
    signal popupClicked();
    signal popupBgClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    //****************************** # Background mask click #
    onClickOrKeySelected: {
        popupBgClicked()
    }

    onCheckAntSigChanged:{
        if(checkAntSig == false)
        {
            if(idMPopupTypeSubscription.visible == true)
                idMPopupTypeSubscription.x = 0;
        }
    }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    //****************************** # Popup BG image #
    Image{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        source: popupBgImage
    }

    //****************************** # Text (firstText, secondText, thirdText, fourthText, FifthText) #
    Text{
        id: idFirstText
        text: popupFirstText
        x: popupTextX; y: popupTextY
        width: 600; height: (22*7)
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDB
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        elide: Text.ElideRight
    }

    Image{
        id: idDivide
        x: popupTextX; y: popupTextY + 40 + 40 + 40 + 39
        width: 741; height: 2
        source: imageInfo.imgFolderPopup + "divide.png"
    }

    Text{
        id: idNinthText
        text: popupNinthText
        x: popupTextX; y: popupTextY + 40 + 40 + 40 + 39 + 24
        width: 663; height: 32
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        elide: Text.ElideRight
    }

    Text{
        id: idTenthText
        text: popupTenthText
        x: popupTextX; y: popupTextY + 40 + 40 + 40 + 39 + 30 + 40
        width: 663; height: 32
        font.pixelSize: 32
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        wrapMode: Text.WordWrap
        lineHeight: 0.70
    }

    //****************************** # Popup Button #
    MButton{
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + 18
        width: 295;
        height: 171
        bgImageButtonLine: imgFolderPopup+"btn_type_b_02_n.png"
        bgImagePress: imgFolderPopup+"btn_type_b_02_p.png"
        bgImageFocus: imgFolderPopup+"btn_type_b_02_f.png"
        visible: popupBtnCnt == 2
        focus: true

        fgImageX: 773 - 780
        fgImageY: 72 - 25
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible
        KeyNavigation.down: idButton2 ;
        onWheelRightKeyPressed: (secondBtnEnable == false) ? null : idButton2.focus = true

        DDScrollTicker{
            x: 832 - 780; y: 0//popupFirstBtnText2Line != "" ? 88 - 25 : 107 - 25
            width: 210; height: parent.height//popupFirstBtnText2Line != "" ? 32 : 36
            text: popupFirstBtnText + " " + popupFirstBtnText2Line
            fontSize: 36//popupFirstBtnText2Line != "" ? 32 : 36
            fontFamily: systemInfo.font_NewHDB
            color: colorInfo.brightGrey
            tickerEnable: true
            tickerFocus: idButton1.activeFocus
        }

        onClickOrKeySelected: {
            popupFirstBtnClicked()
        }

        //[ITS 182694]
        Keys.onUpPressed: {
            return;
        }
        Keys.onDownPressed: {
            return;
        }
    }

    MButton{
        id: idButton2
        x: popupBgImageX + 780
        y: popupBgImageY + 18 + 171
        width: 295;
        height: 172
        bgImage: (secondBtnEnable == false) ? imgFolderPopup+"btn_type_b_03_d.png" : ""
        bgImageButtonLine: (secondBtnEnable == true) ? imgFolderPopup+"btn_type_b_03_n.png" : ""
        bgImagePress: imgFolderPopup+"btn_type_b_03_p.png"
        bgImageFocus: imgFolderPopup+"btn_type_b_03_f.png"
        visible: popupBtnCnt == 2
        mEnabled: secondBtnEnable

        fgImageX: 773 - 780
        fgImageY: 72 + 164 - 25 - 164
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible
        KeyNavigation.up: idButton1
        onWheelLeftKeyPressed: idButton1.focus = true

        DDScrollTicker{
            x: 832 - 780
            y: 0//popupSecondBtnText2Line != "" ? 88 + 40 + 124 - 25 - 164 : 107 + 164 - 25 - 164
            width: 210
            height: parent.height//popupSecondBtnText2Line != "" ? 32 : 36
            text: popupSecondBtnText + " " + popupSecondBtnText2Line
            fontSize: 36//popupSecondBtnText2Line != "" ? 32 : 36
            fontFamily: systemInfo.font_NewHDB
            color: (secondBtnEnable == false) ? colorInfo.disableGrey : colorInfo.brightGrey
            tickerEnable: true
            tickerFocus: idButton2.activeFocus
        }

        onClickOrKeySelected: {
            popupSecondBtnClicked()
        }

        //[ITS 182694]
        Keys.onUpPressed: {
            return;
        }
        Keys.onDownPressed: {
            return;
        }
    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        hardBackKeyClicked()
    }

    function setButtonFocus()
    {
        idButton1.focus = true;
    }
    
    onSecondBtnEnableChanged: {
        if(idMPopupTypeSubscription.visible == false) return;

        if(idButton2.activeFocus == true && secondBtnEnable == false)
        {
            console.log("Subscription Status -> onSecondBtnEnableChanged 1 ------> "+secondBtnEnable+" "+idButton1.activeFocus+" "+idButton2.activeFocus);
            idButton1.focus = true;
        }
    }

    Connections {
        target: interfaceManager

        onAdvisoryMessage: {
            console.log("advisoryMessage - emit receive");
            switch(m_status)
            {
                case 1:
                {
                    if(idMPopupTypeSubscription.visible == true)
                        idMPopupTypeSubscription.x = +1280;
                    break;
                }
                default:
                {
                    //do nothing.
                }
            }
        }
    }
}
