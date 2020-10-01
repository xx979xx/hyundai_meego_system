/**
 * FileName: DABInfoEPGMainLeft.qml
 * Author: DaeHyungE
 * Time: 2013-01-25
 *
 * - 2012-01-25 Initial Crated by HyungE
 */

import Qt 4.7
import "../../QML/DH" as MComp

MComp.MComponent {
    id : idDabInfoEPGMainLeft
    property string selectedEnsembleName : "";
    property string selectedServiceName  : "";
    property int overContentCount: 0
    property int screenListCount: 6

    signal epgClear();

    Connections {
        target: DABListener
        onReceiveServiceNameForEPG:{
            console.log("[QML] ==> Connections : DABInfoEPGMainLeft.qml : onReceiveServiceNameForEPG : serviceName = " + serviceName + " ensembleName = " + ensembleName);
            idServiceNameListModel.append({"serviceName":serviceName, "ensembleName":ensembleName})
            if(serviceName == m_sServiceName)
            {
                leftSelectedIndex = ensembleNameCount
                idServiceNameList.currentIndex = ensembleNameCount
            }
            ensembleNameCount++;
        }
    }

    function showEPGList(ensembleName, serviceName)
    {
        console.log("[QML] DABInfoEPGMainLeft.qml : showEPGList : EnsembleName " +  ensembleName + "  serviceName = " + serviceName)
        stopEPGChannelTimer();
        DABListener.getEPGDataList(m_xCurrentDate, ensembleName, serviceName);
    }

    MComp.MListView {
        id: idServiceNameList
        cacheBuffer: idServiceNameList.count - screenListCount
        x: 34; y: 6;
        width : 547
        height : 89 * screenListCount
        clip : true
        focus : true
       // boundsBehavior: (idServiceNameList.count < 6) ? Flickable.StopAtBounds : Flickable.DragAndOvershootBounds
        model : idServiceNameListModel
        delegate : idServiceNameListDelegateComponent
        highlightMoveSpeed : 9999999
        orientation : ListView.Vertical
        onContentYChanged:{
            overContentCount = contentY/(contentHeight/count)
        }
        onUpKeyLongPressedIsFalse: {
            //#****************************** Changed right screen when listItem moved (Long Up Released)
            leftSelectedIndex = idServiceNameList.currentIndex
            screenChangedListMove();
        }
        onDownKeyLongPressedIsFalse: {
            //#****************************** Changed right screen when listItem moved (Long Down Released)
            leftSelectedIndex = idServiceNameList.currentIndex
            screenChangedListMove();
        }

        onMovementEnded: {
            if(idAppMain.state == "DabInfoEPGMain"){
                leftSelectedIndex = idServiceNameList.currentIndex
                idDabInfoEPGMainLeft.screenChangedListMove()

                idDabInfoEPGBand.focus = false;
                idDabInfoEPGMainRight.focus = false;
                idDabInfoEPGMainLeft.focus = true;
            }
        }
    }

    function listCountZeroCheck(){
        if(idServiceNameList.count == 0) return true;
        else return false;
    }

    MComp.MRoundScroll{
        x: 582
        y: 196 - systemInfo.headlineHeight
        scrollWidth: 46
        scrollHeight: 491
        scrollBgImage: idServiceNameList.count > screenListCount ? imageInfo.imgBgScroll_Menu : ""
        scrollBarImage: idServiceNameList.count > screenListCount ? imageInfo.imgScroll_Menu : ""
        listCountOfScreen: screenListCount
        moveBarPosition: idServiceNameList.height/idServiceNameList.count*overContentCount
        listCount: idServiceNameList.count
        visible: (idServiceNameList.count > screenListCount)
    }

    Component{
        id:idServiceNameListDelegateComponent
        MComp.MButton {
            id : idServiceNameListDelegate
            width : 547
            height : 89
            bgImagePress : imageInfo.imgBgMenu_Tab_L_P
            bgImageFocus : imageInfo.imgBgMenu_Tab_L_F
            active : (index == leftSelectedIndex)? true : false
            firstText : serviceName
            firstTextX : 23
            firstTextY : 45
            firstTextWidth : 479
            firstTextSize : 40
            firstTextStyle : ((index == leftSelectedIndex) && (idServiceNameListDelegate.activeFocus == false)) ? idAppMain.fonts_HDB : idAppMain.fonts_HDR
            firstTextAlies: "Left"
            firstTextColor : colorInfo.brightGrey
            firstTextSelectedColor: focusImageVisible? colorInfo.brightGrey : "#7CBDFF" //# RGB(124, 189, 255)
            firstTextPressColor: colorInfo.brightGrey
            firstTextFocusColor: colorInfo.brightGrey
            firstTextScrollEnable:  (m_bIsDrivingRegulation == false) && (idServiceNameListDelegate.activeFocus) ? true : false
            lineImage: imageInfo.imgLineMenuList
            lineImageX: 9
            lineImageY: 90

            onClickOrKeySelected : {
                idServiceNameList.currentIndex = index
                leftSelectedIndex = index
                idDabInfoEPGMainLeft.focus = true
                idServiceNameList.focus = true;
                epgClear();
                showEPGList(ensembleName, serviceName);
                idDabInfoEPGMainRight.focus = true;
            }

            onBackKeyPressed: {
                console.log("[QML] DABInfoEPGMainLeft.qml : onBackKeyPressed ");
                stopEPGChannelTimer();
                gotoBackScreen();
            }

            onWheelLeftKeyPressed:{
                console.log("[QML] DABInfoEPGMainLeft.qml : onWheelLeftKeyPressed : index = " + idServiceNameListDelegate.ListView.view.currentIndex + " count = " + idServiceNameListDelegate.ListView.view.count);
                idDabInfoEPGMainLeft.listLeftPageMovement();
                if( idServiceNameListDelegate.ListView.view.currentIndex )
                {
                    idServiceNameListDelegate.ListView.view.decrementCurrentIndex();
                }
                else
                {
                    if(idServiceNameList.count > screenListCount){
                        idServiceNameListDelegate.ListView.view.positionViewAtIndex(idServiceNameListDelegate.ListView.view.count-1, idServiceNameListDelegate.ListView.view.Visible);
                        idServiceNameListDelegate.ListView.view.currentIndex = idServiceNameListDelegate.ListView.view.count-1;
                    }
                }
                leftSelectedIndex = idServiceNameList.currentIndex
                changeEPGChannelTimer.restart();
            }

            onWheelRightKeyPressed: {
                console.log("[QML] DABInfoEPGMainLeft.qml : onWheelRightKeyPressed : index = " + idServiceNameListDelegate.ListView.view.currentIndex + " count = " + idServiceNameListDelegate.ListView.view.count);

                idDabInfoEPGMainLeft.listRightPageMovement();
                if( idServiceNameListDelegate.ListView.view.count-1 != idServiceNameListDelegate.ListView.view.currentIndex )
                {
                    idServiceNameListDelegate.ListView.view.incrementCurrentIndex();
                }
                else
                {
                    if(idServiceNameList.count > screenListCount){
                        idServiceNameListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                        idServiceNameListDelegate.ListView.view.currentIndex = 0;
                    }
                }
                leftSelectedIndex = idServiceNameList.currentIndex
                changeEPGChannelTimer.restart();
            }

            Keys.onUpPressed: { // Set focus for Band
                event.accepted = true;
                return;
            } // End onUpPressed
            Keys.onDownPressed:{ // No Movement
                event.accepted = true;
                return;
            } // End onDownPressed

            onUpKeyReleased: {
                if(idAppMain.upKeyReleased == true){
                    idDabInfoEPGBand.focus = true
                }
                idAppMain.upKeyReleased  = false;
            }          
        }
    }

    function screenChangedListMove(){
//        leftSelectedIndex = idServiceNameList.currentIndex
        var ensembleName = idServiceNameListModel.get(leftSelectedIndex).ensembleName
        var serviceName = idServiceNameListModel.get(leftSelectedIndex).serviceName
        epgClear();
        showEPGList(ensembleName, serviceName);
    }

    function listLeftPageMovement(){
        //# Start item check of ListView
        var startIndex = idServiceNameList.getStartIndex(idServiceNameList.contentY);
        if(startIndex == idServiceNameList.currentIndex){
            if(startIndex < screenListCount){
                idServiceNameList.positionViewAtIndex(screenListCount-1, ListView.End);
            }
            else{
                idServiceNameList.positionViewAtIndex(idServiceNameList.currentIndex-1, ListView.End);
            }
        }
    }

    function listRightPageMovement(){
        //# End item check of ListView
        var endIndex = idServiceNameList.getEndIndex(idServiceNameList.contentY);
        if(endIndex == idServiceNameList.currentIndex){
            if((endIndex + screenListCount) < idServiceNameList.count){
                idServiceNameList.positionViewAtIndex(idServiceNameList.count-1, ListView.End);
            }
            else{
                idServiceNameList.positionViewAtIndex(idServiceNameList.currentIndex+1, ListView.Beginning);
            }
        }
    }
}
