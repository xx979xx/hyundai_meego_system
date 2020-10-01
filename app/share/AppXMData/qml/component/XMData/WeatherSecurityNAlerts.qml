import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./Menu" as MMenu
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "./ListElement" as XMListElement
import "./Popup" as MPopup
import "./Common" as XMCommon

FocusScope{
    id:container
    width:systemInfo.lcdWidth;
    height:systemInfo.lcdHeight;

    property alias alertsList: idAlertsList

    onVisibleChanged: {
        UIListener.consolMSG("WSA List visible = " + visible);
    }

    Keys.onPressed: {
        if( idAppMain.isMenuKey(event) ) {
            onOptionOnOff();
        }else if(idAppMain.isBackKey(event)){
            console.log("[QML] WeatherAlertsList back=================")
            stopToastPopup();
            gotoBackScreen(false);//CCP
        }
    }

    XMCommon.XMMBand
    {
        id: idMenuBar
        textTitle : stringInfo.sSTR_XMDATA_WSA_TITLE
        contentItem: idCenterFocusScope

        function resetTitle()
        {
            textTitle = stringInfo.sSTR_XMDATA_WSA_TITLE
            subWSATitleFlag = false;
            menuBtnFlag = true;
        }
    }

    //idCenter Focus Scopce: Left Menu, Center List
    // Center Area Under Menu Bar
    FocusScope{
        id: idCenterFocusScope
        focus:true

        x:0; y:0;
        width:  parent.width;
        height: parent.height-y;

        FocusScope{
            id: idMainListFocusScope
            x: 0; y:systemInfo.titleAreaHeight;
            width:systemInfo.lcdWidth;
            height:parent.height-y;
            focus:true
            visible: true

            // Alerts List
            WeatherAlertsList {
                id : idAlertsList
                anchors.fill: parent
                width: parent.width;
                height : systemInfo.lcdHeight-systemInfo.titleAreaHeight;
                focus: true;
            }
            Loader{
                id: idWSADetailLoader
                anchors.fill: parent
                focus: false
                visible: false
                function hide()
                {
                    idAlertsList.doMoveDetailItemRow(weatherDataManager.getIndexByWSADetailUniqKey());
                    idMenuBar.resetTitle();
                    idCenterFocusScope.focus = true;
                    idAlertsList.visible = true;
                    idAlertsList.focus = true;
                    if(idWSADetailLoader.source != "")
                    {
                        idWSADetailLoader.item.visible = false;
                        idWSADetailLoader.visible = false;
                        idWSADetailLoader.focus = false;
                        idWSADetailLoader.source = ""
                    }
                    idAlertsList.reCheckFocusLock();
                    if(idMenuBar.contentItem != null)
                        idMenuBar.contentItem.focus = true;
                    else
                        idCenterFocusScope.KeyNavigation.up.focus = true;
//                    idAlertsList.indexForWSADetailPopup = weatherDataManager.getIndexByWSADetailUniqKey();
                }

                function show(uniqKey)
                {
                    var currentRow = weatherDataManager.setWSADetailUniqKey(uniqKey);
                    idMenuBar.idBandTop.forceActiveFocus();

                    idMenuBar.textTitle = UIListener.getFullNameForMsgType(weatherDataManager.getWSADetailMsgType());
//                    idMenuBar.subWSATitleFlag = true;
//                    idMenuBar.subTitleText = weatherDataManager.getWSADetailStartDate();
                    idMenuBar.menuBtnFlag = false;
                    idAlertsList.visible = false;
                    idWSADetailLoader.source = "WeatherSecurityNAlertsDetail.qml"
                    idWSADetailLoader.item.doLoadData();
                    idWSADetailLoader.visible = true;
                    idWSADetailLoader.item.visible = true;
                    idWSADetailLoader.focus = true;
//                    idAlertsList.indexForWSADetailPopup = currentRow;
                    idWSADetailLoader.item.onCheckFocus();
                }
            }
        }
    }

    Loader{id:idOptionMenu; z: parent.z+1}

    Component{
        id: idOptionMenuForSecurityNAlerts
        MMenu.WeatherSecurityNAlertsOptionMenu{
            onMenuHided: {
                idOptionMenu.focus = false;
//                idCenterFocusScope.focus = true;
//                idMainListFocusScope.forceActiveFocus();
                idAlertsList.reCheckFocusLock();
                if(idMenuBar.contentItem != null)
                    idMenuBar.contentItem.focus = true;
                else
                    idCenterFocusScope.KeyNavigation.up.focus = true;
            }

            onOptionMenuSetPrioritizationLevels:{
                idAlertsList.currentIndexInitDelegate();
                weatherDataManager.setWSAPriorityLevels(levels);
                idAlertsList.initCurrentIndex();
                hideMenu();
//                UIListener.autoTest_athenaSendObject();
            }

            onOptionMenuSetRange: {
                idAlertsList.currentIndexInitDelegate();
                weatherDataManager.setWSARange(ranges);
                idAlertsList.initCurrentIndex();
                hideMenu();
//                UIListener.autoTest_athenaSendObject();
            }

            onOptionMenuSetMarineCoastalZone: {
//                hideMenu();//[ITS 209988]
                weatherDataManager.setWSAZone(onoff);
                UIListener.autoTest_athenaSendObject();
            }

            onOptionMenuShowPopup: {
//                hideMenu();//[ITS 209988]
                weatherDataManager.setWSAPopupEnable(onoff);
            }
        }
    }

    function onOptionOnOff()
    {
        if(idWSADetailLoader.visible) return;

        idCenterFocusScope.focus = false;
        idOptionMenu.focus = true;
        idOptionMenu.sourceComponent = idOptionMenuForSecurityNAlerts;
        idOptionMenu.item.showMenu();
    }

    function onBack()
    {
        if(idWSADetailLoader.visible){
            idWSADetailLoader.hide();
            return false;
        }
        return true;
    }

    function upFocusAndLock(isLock)
    {
        console.log("============== idCenterFocusScope.visible = " + idCenterFocusScope.visible + " , idOptionMenu,visible = " + idOptionMenu.focus)
        if(isLock == true)
        {
            if(idCenterFocusScope.visible && !idOptionMenu.focus)
                idCenterFocusScope.KeyNavigation.up.forceActiveFocus();
            if(idMenuBar.contentItem != null)
            {
                idMenuBar.contentItem.KeyNavigation.up.KeyNavigation.down = null;
                idMenuBar.contentItem = null;
            }
        }
        else
        {
            if((idWSADetailLoader.visible != true && idOptionMenu.focus == false) || (idWSADetailLoader.visible == true && idWSADetailLoader.item.getInteractive()) ){
                idMenuBar.contentItem = idCenterFocusScope;
                if(idMenuBar.contentItem.KeyNavigation.up.KeyNavigation.down == null)
                {
                    idMenuBar.contentItem.focus = true;
                }
                idMenuBar.contentItem.KeyNavigation.up.KeyNavigation.down = idCenterFocusScope;
            }
        }
    }

    function getAfterTrimGarbage(msg)
    {
        var lastIndex = msg.lastIndexOf(". ");
        var content = msg;
            if(lastIndex > 0)
                content = msg.substring(0,lastIndex+1);
        return content;

//        var content = msg.split("\n");
//        if(content[0].indexOf("/") != content[0].lastIndexOf("/"))
//        {
//            content = content[0].split("/");
//        }
//        return content[0]
    }

    function showWSADetail(uniqKey)
    {
        idWSADetailLoader.show(uniqKey);
    }

    function loadWSAPopupDetail()
    {
        var uniqKey = weatherDataManager.doLoadDetailPopupWSA();
        return uniqKey;
    }

    function hideWSADetail()
    {
        idWSADetailLoader.hide();
    }

    function checkFocusOfMovementEnd()
    {
        checkFocusOfScreen();
    }

    function checkFocusOfScreen()
    {
        if(idMenuBar.contentItem == null)
            return;
        if((idCenterFocusScope.visible == true) && (idMenuBar.contentItem.KeyNavigation.up.activeFocus == true)){
            idCenterFocusScope.focus = true;
            idMainListFocusScope.focus = true;
            idAlertsList.focus = true;
        }
    }

    MPopup.Case_D_DeleteAllQuestion{
        id:idDeleteAllQuestion
        visible : false;
        text: stringInfo.sSTR_XMDATA_DELETE_ALL_MESSAGE
        property string targetId;
        property QtObject target;
        onClose: {
            hide();
        }
        onButton1Clicked: {
            //Delete All?
            hide();
            weatherDataManager.deleteAllWSAList();
            showDeletedSuccessfully();
            close();
            onBack();
        }
        function show(){
            idCenterFocusScope.focus = false;
            idDeleteAllQuestion.visible = true;
            idDeleteAllQuestion.focus = true;
        }
        function hide(){
            idDeleteAllQuestion.visible = false;
            idDeleteAllQuestion.focus = false;
            idCenterFocusScope.focus = true;
            idCenterFocusScope.forceActiveFocus();
        }
    }


    //Debuging........
    Text {
        x:5; y:12; id:idFileName
        text:"WeatherSecurityNAlerts.qml";
        color : "white";
        visible:isDebugMode()
    }
    Rectangle{
        id:idDebugInfoView
        z:200
        visible:isDebugMode()
        Column{
            id:idDebugInfo1
            x: 600
            y: 0
//            Text{text: "[QML Infomation]"; color: "yellow"; }
//            Text{text: "container Focus : " + container.focus; color: "white"; }
//            Text{text: "-idCenterFocusScope Focus : " + idCenterFocusScope.focus; color: "white"; }
//            Text{text: "-idMenuAndList_FocusScope Focus : " + idMenuAndList_FocusScope.focus; color: "white";}
//            Text{text: "-idLeftMenuFocusScope Focus : " + idLeftMenuFocusScope.focus; color: "white"; }
//            Text{text: "-idMainListFocusScope Focus : " + idMainListFocusScope.focus; color: "white"; }
//            Text{text: "-idAddFavorite Focus : " + idAddFavorite.focus; color: "white"; }
//            Text{text: "-idDeleteFavorite Focus : " + idDeleteFavorite.focus; color: "white"; }
//            Text{text: "-idChangeRow Focus : " + idChangeRow.focus; color: "white"; }
        }
        Column{
            id:idDebugInfo2
            x: 400
            y: 0
            Text{text: "[QML Variable Infomation]"; color: "yellow"; }
//            Text{text: "szMode : " + szMode; color: "white"; }
        }
//        Text{x: 0;y:50; text: "[menu]"; font.pixelSize: 20; color: "white";  MouseArea{anchors.fill: parent;onClicked: {onMenu();}}}
//        Text{x: 0;y:70; text: "[popup]"; font.pixelSize: 20; color: "white";  MouseArea{anchors.fill: parent;onClicked: {showNotImplementedYet();}}}
    }
}//container
