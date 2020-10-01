import Qt 4.7
import "../../QML/DH" as MComp
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

MComp.MComponent {
    id: idDmbENGModeListView
    x: 0; y: 0
    width: 521; height: 534

    property int selectedItem: CommParser.m_iPresetListIndex  // currentIndex when clicked
    property int overContentCount;
    //property int selectedIndex: CommParser.m_sCurrentChIndex//CommParser.m_iPresetListIndex  // currentIndex when clicked

    function isLargeViewMode()
    {
        return viewMode == "big";
    }
    function isTouchMode()
    {
        //return idAppMain.isTouchMode();
        if(inputMode == "jog")
            return false
        else
            return true // "touch" or "tuneFocus"
    }
    function getListBtImgSource()
    {
        if(isLargeViewMode()){
            return isTouchMode()?imageInfo.imgBgPreset02:imageInfo.imgBgPreset03
        }else if(!isLargeViewMode()){
            return isTouchMode()?imageInfo.imgBgPreset01:imageInfo.imgBgPreset_Jog
        }
    }
    function getListWidth()
    {
        if(isLargeViewMode()){
            return isTouchMode()?389:422
        }else if(!isLargeViewMode()){
            return isTouchMode()?(240-17):250
        }
        //console.log("imageInfo.imgBgPreset_Jog:" + imageInfo.imgBgPreset_Jog);
    }

    //****************************** # ChannelList Background Image #
    Image{
        anchors.verticalCenter: parent.verticalCenter
	source: imgFolderGeneral+"bg_ch_l_s.png"
    }

    //****************************** # ChannelList ListView #
    MComp.MListView{
        id: idDmbENGModeList
        clip: true
        focus: true
        anchors.fill: parent;
        orientation: ListView.Vertical
        highlightMoveSpeed: 99999
        snapMode: ListView.SnapToItem
        //boundsBehavior:Flickable.StopAtBounds
        cacheBuffer: 99999

        model:DmbChannelModel1
        delegate: ENGModeDelegate{}

        // for RoundScroll
        onContentYChanged: overContentCount = contentY/(contentHeight/count)



        Component.onCompleted:{
//            console.log("!!!!!!!!!!!!!!!  [ENGMode Listview] m_iPresetListIndex :" + CommParser.m_iPresetListIndex)
            if(idDmbENGModeList.count > 0) {
                idDmbENGModeList.currentIndex = CommParser.m_iPresetListIndex
                idDmbENGModeList.positionViewAtIndex (CommParser.m_iPresetListIndex, ListView.Center)
            }
        }

        onVisibleChanged: {
//            console.log("!!!!!!!!!!!!!!!  [ENGMode Listview] onVisibleChanged : m_iPresetListIndex :" + CommParser.m_iPresetListIndex)
            if(idDmbENGModeList.count > 0) {
                idDmbENGModeList.currentIndex = CommParser.m_iPresetListIndex
                idDmbENGModeList.positionViewAtIndex (CommParser.m_iPresetListIndex, ListView.Center)
            }
        }
        // WSH(130122) ====================== START
        onFocusChanged: {
            if(focus){
                if(idDmbENGModeList.count > 0) {
                    idDmbENGModeList.positionViewAtIndex (CommParser.m_iPresetListIndex, ListView.Visible)
                } // End If
            } // End If
        }
	// WSH(130122) ====================== END

    }// End ListView

    //************************ Round Scroll ***//
    MComp.MRoundScroll{
        id: idMRoundScroll
        x: 463; y: 198-systemInfo.upperAreaHeight
        moveBarPosition: idDmbENGModeList.height/idDmbENGModeList.count*overContentCount
        listCount: idDmbENGModeList.count
        visible: idDmbENGModeList.count > 6
    }

    Connections{
        target: CommParser

        onPresetListIndexChanged:{
            if(idAppMain.state == "AppDmbENGMode"){
                idDmbENGModeList.currentIndex = CommParser.m_iPresetListIndex
                //idDmbENGModeList.positionViewAtIndex (CommParser.m_iPresetListIndex, ListView.Center)
                if(idDmbENGModeList.currentItem){
                    if( idDmbENGModeMain.lastFocusId != "idDmbENGModeRight")
                        idDmbENGModeList.currentItem.forceActiveFocus();

                }
            }
        }
    }
}
