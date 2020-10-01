/**
 * FileName: MDimPopup.qml
 * Author: HYANG
 * Time: 2012-04
 *
 * - 2012-04 Initial Created by HYANG
 */

import QtQuick 1.0
import "../System" as MSystem

MComponent{
    id: idMDimPopup
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    property string popupName
    property string imgFolderPopup: imageInfo.imgFolderPopup
    property int loadingImageNumber: 1
    property string firstText: ""
    property string secondText: ""
    property bool loadingFlag: false
    property int textLineCount : 1  //# count of line(1 or 2)

    signal popupClicked();
    signal hardBackKeyClicked();

    //MouseArea{ anchors.fill: parent }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height:parent.height
        color: colorInfo.black
        opacity: 0.7
    }
    //****************************** # Popup Background #
    Image{
        x: 259; y: 463-systemInfo.statusBarHeight
        width: 762; height: 190
        source: imgFolderPopup+"bg_type_c.png"
        //        MouseArea{
        //            anchors.fill: parent
        //            onClicked: popupClicked()
        //        }
    }

    //**************************************** Loading Image
    Image {
        id: idImageContainer
        x: firstLine.x - 73 ; y: 463+70-systemInfo.statusBarHeight
        width: 60; height: 60
        //source: imgFolderPopup + "loading/ani.gif";
        visible: idImageContainer.on && loadingFlag
        property bool on: parent.visible;
        //NumberAnimation on rotation { running: idImageContainer.on; from: 0; to: 360; loops: Animation.Infinite; duration: 2400 }
    }

    Timer {
        id: idLoadingImageTimer
        interval: 125
        running: true
        repeat: true
        onTriggered:
        {
            idImageContainer.source = imgFolderPopup + "loading/loading_"+ loadingImageNumber +".png"
            loadingImageNumber++;

            if(loadingImageNumber == 17)
            {
                loadingImageNumber = 1;
            }
        }
    }
    onVisibleChanged: {

        if(idMDimPopup.visible == true)
        {
            idLoadingImageTimer.start();
        }
        else
        {
             loadingImageNumber = 1;
            idLoadingImageTimer.stop();
        }
    }
    //****************************** # Text (firstText, secondText) #
    Text{
        id: firstLine
        text: firstText
        x: firstXChanged()//259+25
        y: firstYChanged()//463+63-34/2-systemInfo.statusBarHeight
        width: firstWidthChanged() //712
        height: 34
        font.pixelSize: 34
        font.family: UIListener.getFont(true)/*"HDB"*/
        horizontalAlignment: firstAlignChanged()//Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
    }

    Text{
        id: secondLine
        text: secondText
        x: 259+25; y: 463+63+60-34/2-systemInfo.statusBarHeight
        width: 712; height: 34
        font.pixelSize: 34
        font.family: UIListener.getFont(true)/*"HDB"*/
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        visible: textLineCount != 1
    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        //hardBackKeyClicked()
    }

    //************************ Function for FirstText ***//
    function firstXChanged(){
        if(loadingFlag) return 259+(((762-firstLine.width)-73)/2)+73
        else return 259+25
    }
    function firstYChanged(){
        if(loadingFlag) return 463+70+21-34/2-systemInfo.statusBarHeight
        else{
            if(textLineCount==1) return 463+93-34/2-systemInfo.statusBarHeight
            else return 463+63-34/2-systemInfo.statusBarHeight
        }
    }
    function firstWidthChanged(){
        if(loadingFlag) Text.paintedWidth
        else return 712
    }
    function firstAlignChanged(){
        if(loadingFlag) return Text.AlignLeft
        else return Text.AlignHCenter
    }
}
