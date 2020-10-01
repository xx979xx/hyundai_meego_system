import Qt 4.7

import "./Common" as XMCommon
import "./List" as XMList
import "./ListDelegate" as XMDelegate

FocusScope {
    width: parent.width;
    height: parent.height;
    XMCommon.StringInfo { id: stringInfo }

    property alias listModel: idList.listModel
    property alias listCount: idList.count
    property string szListMode : "normal"
    property string szFavListMode : "fav"
    property bool bSeachButtonEnable: true

    Component{
        id: idMovieTimesListDelegate
        XMDelegate.XMMovieTimesTheaterListDelegate {
            width:idList.width;
            selectedIndex: idList.selectedIndex;
            onGoButtonClicked: {
                if(idMovieListFocusScope.focus == false)
                {
                    idMovieListFocusScope.focus = true;
                }
                checkSDPopup(index, entryID, name, address, phonenumber, latitude, longitude, statename, city, street, zipcode, amenityseating, amenityrocker);
            }
        }
    }


    XMList.XMDataNormalList{
        id: idList
        focus: true
        x: 0;
        y: 0;
        width: parent.width;
        height: parent.height
        listDelegate: idMovieTimesListDelegate
        selectedIndex: -1;
        function keyDown() {
            return idList;
        }
        KeyNavigation.down: keyDown();
        noticeWhenListEmpty:  stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITES_THEATERS
        showSearchButtonWhenListEmpty: true
        searchButtonEnable: bSeachButtonEnable

        onCountChanged: {
            if(visible)
            {
                bSeachButtonEnable = true;
                leftFocusAndLock(false);
                doCheckEnableMenuBtn();
                doCheckfocusPosition();
            }
        }

        onVisibleChanged: {
            UIListener.consolMSG("MovieFavorite visible = " + visible + ", idList cnt = " + idList.count + ", Theather cnt = " + movieTimesDataManager.getTheaterListCount());
            if(visible == true)
            {
                if(movieTimesDataManager.getTheaterListCount() == 0)
                {
                    bSeachButtonEnable = false;
                }
                else
                {
                    bSeachButtonEnable = true;
                }
                if(isToastPopupVisible() == false)
                {
                    doCheckfocusPosition();
                }
            }
            doCheckEnableMenuBtn();
        }

        Connections{
            target : movieTimesDataManager
            onCheckForFocus:{
                if(idList.visible)
                {
                    console.log("====== isLeftMenuEvent : = " + isLeftMenuEvent + ", favorite count = " + idList.count + ", theaterList count = " + movieTimesDataManager.getTheaterListCount())
                    if(isLeftMenuEvent && idList.count > 0)
                    {
                        leftFocusAndLock(false);
                        idList.listView.positionViewAtIndex(0, ListView.Visible);
                        idList.listView.currentIndex = 0;
                        idList.listView.currentItem.focusGoBtn = false;
                    }
                    if(checkDRSStatus == false)
                    {
                        idList.forceActiveFocus();
                    }
                    else
                    {
                        idList.focus = true;
                    }
                }
            }
            onMenuMovieForFav:{
                if(visible)
                {
                    bSeachButtonEnable = true;
                    leftFocusAndLock(false);
                    doCheckEnableMenuBtn();
                    doCheckfocusPosition();
                }
            }
        }

        onSearchButton: {
            idAddFavorite.show();
        }
    }

    function doCheckEnableMenuBtn(){
        if(visible)
        {
            console.log("[QML] MovieTimesMyFavorites.qml ::onVisibleChanged ::  TheaterList count = " + movieTimesDataManager.getTheaterListCount())
            if(idList.count == 0 && movieTimesDataManager.getTheaterListCount() == 0)
            {
                idMenuBar.enableMenuBtn = false;
            }
            else
            {
                idMenuBar.enableMenuBtn = true;
            }
        }
//            idMenuBar.enableMenuBtn = idList.count == 0 ? false : true;
    }

    function doCheckfocusPosition()
    {
        if(idList.count == 0 && movieTimesDataManager.getTheaterListCount() == 0)
        {
            leftFocusAndLock(true);
        }
        else
        {
            leftFocusAndLock(false);
            if(idList.count > 0)
            {
                movieTimesDataManager.checkForFocusForElement(true); // ITS 0254843
            }
            else
            {
                movieTimesDataManager.checkForFocusForElement(false);
            }
        }
    }

    Connections{
        target : idAppMain
        onToastPopupClose:{
            if(visible)
            {
                UIListener.consolMSG("MovieFavorites onToastPopupClose");
                if(isToastPopupVisible() == false)
                {
                    doCheckfocusPosition();
                }
            }
        }
    }

    Text {
        x:5; y:12; id:idFileName
        text:"MovieTimesMyfavorites.qml";
        color : "white";
        visible:isDebugMode()
        MouseArea{
            anchors.fill: parent
        }
    }
}
