/**
 * FileName: DABStationListDelegate.qml
 * Author: DaeHyungE
 * Time: 2012-07-02
 *
 * - 2012-07-02 Initial Crated by HyungE
 * - 2012-11 All modifiey by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent{
    id : idDabStationListDelegate
    width : 1280  
    height : (type == "section") || (type == "sortingBy") ? 90 : 90

    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property int countNum: 1
    property int countMax: 30

    MComp.MButton{
        id: idEnsembleBtn
        x: 0; y: 0
        width: 1280
        height: 90
        bgImage: imageInfo.imgBgListTab_N
        bgImagePress: imageInfo.imgBgListTab_P
        bgImageFocus: imageInfo.imgBgListTab_F
        focus: true
        visible: (type == "section")

        firstText: ensembleName
        firstTextX: 46
        firstTextY: 46
        firstTextWidth: 1111
        firstTextSize: 40
        firstTextStyle: idAppMain.fonts_HDR
        firstTextColor: colorInfo.brightGrey
        firstTextAlies: "Left"

        fgImage: (isLoadServiceName == "open")? imageInfo.imgListArrow_U : imageInfo.imgListArrow_D;
        fgImageX: 1191
        fgImageY: 27
        fgImageWidth: 30
        fgImageHeight: 30

        onPressAndHold: { idStationTimer.stop();  }
        onClickOrKeySelected : {
            idStationTimer.restart();
            console.log("[QML] DABStationListDelegate.qml : onClickOrKeySelected : type = " + type + "  isLoadServiceName = " + isLoadServiceName + " state = " + state + " index = " + index +  " currentIndex = " + idStationListMain.currentIndex);
            if(idAppMain.state == "DabStationList"){
                if(type == "section"){
                    if(isLoadServiceName == "open"){
                        clearServiceNameInEnsemble(ensembleName);
                        idStationListModel.setProperty(index, "isLoadServiceName", "close");
                        idStationListMain.currentIndex = index
                    }else if(isLoadServiceName == "close"){
                        loadServiceList(frequency, false);
                        idStationListModel.setProperty(index, "isLoadServiceName", "open");
                        var endIndex = idStationListMain.getEndIndex(idStationListMain.contentY);
                        if(endIndex == index){
                            idStationListMain.positionViewAtIndex(index, ListView.Beginning);
                        }
                        idStationListMain.currentIndex = index
                    }
                }

            idDabStationListDelegate.focus = true;
            idDabStationListDelegate.forceActiveFocus();
            }
        }

        onTuneEnterKeyPressed : {
            idStationTimer.restart();
            console.log("[QML] DABStationListDelegate.qml : onTuneEnterKeyPressed : type = " + type + "  isLoadServiceName = " + isLoadServiceName + " state = " + state);
            if(type == "section"){
                if(isLoadServiceName == "open"){
                    clearServiceNameInEnsemble(ensembleName);
                    idStationListModel.setProperty(index, "isLoadServiceName", "close");
                    idStationListMain.currentIndex = index
                }else if(isLoadServiceName == "close"){
                    loadServiceList(frequency, false);
                    idStationListModel.setProperty(index, "isLoadServiceName", "open");
                    var endIndex = idStationListMain.getEndIndex(idStationListMain.contentY);
                    if(endIndex == index){
                        idStationListMain.positionViewAtIndex(index, ListView.Beginning);
                    }
                    idStationListMain.currentIndex = index
                }
            }
        }
    }//End endensemble Button

    MComp.MButton{
        id: idServiceBtn
        x: (type == "sortingBy") ? 14 : 32
        y: 0
        width: 1216
        height: 89
        bgImagePress: (type == "sortingBy") ? imageInfo.img_List_P : imageInfo.imgStation_List_P
        bgImageFocus: (type == "sortingBy") ? imageInfo.img_List_F : imageInfo.imgStation_List_F
        focus: (type == "listItem") || (type == "sortingBy")
        visible: (type == "listItem") || (type == "sortingBy")
        active: showFocus && idDabStationListDelegate.activeFocus

        firstText: serviceName
        firstTextX: getServiceNameX(idPlayIconImg.visible, type, ps)
        firstTextY: 46
        firstTextWidth: 621
        firstTextSize: 40
        firstTextStyle: playIcon == false? idAppMain.fonts_HDR : idAppMain.fonts_HDB
        firstTextColor: playIcon == false ? colorInfo.brightGrey : "#7CBDFF"  //# RGB(124, 189, 255)
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: playIcon == false ? colorInfo.brightGrey : focusImageVisible? colorInfo.brightGrey :"#7CBDFF"
        firstTextAlies: "Left"        

        secondText: " " + MDabOperation.getProgramTypeName(pty)
        secondTextX: 827 - parent.x	//127+58+568+74
        secondTextY:  48
        secondTextWidth: 366
        secondTextAlies: "Left"
        secondTextSize: 32
        secondTextStyle: idAppMain.fonts_HDR
        secondTextColor: playIcon == false ? colorInfo.brightGrey : "#7CBDFF"  //# RGB(124, 189, 255)
        secondTextPressColor: colorInfo.brightGrey
        secondTextFocusPressColor: colorInfo.brightGrey
        secondTextSelectedColor: playIcon == false ? colorInfo.brightGrey : focusImageVisible? colorInfo.brightGrey : "#7CBDFF"
        secondTextScrollEnable:  (m_bIsDrivingRegulation == false) && (idServiceBtn.activeFocus) ? true : false
        lineImage: imageInfo.imgListLine
        lineImageX:  0 - parent.x
        lineImageY: 89
        lineImageVisible: (type == "listItem") || (type == "sortingBy")

        Image {
            id : idDABtoFMImg
            x : 48 - parent.x
            source : imageInfo.imgBgTA_N
            anchors.verticalCenter: parent.verticalCenter
            Text {
                id : idFMText
                text : stringInfo.strStation_FM
                font.family : idAppMain.fonts_HDB
                font.pixelSize : 26
                color : idServiceBtn.active? colorInfo.brightGrey : Qt.rgba( 149/255, 153/255, 160/255, 1)
                anchors.verticalCenter : parent.verticalCenter
                anchors.horizontalCenter : parent.horizontalCenter
            }
            visible : ((type == "listItem") || (type == "sortingBy")) && isDABtoFM
        }

        Image {
            id : idDABtoDABImg
            x : 48 - parent.x
            source : imageInfo.imgBgTA_N
            anchors.verticalCenter: parent.verticalCenter
            Text {
                id : idDABText
                text : stringInfo.strStation_DAB
                font.family : idAppMain.fonts_HDB
                font.pixelSize : 26
                color : idServiceBtn.active? colorInfo.brightGrey : Qt.rgba( 149/255, 153/255, 160/255, 1)
                anchors.verticalCenter : parent.verticalCenter
                anchors.horizontalCenter : parent.horizontalCenter
            }
            visible : ((type == "listItem") || (type == "sortingBy")) && isDABtoDAB
        }

        Image {
            id : idNoSignalImg
            x : 48 - parent.x
            source : imageInfo.imgBgTA_Nosignal
            anchors.verticalCenter: parent.verticalCenter
            visible : ((type == "listItem") || (type == "sortingBy")) && playIcon && m_bIsServiceNotAvailable
        }

        Image{
            id: idPlayIconImg
            x: (ps == 0x00) ? 180 - parent.x : 127 - parent.x;
            anchors.verticalCenter: parent.verticalCenter
            source: countNum > 9 ? imgFolderGeneral+"/play/ico_play_"+ countNum +".png" : imgFolderGeneral+"/play/ico_play_0"+ countNum +".png"
            visible: playIcon

            Timer{
                id: idPlayIconTimer
                interval: 100;
                repeat: true
                running: playIcon && (!m_bIsServiceNotAvailable)
                onTriggered: {
                    if(countNum == countMax) countNum = 1
                    countNum++;
                }
            }
        }

        Connections{
            target: idAppMain
            onM_bIsServiceNotAvailableChanged:{
                if(m_bIsServiceNotAvailable){ idPlayIconTimer.stop() }
                else idPlayIconTimer.restart();
            }
        }

        onActiveChanged: {
            if(!idDabStationList.visible){ idPlayIconTimer.stop() }
        }

        onPressAndHold: { idStationTimer.stop(); }
        onClickOrKeySelected : {          
            console.log("[QML] DABStationListDelegate.qml : onClickOrKeySelected : type = " + type + "  isLoadServiceName = " + isLoadServiceName + " state = " + state);
            if(idAppMain.state == "DabStationList"){
                if((type == "listItem")|| (type == "sortingBy")){
                    selectService(listIndex, ensembleName, serviceName, sortingBy);
                }
                idDabStationListDelegate.focus = true;
            }
        }

        onTuneEnterKeyPressed : {
            console.log("[QML] DABStationListDelegate.qml : tuneEnterKeyPressed : type = " + type + "  isLoadServiceName = " + isLoadServiceName + " state = " + state);
            if((type == "listItem")|| (type == "sortingBy")){
                selectService(listIndex, ensembleName, serviceName, sortingBy);
            }
        }
    }

    onTuneRightKeyPressed : {
        console.log("[QML] DABStationListDelegate.qml : tuneRightKeyPressed : index = " + idDabStationListDelegate.ListView.view.currentIndex + " count = " + idDabStationListDelegate.ListView.view.count);
        if(idDabStationList.isMovemented) return;
        idDabStationListView.listRightPageMovement()
         if( idDabStationListDelegate.ListView.view.count-1 != idDabStationListDelegate.ListView.view.currentIndex )
         {
             idDabStationListDelegate.ListView.view.incrementCurrentIndex();
         }
         else
         {
             if(idStationListMain.count > 6){
                 idDabStationListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                 idDabStationListDelegate.ListView.view.currentIndex = 0;
             }
         }
    }

    onTuneLeftKeyPressed : {
        console.log("[QML] DABStationListDelegate.qml : onTuneLeftKeyPressed : index = " + idDabStationListDelegate.ListView.view.currentIndex + " count = " + idDabStationListDelegate.ListView.view.count);
        if(idDabStationList.isMovemented) return;
        idDabStationListView.listLeftPageMovement()
        if( idDabStationListDelegate.ListView.view.currentIndex )
        {
            idDabStationListDelegate.ListView.view.decrementCurrentIndex();
        }
        else
        {
            if(idStationListMain.count > 6){
                idDabStationListDelegate.ListView.view.positionViewAtIndex(idDabStationListDelegate.ListView.view.count-1, idDabStationListDelegate.ListView.view.Visible);
                idDabStationListDelegate.ListView.view.currentIndex = idDabStationListDelegate.ListView.view.count-1;
            }

        }
    }

    onWheelLeftKeyPressed: {
        console.log("[QML] DABStationListDelegate.qml : onWheelLeftKeyPressed : index = " + idDabStationListDelegate.ListView.view.currentIndex + " count = " + idDabStationListDelegate.ListView.view.count);
        if(idDabStationList.isMovemented) return;
        idDabStationListView.listLeftPageMovement()
        if( idDabStationListDelegate.ListView.view.currentIndex )
        {
            idDabStationListDelegate.ListView.view.decrementCurrentIndex();
        }
        else
        {
            if(idStationListMain.count > 6){
                idDabStationListDelegate.ListView.view.positionViewAtIndex(idDabStationListDelegate.ListView.view.count-1, idDabStationListDelegate.ListView.view.Visible);
                idDabStationListDelegate.ListView.view.currentIndex = idDabStationListDelegate.ListView.view.count-1;
            }

        }
    }

    onWheelRightKeyPressed: {
        console.log("[QML] DABStationListDelegate.qml : onWheelRightKeyPressed : index = " + idDabStationListDelegate.ListView.view.currentIndex + " count = " + idDabStationListDelegate.ListView.view.count);
        if(idDabStationList.isMovemented) return;
       idDabStationListView.listRightPageMovement()
        if( idDabStationListDelegate.ListView.view.count-1 != idDabStationListDelegate.ListView.view.currentIndex )
        {
            idDabStationListDelegate.ListView.view.incrementCurrentIndex();
        }
        else
        {
            if(idStationListMain.count > 6){
                idDabStationListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                idDabStationListDelegate.ListView.view.currentIndex = 0;
            }
        }
    }

    Keys.onUpPressed: {
        event.accepted = true;
        return;
    }

    Keys.onDownPressed:{
        event.accepted = true;
        return;
    }

    onUpKeyReleased: {
        if(idAppMain.upKeyReleased == true){
            idDabStationListBand.focus = true
        }
        idAppMain.upKeyReleased  = false;
    }
}
