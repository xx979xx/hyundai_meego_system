/**
 * FileName: XMSportsListSelectDelegate.qml
 * Author: David.Bae
 * Time: 2012-06-04 17:41
 *
 * - 2012-04-25 Initial Created by David
 */

import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData

XMDataAddDeleteCheckBoxListDelegate{
    id: idListItem
    x:0; y:0
    z: index
    width:1030; height:92

    property string fav : favorite;
    property bool isAddFavorite:false;
    signal checkOn(int index);
    signal checkOff(int index);

    onCheckBoxOn:{
        ListView.view.currentIndex = index;
        checkOn(index);
    }
    onCheckBoxOff:{
        ListView.view.currentIndex = index;
        checkOff(index)
    }
    onClickOrKeySelected: {
        if(playBeepOn)
            UIListener.playAudioBeep()
        idListItem.ListView.view.currentIndex = index;
        itemClicked(idText.text);
        forceActiveFocus();
        toggleCheckBox();
    }
    onFavChanged: {
        if(fav == "on" || fav == "add" || fav == "deleteCheck")
            setCheckBoxOn();
        else if(fav == "off")
            setCheckBoxOff();
    }

    Component.onCompleted: {
        if(favorite == "on"){
            setCheckBoxOn();
        }
    }

    //Affiliate Name
    MComp.DDScrollTicker{
        id: idText
        x: 13+87; y: 0;
        width: parent.width - x;
        height: parent.height
        text: teamNickName;
        fontFamily : systemInfo.font_NewHDR
        fontSize: 40
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }

    Image {
        id: idSportsIcon
        x: idText.textPaintedWidth + 104
        y: parent.height/4;
        source: getSportsImageSource(uID);
        visible: true
    }

    Image {
        id: idFemaleIcon
        x: idSportsIcon.x + 57; y: parent.height/4;
        source: imageInfo.imgFolderXMDataSports + "icon_woman.png";
        visible: leagueName == "Women's College Basketball"? true : false;
    }

    function getSportsImageSource(lID)
    {
        switch(lID)
        {
            case 0:
            case 4:
                return imageInfo.imgFolderXMDataSports + "icon_rugby.png"
            case 1:
                return imageInfo.imgFolderXMDataSports + "icon_baseball.png"
            case 2://[ITS 181428]
            case 5:
            case 6:
                return imageInfo.imgFolderXMDataSports + "icon_basketball.png"
            case 3:
                return imageInfo.imgFolderXMDataSports + "icon_hockey.png"
            default:
            break;
        }
    }

    Rectangle{
        x:10
        y:65
        visible:isDebugMode();
        Column{
            Row{
                //Text{text:"["+index+"] tID:"+teamID +", lID:"+ leagueID + ", Name:" + teamName + ", NickName:" + nickName + ", ABBR:" + teamAbbr + ", LeagueName:" + leagueName + ", favorite:"+favorite; color:"white"}
            }
        }
    }
}
