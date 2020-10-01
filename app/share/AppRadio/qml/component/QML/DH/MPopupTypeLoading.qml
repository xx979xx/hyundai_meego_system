/**
 * FileName: MPopupTypeLoading.qml
 * Author: HYANG
 * Time: 2012-12
 *
 * - 2012-12-04 Initial Created by HYANG
 * - 2012-12-12 Add Text-LineNumber3, ButtonNumber2, Text2Line in Button by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem

MComponent{
    id: idMPopupTypeLoading
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    property string imgFolderPopup: imageInfo.imgFolderPopup    

    property string popupBgImage: popupLineCnt < 3 ? imgFolderPopup+"bg_type_a.png" : imgFolderPopup+"bg_type_b.png"
    property int popupBgImageX: 93
    property int popupBgImageY: popupLineCnt < 3 ? 208-systemInfo.statusBarHeight : 171-systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: popupLineCnt < 3 ? 304 : 379

    property int popupTextX: popupBgImageX + 57
    property int popupTextSpacing: 44
    property string popupFirstText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""

    property string popupFirstBtnText: ""
    property string popupFirstBtnText2Line: ""
    property string popupSecondBtnText: ""
    property string popupSecondBtnText2Line: ""

    property int popupBtnCnt: 1  //# 0 or 1 or 2
    property int popupLineCnt: 2    //# 1 or 2 or 3
    property int loadingImageNumber: 1 //2013.11.23 added by qutiguy - GUI review issues.

    signal popupClicked();
    signal popupBgClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    /* EVENT handlers */
    Component.onCompleted: {
        if(true == idMPopupTypeLoading.visible) {
            idButton1.forceActiveFocus();
        }
    }

    onVisibleChanged: {
        if(true == idMPopupTypeLoading.visible) {
            idButton1.forceActiveFocus();
        }
    }
    
    //****************************** # Background mask click #
    onClickOrKeySelected: {
        popupBgClicked()
    }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: showPopup ? 0.0 : 0.6
    }

    //****************************** # Popup image click #
    //KSW 131224 ITS/217144
    Image{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        source: popupBgImage
        visible: showPopup ? false : true
    }

    //****************************** # Loading Image #
    Image {
        id: idLoadingImage
        x: popupBtnCnt == 0 ? popupBgImageX + 57 + 439 : popupBgImageX + 57 + 309 ;
        y: popupLineCnt < 3 ? popupBgImageY + 50 : popupBgImageY + 60
        //2013.11.23 modified by qutiguy - GUI review issues.
        width: 76; height: 76
        source: imgFolderPopup + "loading/loading_" + "01.png";
        visible: idLoadingImage.on
        property bool on: parent.visible;
        //2013.11.23 modified by qutiguy - GUI review issues.
        onVisibleChanged: {
            if(visible)
                idLoadingPopupTimer.start();
            else
                idLoadingPopupTimer.stop();
        }

    }

    Timer {
        id: idLoadingPopupTimer
        interval: 100
        running: true
        repeat: true
        onTriggered:{
            loadingImageNumber++;
            if(loadingImageNumber == 17)
                loadingImageNumber = 1;
            if(loadingImageNumber < 10)
                idLoadingImage.source = imgFolderPopup + "loading/loading_0"+ loadingImageNumber +".png"
            else
                idLoadingImage.source = imgFolderPopup + "loading/loading_"+ loadingImageNumber +".png"
        }
      //
    }

    //****************************** # Popup Button #
    MButtonOnlyRadio{
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + 18 //+25
        width: 288;
        height: popupBtnCnt == 1 ? 254 : popupBtnCnt == 2 ? 127 : popupBtnCnt == 3 ? 109 : 82
        bgImage: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_n.png" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_02_n.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_04_n.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_07_n.png" : ""
        bgImagePress: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_p.png" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_02_p.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_04_p.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_07_p.png" : ""
        bgImageFocus: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_a_01_f.png" : popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_02_f.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_04_f.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_07_f.png" : ""
        focus: true

        fgImageX: popupBtnCnt == 1 ? 778 - 780 : popupBtnCnt == 2 ? 767 - 780 : popupBtnCnt == 3 ? 766 - 780 : 763 - 780
        fgImageY: popupBtnCnt == 1 ? 117 - 25+7 : popupBtnCnt == 2 ? 50 - 25 : popupBtnCnt == 3 ? 44 - 25 : 31 - 25
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: true == idButton1.activeFocus //focusImageVisible //KSW 131223 ITS/0216974
        KeyNavigation.down: popupBtnCnt == 1 ? idButton1 : idButton2
        onWheelLeftKeyPressed: popupBtnCnt == 1 ? idButton1.forceActiveFocus() : popupBtnCnt == 2 ? idButton2.forceActiveFocus() : popupBtnCnt == 3 ? idButton3.forceActiveFocus() : idButton4.forceActiveFocus()
        onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.forceActiveFocus() : idButton2.forceActiveFocus()

        firstText: popupFirstBtnText
        firstTextX: 832 - 780
        firstTextY: popupBtnCnt == 1 ? 152 - 25 : popupBtnCnt == 2 ? 85 - 25 : popupBtnCnt == 3 ? 77 - 25 : 66 - 25
        firstTextWidth: 210
        firstTextHeight: 36
        firstTextSize: 36
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        onClickOrKeySelected: {
            popupFirstBtnClicked()
        }
    }

    MButtonOnlyRadio{
        id: idButton2
        x: popupBgImageX + 780
        y: popupBtnCnt == 2 ? popupBgImageY + 25 + 127 : popupBtnCnt == 3 ? popupBgImageY + 25 + 109 : popupBgImageY + 25 + 82
        width: 288;
        height: popupBtnCnt == 2 ? 127 : popupBtnCnt == 3 ? 109 : 82
        bgImage: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_n.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_05_n.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_08_n.png" : ""
        bgImagePress: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_p.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_05_p.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_08_p.png" : ""
        bgImageFocus: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_a_03_f.png" : popupBtnCnt == 3 ? imgFolderPopup+"btn_type_b_05_f.png" : popupBtnCnt == 4 ? imgFolderPopup+"btn_type_b_08_f.png" : ""
        visible: popupBtnCnt > 1

        fgImageX: popupBtnCnt == 2 ? 767 - 780 : popupBtnCnt == 3 ? 766 + 12 - 780 : 763 + 13 - 780
        fgImageY: popupBtnCnt == 2 ? 50 + 134 - 25 - 127 : popupBtnCnt == 3 ? 44 + 110 - 25 - 110 : 31 + 82 - 25 - 82
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: true == idButton2.activeFocus //focusImageVisible //KSW 131223 ITS/0216974
        KeyNavigation.up: idButton1
        KeyNavigation.down: popupBtnCnt > 2 ? idButton3 : idButton2
        onWheelLeftKeyPressed: idButton1.forceActiveFocus()
        onWheelRightKeyPressed: popupBtnCnt == 2 ? idButton1.forceActiveFocus() : idButton3.forceActiveFocus()

        firstText: popupSecondBtnText
        firstTextX: 832 - 780
        firstTextY: popupBtnCnt == 2 ? 85 + 134 - 25 - 127 : popupBtnCnt == 3 ? 77 + 110 - 25 - 109 : 66 + 82 - 25 - 82
        firstTextWidth: 210
        firstTextHeight: 36
        firstTextSize: 36
        firstTextStyle: systemInfo.hdb
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        onClickOrKeySelected: {
            popupSecondBtnClicked()
        }
    }

    //****************************** # Text (firstText, secondText, thirdText, fourthText) #
    Text{
        id: idText1
        text: popupFirstText
        x: popupTextX
        y: popupLineCnt == 1 ? popupBgImageY + 50 + 170 - 32/2 : popupLineCnt == 2 ? popupBgImageY + 50 + 148 - 32/2 : popupBgImageY + 60 + 148 - 32/2
        width: popupBtnCnt == 0 ? 439 + 541 : 309 + 401;
        height: 32
        font.pixelSize: 32
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
    }

    Text{
        id: idText2
        text: popupSecondText
        x: popupTextX;
        y: popupLineCnt == 2 ? popupBgImageY + 50 + 148 + popupTextSpacing - 32/2 : popupBgImageY + 60 + 148 + popupTextSpacing - 32/2
        width: popupBtnCnt == 0 ? 439 + 541 : 309 + 401;
        height: 32
        font.pixelSize: 32
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.subTextGrey
        visible: popupLineCnt > 1
    }

    Text{
        id: idText3
        text: popupThirdText
        x: popupTextX;
        y: popupBgImageY + 60 + 148 + popupTextSpacing + popupTextSpacing - 32/2
        width: popupBtnCnt == 0 ? 439 + 541 : 309 + 401;
        height: 32
        font.pixelSize: 32
        font.family: systemInfo.hdb
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        visible: popupLineCnt == 3
    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}
