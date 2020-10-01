/**
 * FileName: XMDataLeftMenuGroup.qml
 * Author: David.Bae
 * Time: 2012-04-26 21:00
 *
 * - 2012-04-26 Initial Created by David
 */
import Qt 4.7
import QtQuick 1.1

import "../QML/DH" as MComp

FocusScope{
    id: idLeftMenuFocusScope
    width: 276 //idLeftMenuBgImage.width
    height: 555 //idLeftMenuBgImage.height

    property int countOfButton: 4

    property alias button1Text: idButton1Text.text
    property alias button2Text: idButton2Text.text
    property alias button3Text: idButton3Text.text
    property alias button4Text: idButton4Text.text
    property alias button1Active: idButton1Text.active;
    property alias button2Active: idButton2Text.active;
    property alias button3Active: idButton3Text.active;
    property alias button4Active: idButton4Text.active;
    property bool isNotStockBtn: true
    property bool isWrapForWeather: false
    property bool autoTextSize: false

//    property alias button2TextSize: idButton2Text.font.pixelSize

    signal button1Clicked();
    signal button2Clicked();
    signal button3Clicked();
    signal button4Clicked();

    //Menu bg image
    Image{
        id:idLeftMenuBgImage
        source: imageInfo.imgFolderMusic + "music_tab_bg.png";
    }

    Keys.onPressed:
    {
        if(event.key == Qt.Key_Up && event.modifiers == Qt.NoModifier)
        {
            if(KeyNavigation.right != null)
            {
                KeyNavigation.right.forceActiveFocus();
            }
            idMenuBar.focusInitLeft();
        }
    }

    function getBgImageName(buttonNumber, type)
    {
        if(countOfButton == 4){
            return imageInfo.imgFolderXMData + "search_tab_0"+buttonNumber+"_"+type+".png"
        }else if(countOfButton == 3){
            if(buttonNumber==4)
                return "";
            return imageInfo.imgFolderDmb + "urgent_tab_0"+buttonNumber+"_"+type+".png"
        }else if(countOfButton == 2){
            if(buttonNumber==4 || buttonNumber==3)
                return "";
            return imageInfo.imgFolderRadio_SXM + "fav_tab_0"+buttonNumber+"_"+type+".png"
        }else if(countOfButton == 1){
            if(buttonNumber==4 || buttonNumber==3||buttonNumber==2)
                return "";
            return imageInfo.imgFolderDmb + "urgent_tab_0"+buttonNumber+"_"+type+".png"
        }
        return "";
    }

    function getMenuHeight()
    {
        if(countOfButton == 4){
            return 138
        }else if(countOfButton == 3){
            return 187
        }else if(countOfButton == 2) {
            return 277
        }else if(countOfButton == 1) {
            return parent.height;
        }
        return parent.height;
    }

    function initFirstFocus()
    {
        idButton1.focus = true;
    }

    // Button 1
    MComp.MButton{
        id: idButton1
        y:0
        width: 276;
        height: getMenuHeight()

        bgImage:            ""
        bgImagePress:       getBgImageName("1", "p");
        bgImageFocus:       getBgImageName("1", "f");
        bgImageFocusPress:  getBgImageName("1", "p");

        Text{
            id: idButton1Text
            anchors.fill: parent
            anchors.bottomMargin: 20
            anchors.leftMargin: 10
            anchors.rightMargin: 40
            property bool active: false
            font.pixelSize: 40
            color: idButton1.buttonState == idButton1.e_DISABLED ? "red" : idButton1.buttonState == idButton1.e_FOCUSED ? colorInfo.brightGrey : active ? "#7CBDFF" : colorInfo.brightGrey//[ITS 191744]
            font.family: active ? /*idButton1.buttonState == idButton1.e_FOCUSED ? systemInfo.font_NewHDR :*/ systemInfo.font_NewHDB : systemInfo.font_NewHDR
            wrapMode: Text.Wrap
            lineHeight: 0.75
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        onWheelLeftKeyPressed: {
            idButton1.forceActiveFocus();
        }
        onWheelRightKeyPressed: {
            (countOfButton!=1)?idButton2.forceActiveFocus():idButton1.forceActiveFocus();
        }

        visible:(countOfButton==1) || (countOfButton==2) || (countOfButton == 3) || (countOfButton == 4)
        onClickOrKeySelected:{
            idButton1.forceActiveFocus();
            button1Clicked();
        }
        focus:true;
    }

    Image {
        y: idButton1.height - 1
        source: imageInfo.imgFolderXMData + "line_left_list_m.png"
    }

    // Button 2
    MComp.MButton{
        id: idButton2
        y:idButton1.y + idButton1.height
        width: 276;
        height: getMenuHeight()

        bgImage:            ""
        bgImagePress:       getBgImageName("2", "p");
        bgImageFocus:       getBgImageName("2", "f");
        bgImageFocusPress:  getBgImageName("2", "p");

        Text{
            id: idButton2Text
            anchors.fill: parent
            anchors.bottomMargin: 20
            anchors.leftMargin: 10
            anchors.rightMargin: 43
            property bool active: false
            font.pixelSize: 40
            color: idButton2.buttonState == idButton2.e_DISABLED ? "red" : idButton2.buttonState == idButton2.e_FOCUSED ? colorInfo.brightGrey : active ? "#7CBDFF" : colorInfo.brightGrey//[ITS 191744]
            font.family: active ? /*idButton2.buttonState == idButton2.e_FOCUSED ? systemInfo.font_NewHDR :*/ systemInfo.font_NewHDB : systemInfo.font_NewHDR
            wrapMode: Text.Wrap
            lineHeight: 0.75
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            onPaintedWidthChanged: {
                if(autoTextSize)
                {
                    if(paintedWidth > width || lineCount > 1)
                    {
                        idButton2Text.font.pixelSize = idButton2Text.font.pixelSize - 4
                    }
                }
            }
        }

        onWheelLeftKeyPressed: {
            idButton1.forceActiveFocus()
        }

        onWheelRightKeyPressed: {
            (countOfButton>2)?idButton3.forceActiveFocus():idButton2.forceActiveFocus()
        }

        visible:(countOfButton==2) || (countOfButton == 3) || (countOfButton == 4)
        onClickOrKeySelected:{
            if(isNotStockBtn)
                idButton2.forceActiveFocus();
            button2Clicked();
        }
    }

    Image {
        y: idButton2.y + idButton2.height - 1
        source: imageInfo.imgFolderXMData + "line_left_list_m.png"
    }

    // Button 3
    MComp.MButton{
        id: idButton3
        y:idButton2.y + idButton2.height
        width: 276;
        height: getMenuHeight()

        bgImage:            ""
        bgImagePress:       getBgImageName("3", "p");
        bgImageFocus:       getBgImageName("3", "f");
        bgImageFocusPress:  getBgImageName("3", "p");

        Text{
            id: idButton3Text
            anchors.fill: parent
            anchors.bottomMargin: 20
            anchors.leftMargin: 10
            anchors.rightMargin: 40
            property bool active: false
            font.pixelSize: 40
            color: idButton3.buttonState == idButton3.e_DISABLED ? "red" : idButton3.buttonState == idButton3.e_FOCUSED ? colorInfo.brightGrey : active ? "#7CBDFF" : colorInfo.brightGrey//[ITS 191744]
            font.family: active ? /*idButton3.buttonState == idButton3.e_FOCUSED ? systemInfo.font_NewHDR :*/ systemInfo.font_NewHDB : systemInfo.font_NewHDR
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            lineHeight: 0.75
        }

        onWheelLeftKeyPressed: {
            idButton2.forceActiveFocus();
        }
        onWheelRightKeyPressed: {
            (countOfButton>3)?idButton4.forceActiveFocus():idButton3.forceActiveFocus();
        }
        visible:(countOfButton == 3) || (countOfButton == 4)
        onClickOrKeySelected:{
            idButton3.forceActiveFocus();
            button3Clicked();
        }
    }

    Image {
        y: idButton3.y + idButton3.height - 1
        source: imageInfo.imgFolderXMData + "line_left_list_m.png"
        visible:(countOfButton == 4)
    }

    // Button 4
    MComp.MButton{
        id: idButton4
        y:idButton3.y + idButton3.height
        width: 276;
        height: getMenuHeight()

        bgImage:            ""
        bgImagePress:       getBgImageName("4", "p");
        bgImageFocus:       getBgImageName("4", "f");
        bgImageFocusPress:  getBgImageName("4", "p");

        Text{
            id: idButton4Text
            anchors.fill: parent
            anchors.bottomMargin: 20
            anchors.leftMargin: 10
            anchors.rightMargin: 40
            property bool active: false
            font.pixelSize: 40
            color: idButton4.buttonState == idButton4.e_DISABLED ? "red" : idButton4.buttonState == idButton4.e_FOCUSED ? colorInfo.brightGrey : active ? "#7CBDFF" : colorInfo.brightGrey//[ITS 191744]
            font.family: active ? /*idButton4.buttonState == idButton4.e_FOCUSED ? systemInfo.font_NewHDR :*/ systemInfo.font_NewHDB : systemInfo.font_NewHDR
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            lineHeight: 0.75
        }

        onWheelLeftKeyPressed: {
            idButton3.forceActiveFocus();
        }
        onWheelRightKeyPressed: {
            idButton4.forceActiveFocus();
        }
        visible:(countOfButton == 4)
        onClickOrKeySelected:{
            idButton4.forceActiveFocus();
            button4Clicked();
        }
    }

    XMRectangleForDebug{} //Left Menu Bound for debugging.

    //Debuging........
    Text {
        x:5; y:12; id:idFileName
        text:"XMDataLeftMenuGroup.qml";
        color : "white";
        visible:isDebugMode()
    }
}//idLeftMenuFocusScope
