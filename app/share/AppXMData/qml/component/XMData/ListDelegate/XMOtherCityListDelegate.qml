import Qt 4.7

// System Import
import "../../QML/DH" as MComp

Component {
    MComp.MComponent {
        id: idListItem
        x:0; y:0
        z: index
        width:ListView.view.width; height:92

        property bool bFullMode : szListMode == "normal" ? false : true
        property int selectedIndex;

//        signal showSeeOrAddFav(int index, int CityID, string StateName, string CityName, double Latitude,double Longitude, int ItemType);
        Image {
            id: idBGFocus
            x: 0; y:0
            source: isMousePressed() ? imageInfo.imgFolderMusic + "tab_list_02_p.png" : (idListItem.activeFocus && focusOn) ? imageInfo.imgFolderMusic + "tab_list_02_f.png" : ""
        }


        MComp.DDScrollTicker{
            id: idText
            x: 6 + 26 + 23; y: 0
            width: 846
            height: parent.height
            text: CityName + ", " + StateName
            fontFamily : systemInfo.font_NewHDR
            fontSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            tickerEnable: true
            tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
        }

        Image {
            x: 0; y: parent.height
            width: parent.width-50
            source: imageInfo.imgFolderMusic + "tab_list_line.png"
        }

        onClickOrKeySelected: {
            if(pressAndHoldFlag == false){
                if(playBeepOn)
                    UIListener.playAudioBeep();
                onSelectTtem(CityID);
            }
        }

        onActiveFocusChanged: {
            if(activeFocus == true)
                mEnabled = true;
        }

        onHomeKeyPressed: {
            gotoFirstScreen();
        }
        onBackKeyPressed: {
            gotoBackScreen(false);//CCP
        }
        onWheelRightKeyPressed: {
            if(ListView.view.flicking || ListView.view.moving)   return;

            var endIndex = ListView.view.getEndIndex(ListView.view.contentY);
            if(-1 < endIndex)
            {
                if(endIndex === ListView.view.currentIndex){
                    ListView.view.positionViewAtIndex(ListView.view.currentIndex+1, ListView.Beginning);
                    ListView.view.incrementCurrentIndex();
                    ListView.view.positionViewAtIndex(ListView.view.currentIndex, ListView.Beginning);
                }
                else
                {
                    ListView.view.incrementCurrentIndex();
                }
            }

            if( ListView.view.count-1 == index )
            {
                if(ListView.view.count <= rowPerPage)
                    return;

                ListView.view.positionViewAtIndex(0, ListView.Visible);
                ListView.view.currentIndex = 0;
            }
        }
        onWheelLeftKeyPressed: {
            if(ListView.view.flicking || ListView.view.moving)   return;

            var startIndex = ListView.view.getStartIndex(ListView.view.contentY);
            if(startIndex === ListView.view.currentIndex){
                if(startIndex < rowPerPage){
                    ListView.view.positionViewAtIndex(rowPerPage-1, ListView.End);
                }
                else{
                    ListView.view.positionViewAtIndex(ListView.view.currentIndex-1, ListView.End);
                }
            }

            if( index )
            {
                ListView.view.decrementCurrentIndex();
            }
            else
            {
                if(ListView.view.count <= rowPerPage)
                    return;
                //QT Bug : can't move real-end-position with using section :: so, I have to move 2 lines. let me know, if you have any idea. : blacktip : 20130307
                ListView.view.positionViewAtIndex(ListView.view.count-2, ListView.Visible);
                ListView.view.currentIndex = ListView.view.count-2;
                ListView.view.positionViewAtIndex(ListView.view.count-1, ListView.Visible);
                ListView.view.currentIndex = ListView.view.count-1;
            }
        }

//        onShowSeeOrAddFav:{
//            idPopupCaseC.setDataAndShow(index, CityID, StateName, CityName, Latitude, Longitude, ItemType);
//        }

        Text {
            x:5; y:12; id:idFileName
            text:"XMOtherCityListDelegate.qml";
            color : colorInfo.transparent;
        }
        Rectangle{
            x:10
            y:65
            visible:isDebugMode();
            Column{
                Row{
                    Text{text:"["+index+"] CityID:"+CityID +", Lat:"+Latitude+",Log:"+Longitude; color:"white"}
                }
            }
        }
    }
}
