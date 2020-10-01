import Qt 4.7

// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "../QML/DH" as MComp
import "./ListElement" as XMListElement
import "./Popup" as MPopup
import "./Javascript/Definition.js" as MDefinition

//Item {
FocusScope{
    id:container
    x:0
    y:0
    property string szListMode : "full"
    property string szFavListMode : "none"
    property alias listitem : idMovieTheaterList

    onVisibleChanged: {
        if(visible){
            idMenuBar.menuBtnFlag = true;
            container.focus = true;
            idMovieTheaterList.forceActiveFocus();
            console.log("Theater List Visible:" + visible + ", focus:"+focus)
        }
    }

    Component{
        id: idMovieTimesListDelegate
        XMDelegate.XMMovieTimesTheaterListDelegate {
            width: idMovieTheaterList.width-20;
            selectedIndex: idMovieTheaterList.selectedIndex;
            onGoButtonClicked: {
                console.log(" GO: "+index+ ", entryID:" + entryID + ", name:" + name + ", addr:" + address + ", phoneNumber:"+phonenumber+", latitude:"+latitude+", longitude:"+longitude);
                checkSDPopup(index, entryID, name, address, phonenumber, latitude, longitude, statename, city, street, zipcode, amenityseating, amenityrocker);
            }
        }
    }

    XMList.XMDataNormalList {
        id: idMovieTheaterList
        x: 0;
        y: 0;
        width: parent.width;
        height: parent.height
        focus: true
        listModel: theaterListByMovie
        listDelegate: idMovieTimesListDelegate
        selectedIndex: -1;

        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_NO_THEATER

        Connections{
            target: movieTimesDataManager
            onCheckForFocus:{
                if(idMovieTheaterList.visible == true)
                {
                    if(idMovieTheaterList.count == 0)
                    {
                        idMenuBar.contentItem.KeyNavigation.up.forceActiveFocus();
                        idMenuBar.contentItem.KeyNavigation.up.KeyNavigation.down = null;
                        idMenuBar.checkIsDownFocus = false;
                    }else{
                        idMenuBar.contentItem.forceActiveFocus();
                        idMovieTheaterList.listView.positionViewAtIndex(0, ListView.Visible);
                        idMovieTheaterList.listView.currentIndex = 0;
                        idMenuBar.contentItem.KeyNavigation.up.KeyNavigation.down = idMenuBar.contentItem;
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
    }

    function doCheckEnableMenuBtn(){
        if(visible)
            idMenuBar.enableMenuBtn = idMovieTheaterList.count == 0 ? false : true;
    }

    function currentIndexInitDelegate(){
        idMovieTheaterList.listView.currentIndex = -1;
    }

    Text {
        x:5; y:12; id:idFileName
        text:"MovieTimesTheaterList.qml";
        color : "white";
        visible:isDebugMode()
        MouseArea{
            anchors.fill: parent
            onClicked: {
                console.log("idMovieTheaterList x,y,width,height:"+idMovieTheaterList.x + ", " + idMovieTheaterList.y+ ","+ idMovieTheaterList.width+","+idMovieTheaterList.height)
            }
        }
    }
    Rectangle{
        width:parent.width
        height:parent.height
        border.color: "green"
        border.width: 1
        color:"transparent"
        visible:isDebugMode();
    }
}
