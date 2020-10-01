/**
 * FileName: SportsMyFavorites.qml
 * Author: David.Bae
 * Time: 2012-06-04 11:37
 *
 * - 2012-06-04 Initial Created by David
 */
import Qt 4.7

// System Import
import "../QML/DH" as MComp
import "./Common" as XMCommon
import "./List" as XMList
import "./ListDelegate" as XMDelegate

FocusScope {
    focus: true

    XMCommon.StringInfo { id: stringInfo }

    property alias listModel: idList.listModel
    property alias listCount: idList.count
    property alias listView: idList.listView

    Component{
        id: idListDelegate
        XMDelegate.XMSportsFavoriteListDelegate {
            width:idList.width-32;
            onSportTeamSelected: { //(int tID, int lID, string tName, string nName, string aName, string lName);
                selSportFav = true;
                var teamStr = tName + " " + nName;
                selectAffiliate(-1, teamStr, true, tID, uID)
            }
        }
    }

    XMList.XMDataNormalList{
        id: idList
        focus: visible
        visible: (idList.count > 0)
        width: parent.width;
        height: parent.height;
        listModel: sportsFavoriteTeamListModel
        listDelegate: idListDelegate
        selectedIndex: -1;

        sectionShow:false;
        sectionProperty:"affiliateName";//"leagueName";
        sectionX:10;

        function keyDown() {
            return idList;
        }
        KeyNavigation.down: keyDown();

        noticeWhenListEmpty:  "";

        Connections{
            target : sportsDataManager
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
                        if(isLeftMenuEvent)
                            idList.forceActiveFocus();
                    }
                }
            }
        }

    }

    Item{
        id:idShowTextAndButtonWhenListIsEmpty
        width:parent.width
        height:parent.height;
        visible: idList.count === 0;

        //Show Text
        Text{
            id:idEmptyLabel
            x:30;y: 363-systemInfo.headlineHeight - font.pixelSize/2
             width:parent.width - x
             text: stringInfo.sSTR_XMDATA_NO_FAVORITES_LEAGUE
             verticalAlignment: Text.AlignVCenter
             horizontalAlignment: Text.AlignHCenter
             font.family: systemInfo.font_NewHDR
             font.pixelSize: 40
             wrapMode: Text.Wrap
             color: colorInfo.brightGrey
        }

        // Search Button/
        MComp.MButton{
            id:idEditButton
            focus: visible
            x: (parent.width - width)/2
            y: (parent.height - height)/2 + 80
            width: 462; height: 85

            bgImage:            imageInfo.imgFolderAha_radio + "btn_ok_n.png"
            bgImagePress:       imageInfo.imgFolderAha_radio + "btn_ok_p.png"
            bgImageFocus:       imageInfo.imgFolderAha_radio + "btn_ok_f.png"

            firstText: stringInfo.sSTR_XMDATA_SEARCH
            firstTextX: 20
            firstTextSize:32
            firstTextColor: colorInfo.brightGrey
            firstTextStyle: systemInfo.font_NewHDB

            onClickOrKeySelected: {
                searchTeamForFavorite();
            }
        }

        XMRectangleForDebug{}
    }

}
