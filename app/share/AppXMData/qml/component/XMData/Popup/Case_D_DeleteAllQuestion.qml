/**
 * FileName: Case_D_DeleteAllQuestion.qml
 * Author: David.Bae
 * Time: 2012-05-11 18:07
 *
 * - 2012-05-11 Initial Created by David
 */
import Qt 4.7
import QtQuick 1.1

// System Import
import "../../QML/DH" as MComp
import "../../../component/XMData" as XMData

MComp.MComponent{
    id:container

    property string text: ""

    property bool checkAntSig: idAppMain.statusAntSig

    signal close();
    signal button1Clicked();

    onCheckAntSigChanged:{
        if(checkAntSig == false)
        {
            if(idMPopupTypeText.visible == true)
                idMPopupTypeText.x = 0;
        }
    }

    MComp.MComponent{
        id: idMPopupTypeText
        x: 0; y: -systemInfo.statusBarHeight
        z: idMenuBar.z + 999
        width: systemInfo.lcdWidth; height: systemInfo.lcdHeight+systemInfo.statusBarHeight
        focus: true
        Rectangle{
            anchors.fill: parent
            color: colorInfo.black
            opacity: 0.6
        }
        //****************************** # Popup BG image #
        Image{
            id: idBG
            x: 93; y: 208
            width: 1093; height: 304
            source: imageInfo.imgFolderPopup+"bg_type_a.png"
        }
        MComp.MButton{
            id: idButton1
            x: 93 + 780
            y: 208 + 18// - systemInfo.statusBarHeight + 18
            width: 295/*288*/;
            height: 134
            bgImageButtonLine: imageInfo.imgFolderPopup+"btn_type_a_02_n.png"
            bgImagePress: imageInfo.imgFolderPopup+"btn_type_a_02_p.png"
            bgImageFocus: imageInfo.imgFolderPopup+"btn_type_a_02_f.png"
            focus: true

            //fgImageX: popupBtnCnt == 1 ? 773 - 780 : popupBtnCnt == 2 ? 767 - 780 : popupBtnCnt == 3 ? 766 - 780 : 763 - 780
            fgImageX: 774-780
            fgImageY: 50 - 18
            fgImageWidth: 69
            fgImageHeight: 69
            fgImage: imageInfo.imgFolderPopup+"light.png"
            fgImageVisible: focusImageVisible
            KeyNavigation.down: idButton2
//            onWheelLeftKeyPressed: idButton2.focus = true//[ITS 206165]
            onWheelRightKeyPressed: idButton2.focus = true

            MComp.DDScrollTicker{
                x: 832 - 780
                y: 0//popupBtnCnt == 1 ? popupFirstBtnText2Line != "" ? 133 - 25 : 152 - 25 : popupBtnCnt == 2 ? popupFirstBtnText2Line != "" ? 66 - 25 : 85 - 25 : popupBtnCnt == 3 ? popupFirstBtnText2Line != "" ? 58 - 25 : 77 - 25 : popupFirstBtnText2Line != "" ? 49 - 25 : 66 - 25
                width: 210
                height: parent.height//popupFirstBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
                text: stringInfo.sSTR_XMDATA_YES
                fontSize: 36
                fontFamily: systemInfo.font_NewHDB
                color: colorInfo.brightGrey
                tickerEnable: true
                tickerFocus: idButton1.activeFocus
            }

            onClickOrKeySelected: {
                button1Clicked();
            }

            Keys.onUpPressed: {
                return;
            }
            Keys.onDownPressed: {
                return;
            }
        }

        MComp.MButton{
            id: idButton2
            x: 93 + 780
            y: 208 + 18 + 134// - systemInfo.statusBarHeight + 18 + 134
            width: 295/*288*/;
            height: 134
            bgImageButtonLine: imageInfo.imgFolderPopup+"btn_type_a_03_n.png"
            bgImagePress: imageInfo.imgFolderPopup+"btn_type_a_03_p.png"
            bgImageFocus: imageInfo.imgFolderPopup+"btn_type_a_03_f.png"

            //fgImageX: popupBtnCnt == 2 ? 767 - 780 : popupBtnCnt == 3 ? 766 + 12 - 780 : 763 + 13 - 780
            fgImageX: 774-780
            fgImageY: 50 + 134 - 25 - 127
            fgImageWidth: 69
            fgImageHeight: 69
            fgImage: imageInfo.imgFolderPopup+"light.png"
            fgImageVisible: focusImageVisible
            KeyNavigation.up: idButton1
            KeyNavigation.down: idButton2
            onWheelLeftKeyPressed: idButton1.focus = true
//            onWheelRightKeyPressed: idButton1.focus = true//[ITS 206165]

            MComp.DDScrollTicker{
                x: 832 - 780
                y: 0//popupBtnCnt == 2 ? popupSecondBtnText2Line != "" ? 66 + 40 + 94 - 25 - 127 : 85 + 134 - 25 - 127 : popupBtnCnt == 3 ? popupSecondBtnText2Line != "" ? 58 + 40 + 70 - 25 - 109 : 77 + 110 - 25 - 109 : popupSecondBtnText2Line != "" ? 49 + 36 + 46 - 25 - 82 : 66 + 82 - 25 - 82
                width: 210
                height: parent.height//popupSecondBtnText2Line != "" ? popupBtnCnt == 4 ? 28 : 32 : 36
                text: stringInfo.sSTR_XMDATA_NO
                fontSize: 36
                fontFamily: systemInfo.font_NewHDB
                color: colorInfo.brightGrey
                tickerEnable: true
                tickerFocus: idButton2.activeFocus
            }

            onClickOrKeySelected: {
                close();
                if(!idButton1.activeFocus)
                    idButton1.focus = true;
            }

            Keys.onUpPressed: {
                return;
            }
            Keys.onDownPressed: {
                return;
            }
        }

        Text{
            text: container.text
            x: idBG.x+78; y: idBG.y
            width: 654; height: idBG.height
            font.pixelSize: 32
            font.family: systemInfo.font_NewHDR
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.subTextGrey
            wrapMode: Text.Wrap
            lineHeight: 0.75
        }
        onBackKeyPressed: {
            if(!idButton1.activeFocus)
                idButton1.focus = true;
            close();
        }
    }


    Connections{
        target:UIListener
        onTemporalModeMaintain:{
            if(!mbTemporalmode)
            {
                if(visible)
                    close();
            }
        }

        onSignalShowSystemPopup:{
            console.log("onSignalShowSystemPopup")
            if(visible)
                close();
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
                    if(idMPopupTypeText.visible == true)
                        idMPopupTypeText.x = +1280;
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
