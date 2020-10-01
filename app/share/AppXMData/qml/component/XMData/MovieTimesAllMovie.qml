import Qt 4.7

// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "../QML/DH" as MComp
import "./ListElement" as XMListElement
import "./Popup" as MPopup
import "./Javascript/Definition.js" as MDefinition

// Because Loader is a focus scope, converted from FocusScope to Item.
//Item {
FocusScope{
    id:container
    width: parent.width;
    height: parent.height;
    property alias list: idMovieTimesList
    property alias listCount: idMovieTimesList.count

    Component{
        id: idMovieTimesListDelegate
        XMDelegate.XMMovieTimesMovieListDelegate {}
    }

    XMList.XMDataNormalList {
        id: idMovieTimesList
        focus: true
        width: parent.width;
        height: parent.height;
        listModel: movieList
        listDelegate: idMovieTimesListDelegate
        selectedIndex : -1;

        Connections{
            target : movieTimesDataManager
            onCheckForFocus:{
                if(idMovieTimesList.visible)
                {
                    if(idMovieTimesList.count == 0)
                    {
                        leftFocusAndLock(true);
                    }else
                    {
                        leftFocusAndLock(false);
                        idMovieTimesList.listView.positionViewAtIndex(0, ListView.Visible);
                        idMovieTimesList.listView.currentIndex = 0;
                        idMovieTimesList.listView.currentItem.focusInfoBtn = false;
                        if(isLeftMenuEvent)
                            idMovieTimesList.forceActiveFocus();
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

        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_NO_MOVIE_DATA
    }
    function doCheckEnableMenuBtn(){
        if(visible && movieTimesDataManager.getNowGrade() == 0)
            idMenuBar.enableMenuBtn = idMovieTimesList.count == 0 ? false : true;
    }


    function selectMovie(movieID, movieName)
    {
        selectMovieTheater(movieID, movieName);
    }

    function currentIndexInitDelegate(){
        idMovieTimesList.listView.currentIndex = -1;
    }

    Text {
        x:5; y:12; id:idFileName
        text:"MovieTimesAllMovie.qml";
        color : "white";
        visible:isDebugMode()
        MouseArea{
            anchors.fill: parent
        }
    }
}
