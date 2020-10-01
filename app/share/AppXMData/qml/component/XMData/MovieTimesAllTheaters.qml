import Qt 4.7

// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "../QML/DH" as MComp
import "./ListElement" as XMListElement
import "./Popup" as MPopup
import "./Javascript/Definition.js" as MDefinition

FocusScope{
    id: idMovieTimesAllTheaters
    property string szListMode : "normal"
    property string szFavListMode : "fav"//[ITS 198764]

//    x: idMovieMain.x+idMovieMain.width;
//    y: idMovieMain.y;
//    width:parent.width - idMovieMain.width
//    height:idMovieMain.height
    property alias listModel: idList.listModel;
    property alias list: idList


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
//            onShowSeeOrAddFav:{
//                idPopupCaseC.setDataAndShow(index, entryID, name, address, phonenumber, latitude, longitude, statename, city, street, zipcode, amenityseating, amenityrocker, locID);
//            }
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
        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_NO_THEATER_INFORMATION

        function keyDown() {
            return idList;
        }

        Connections{
            target : movieTimesDataManager
            onCheckForFocus:{
                if(idList.visible)
                {
                    if(idList.count == 0)
                    {
                        leftFocusAndLock(true);
                    }else
                    {
                        leftFocusAndLock(false);
                        idList.listView.positionViewAtIndex(0, ListView.Visible);
                        idList.listView.currentIndex = 0;
                        idList.listView.currentItem.focusGoBtn = false;
                        if(isLeftMenuEvent)
                            idList.forceActiveFocus();
                    }
                }
            }
        }
        onCountChanged: {
            if(visible)
            {
                doCheckEnableMenuBtn();
            }
        }

        KeyNavigation.down: keyDown();
    }
    function doCheckEnableMenuBtn(){
        if(visible)
            idMenuBar.enableMenuBtn = idList.count == 0 ? false : true;
    }

    Text {
        x:5; y:12; id:idFileName
        text:"MovieTimesAllTheaterList.qml";
        color : "white";
        visible:isDebugMode()
        MouseArea{
            anchors.fill: parent
        }
    }
}
