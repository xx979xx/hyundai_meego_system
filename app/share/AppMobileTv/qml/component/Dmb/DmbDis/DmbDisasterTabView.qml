import Qt 4.7
import "../../QML/DH" as MComp

MComp.MComponent {
    id: idDmbDisasterTabView
    property QtObject dispInfoTapListView : idDmbDisasterTabListView
    width: 267; height: systemInfo.contentAreaHeight

    function setModelString(){
        for(var i = 0; i < idDmbDisasterTabListView.count; i++)
        {
            //console.log("["+i+"]:" + idDmbDisasterTabListView.model.get(i).name);
            switch(i){
            case 0:{
                idDmbDisasterTabListView.model.get(i).name = stringInfo.strDmbDis_Tab_SortType_Time
                break;
            }
            case 1:{
                idDmbDisasterTabListView.model.get(i).name = stringInfo.strDmbDis_Tab_SortType_Area
                break;
            }
            case 2:{
                idDmbDisasterTabListView.model.get(i).name = stringInfo.strDmbDis_Tab_SortType_Priority
                break;
            }
            default:
                break;
            }
        }
    }

    Image {
        source: imgFolderMusic + "music_tab_bg.png"
    }

    ListView {
        id:idDmbDisasterTabListView
        opacity : 1
        clip: true
        focus: true
        anchors.fill: parent;
        boundsBehavior: Flickable.StopAtBounds
        model: ListModel {
            ListElement { name: "By Time" }
            ListElement { name: "By Area" }
            ListElement { name: "By Priority" }
        }

        delegate: DmbDisasterTabDelegate {}
        orientation : ListView.Vertical
        highlightMoveSpeed: 9999999

        Keys.onPressed: {
            if(idAppMain.inputMode == "touch") return;

            if(idAppMain.isWheelLeft(event)){
                if(idDmbDisasterTabListView.count == 0) return;

                if(idDmbDisasterTabListView.currentIndex == 0) return;

                if( idDmbDisasterTabListView.currentIndex ){
                    idDmbDisasterTabListView.decrementCurrentIndex();
                }else{
                    idDmbDisasterTabListView.positionViewAtIndex(idDmbDisasterTabListView.count-1, ListView.Visible);
                    idDmbDisasterTabListView.currentIndex = idDmbDisasterTabListView.count-1;
                } // End if
            }else if(idAppMain.isWheelRight(event)) {
                if(idDmbDisasterTabListView.count == 0) return;

                if(idDmbDisasterTabListView.currentIndex == idDmbDisasterTabListView.count-1) return;

                if( idDmbDisasterTabListView.count-1 != idDmbDisasterTabListView.currentIndex ){
                    idDmbDisasterTabListView.incrementCurrentIndex();
                }else{
                    idDmbDisasterTabListView.positionViewAtIndex(0, ListView.Visible);
                    idDmbDisasterTabListView.currentIndex = 0;
                } // End if
            } // End if
        }
    } // End ListView

    // Loading Completed!!
    Component.onCompleted: {  setModelString() }
    onVisibleChanged: { setModelString() }

    onActiveFocusChanged: {
        if(idDmbDisasterTabView.activeFocus == true)
            idDmbDisasterMain.disasterMainLastFocusId = "idDmbDisasterTabView";
    }

    function getFocusLastPosition()
    {
        if(idDmbDisasterTabListView.currentIndex == 0){
            return "button1";
        }else if(idDmbDisasterTabListView.currentIndex == 1){
            return "button2";
        }else if(idDmbDisasterTabListView.currentIndex == 2){
            return "button3";
        }
        return ""
    }

    function syncLastFocusPosition(lastPosion)
    {
        switch(lastPosion)
        {
            case "button1" : { idDmbDisasterTabListView.currentIndex = 0; break; }
            case "button2" : { idDmbDisasterTabListView.currentIndex = 1; break; }
            case "button3" : { idDmbDisasterTabListView.currentIndex = 2; break; }
            default:
            {
                idDmbDisasterTabListView.currentIndex = 0;
                break;
            }
        }
    }

    Connections{
        target: EngineListener
        onRetranslateUi: setModelString()
    }

} // End Rectangle
