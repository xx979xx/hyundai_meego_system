/**
 * FileName: MMsgPopup.qml
 * Author: WSH
 * Time: 2012-02-13
 *
 * - 2012-02-13 Initial Crated by WSH
 * - 2012-03-12 Add property [popupName] by proble Kang
 */
import QtQuick 1.0

import "../../system/DH" as MSystem

MComponent { //jyjeon_20120221
    id: idMMsgPopup
    x: 0; y: systemInfo.statusBarHeight
    width: parent.width;  //systemInfo.lcdWidth
    height: parent.height //systemInfo.subMainHeight
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    property string popupName: ""

    //--------------------- Button Click Event #
    signal btn0Click()
    signal btn1Click()
    signal btn2Click()
    signal btn3Click()
    signal dlgBGClick()

    //--------------------- Model Info #
    property QtObject btnModel
    property QtObject msgModel

    //--------------------- Popup Info #
    property int popupX: 110
    property int popupY: 130-systemInfo.statusBarHeight // 37
    property int popupWidth: 1086
    property int popupHeight: 505

    //--------------------- Title Info #
    property string titleText : "Title"
    property int titleTextWdith: 986
    property int titleTextHeight: titleTextSize
    property int titleTextX: 55
    property int titleTextY: 55
    property int titleTextSize: 44
    property string titleTextName: systemInfo.hdb
    property string titleTextAlies: "Left"

    //--------------------- Message Info #
    property int msgTextWidth: titleTextWdith+10               // 996
    property int msgTextHeight: (msgTextSize+62/2)*listMsgPopup.count
    property int msgTextX: titleTextX-10                       // 45
    property int msgTextY: 0                                   // Set function
    property int msgTextSize: 50
    property string msgTextName: systemInfo.hdb
    property string msgTextAlies: "Center"

    //--------------------- Button Info #
    //--------------------- Button Area Info ##
    property int btnAreaX: 0                                  // Set function
    property int btnAreaY: 392
    property int btnAreaWidth: 0                              // Set function
    property int btnAreaHeight: btnHeight                     // 70
    //--------------------- Button Image Info ##
    property int btnWidth: 206
    property int btnHeight: 70
    //--------------------- Button Text Info ##
    property int btnTextX: 0
    property int btnTextY: 36
    property int btnTextSize: 30
    property string btnTextName: systemInfo.hdb
    property string btnTextAlies: "Center"

    //--------------------- Image Path Info #
    property string imgFolderPopup : imageInfo.imgFolderPopup

    //--------------------- Set action of Button
    function btnClickEvent(index){
        switch(index){
        case 0:{
            idMMsgPopup.btn0Click();
            break;
        } // End case
        case 1:{
            idMMsgPopup.btn1Click();
            break;
        } // End case
        case 2:{
            idMMsgPopup.btn2Click();
            break;
        } // End case
        case 3:{
            idMMsgPopup.btn3Click();
            break;
        } // End case
        default:
            console.log(" # Can't have ClickEvent !")
            break;
        } // End switch
    } // End function

    //--------------------- Set Y of messge text
    function setMsgTextY(){
        if(listMsgPopup.count==1) msgTextY = 236-msgTextSize/2
        else if(listMsgPopup.count==2) msgTextY = 208-msgTextSize/2
        else if(listMsgPopup.count==3) msgTextY = 173-msgTextSize/2
        //console.log(" # Exec function setMsgTextY(), msgTextY : ",msgTextY)
    } // End function

    //--------------------- Set Wdith of button area
    function setBtnAreaWidth(){
        btnAreaWidth = btnWidth*listBtnPopup.count
        //console.log(" # Exec function setBtnAreaWidth(), btnAreaWidth : ",btnAreaWidth)
        setBtnAreaX(btnAreaWidth)
        //setBtnWdith(btnAreaWidth)
    } // End function

    //--------------------- Set X of button area
    function setBtnAreaX(btnAreaWidth){
        btnAreaX = (popupWidth-btnAreaWidth)/2
        //console.log(" # Exec function setBtnAreaX(), btnAreaX : ",btnAreaX)
    } // End function

    //--------------------- Under Screen Disable
    MouseArea{ anchors.fill: parent }
    //--------------------- Background Black 70%
    Rectangle{
        id:bgDim
        x: 0; y: parent.y
        width: systemInfo.lcdWidth
        height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    //--------------------- visible/focus change #
    onVisibleChanged: { if(visible) idMMsgPopup.focus = true }
    onFocusChanged: { console.log(" ==>idMMsgPopup focus: "+ idMMsgPopup.focus) }

    //--------------------- MsgPopup #
    Item {
        id: idPopup
        x: popupX; y: popupY; z:1
        width: popupWidth; height: popupHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        //--------------------- Background Image ##
        Image{
            id: imgBg
            width: popupWidth ; height: popupHeight
            source: imgFolderPopup + "popup_d_bg.png"
        } // End Image

        //--------------------- Title Text ##
        MText{
            id: txtTitle
            mText: titleText
            mTextX: titleTextX; mTextY: titleTextY
            mTextWidth: titleTextWdith; mTextHeight: titleTextHeight
            mTextColor: colorInfo.subTextGrey
            mTextStyle: titleTextName
            mTextSize: titleTextSize
            mTextAlies: titleTextAlies
        } // End MText

        //--------------------- Message ListView ##
        Item{
            id: idListMsgPopup
            x: msgTextX; y: msgTextY
            width: msgTextWidth; height: msgTextHeight

            ListView {
                id: listMsgPopup
                width: msgTextWidth
                anchors.fill: parent;
                model: msgModel
                delegate: MMsgPopupMsgDelegate{}
                orientation : ListView.Vertical
                snapMode: ListView.SnapToItem
                boundsBehavior: Flickable.StopAtBounds
                anchors.verticalCenter: parent.verticalCenter
                Component.onCompleted: {
                    setMsgTextY()
                    //console.log(" # listMsgPopup.count : "+listMsgPopup.count)
                }
            }
        } // End Item
        MouseArea{
            anchors.fill: parent
            onClicked: {
                 idMMsgPopup.dlgBGClick()
                console.log("Click Back ground")
            }
        }
        //--------------------- Button ListView ##
        Item{
            id: idBtnPopup
            x: btnAreaX; y: btnAreaY
            width: btnAreaWidth; height: btnAreaHeight

            ListView {
                id: listBtnPopup
                width: btnWidth ; height: btnAreaHeight
                focus: true
                anchors.fill: parent;
                model: btnModel
                delegate: MMsgPopupBtnDelegate{}
                orientation : ListView.Horizontal
                snapMode: ListView.SnapToItem
                boundsBehavior: Flickable.StopAtBounds

                Component.onCompleted: {
                    setBtnAreaWidth()
                    //console.log(" # listBtnPopup.count : "+listBtnPopup.count)
                }
            } // End ListView
        } // End Item
    } // End Item
} // End FocusScope
