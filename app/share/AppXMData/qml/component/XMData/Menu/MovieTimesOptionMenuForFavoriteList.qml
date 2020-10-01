/**
 * FileName: MovieTimesOptionMenuForFavoriteList.qml
 * Author: David.Bae
 * Time: 2012-05-11 17:32
 *
 * - 2012-05-11 Initial Crated by David
 */

import Qt 4.7

import "../../QML/DH" as MComp


FocusScope{
    id:container
    z: parent.z + 1

    property alias optionMenu: idMenu
    property bool menuForDelete: false;


    signal optionMenuSearch();
    signal optionMenuDelete();
    signal optionMenuCancelDelete();
    signal menuHided();

    property bool checkDRSStatus: idAppMain.isDRSChange

    Keys.onPressed: {
        if(idAppMain.isMenuKey(event)){
            console.log("[QML] MovieTimesOptionMenuForFavoriteList.qml Menu Key Pressed")
            allHideMenu();//[ITS 187042]
            event.accepted = true;
        }else if(idAppMain.isBackKey(event)){
            console.log("[QML] MovieTimesOptionMenuForFavoriteList.qml Back Key Pressed")
                hideMenu();
            event.accepted = true;
        }else{
            console.log("[QML] MovieTimesOptionMenuForFavoriteList.qml Key Pressed")
        }
    }
    function showMenu()
    {
        container.focus = true;
        idMenu.showMenu();
    }
    function hideMenu()
    {
        if(!container.focus){return}
            idMenu.hideMenu();
            menuHided();
        }

    function allHideMenu()
    {
        if(!container.focus){return}
        idMenu.hideMenu();
        menuHided();
    }

    function setModelString(){
        idOptionMenuModelForOneDepth.get(0).name = stringInfo.sSTR_XMDATA_ADDFAVORITE
        idOptionMenuModelForOneDepth.get(1).name = stringInfo.sSTR_XMDATA_DELETE
        idOptionMenuModelForDelete.get(0).name = stringInfo.sSTR_XMDATA_CANCEL_DELETE;
    }

    MComp.MOptionMenu{
        id:idMenu
        x:0;y:0
        linkedModels: menuForDelete ? idOptionMenuModelForDelete : idOptionMenuModelForOneDepth
        onMenu0Click: {
            if(menuForDelete)
            {
                container.hideMenu()
                optionMenuCancelDelete();
            }else
            {
                container.hideMenu();
                optionMenuSearch();
            }
        }
        onMenu1Click: {
            container.hideMenu();
            optionMenuDelete();
        }
        onOptionMenuFinished: {
            container.allHideMenu();
        }
    }
    ListModel {
        id: idOptionMenuModelForOneDepth
        ListElement{name: "Add Favorite"; opType: ""}
        ListElement{name: "Delete"; opType: ""}
    }
    ListModel {
        id: idOptionMenuModelForDelete
        ListElement{name: "Cancel Delete"; opType: ""}
    }



    Component.onCompleted:{

        setModelString()


    }

    Connections{
        target: UIListener
        onRetranslateUi: setModelString()
    }
    //Debug Information
    Text {
        x:idMenu.x+5; y:idMenu.x+12+10; id:idFileName
        text:"MovieTimesOptionMenuForFavoriteList.qml";
        color : "white";
        visible:isDebugMode();
    }

    onCheckDRSStatusChanged: {
        if(checkDRSStatus == true && (idMenu.visible))
        {
            container.hideMenu();
        }
    }
}
