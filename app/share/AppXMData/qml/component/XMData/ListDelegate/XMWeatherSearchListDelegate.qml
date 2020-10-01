/**
 * FileName: XMWeatherSearchListDelegate.qml
 * Author: David.Bae
 * Time: 2012-06-14 12:10
 *
 * - 2012-06-13 Initial Created by David
 */
import Qt 4.7

// System Import
import "../../QML/DH" as MComp

Component {
    MComp.MComponent {
        id: idListItem
        x:0; y:0
        z: index
        width:ListView.view.width-35-x; height:92

        property bool focusFavoriteBtn: false

        Image {
            x: 0; y: parent.height //In GUI Guide this position is 88 (height-2)
            source: imageInfo.imgFolderGeneral + "list_line.png"
        }

        MComp.MButton{
            id: idBtnText
            x: 14; y:0
            width: 915; height: 97
            bgImage: ""
            bgImagePress: imageInfo.imgFolderXMData + "xm_list_p.png"
            bgImageFocus: imageInfo.imgFolderXMData + "xm_list_f.png"
            focus: !focusFavoriteBtn

            onClickOrKeySelected: {
                idListItem.ListView.view.currentIndex = index;
                idListItem.ListView.view.currentItem.focusFavoriteBtn = false;
                onSelectItemForSearch(itemType, cityID);
                searchMode = false;
            }
            MComp.DDScrollTicker{
                id: idText
                x : 101-14
                y : 0
                width : 824
                height: parent.height
                text : cityStateName
                fontSize: 40
                color : colorInfo.brightGrey
                fontFamily: systemInfo.font_NewHDR
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                tickerEnable: true
                tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
            }
        }

        MComp.MButton{
            id: idBtnFavorite
            x: 101+824+14; y: (parent.height - 78)/2
            width: 284; height: 78
            bgImage: imageInfo.imgFolderXMData + "btn_add_fav_n.png"
            bgImageFocus: imageInfo.imgFolderXMData + "btn_add_fav_f.png"
            bgImageFocusPress: imageInfo.imgFolderXMData + "btn_add_fav_p.png"
            bgImagePress: imageInfo.imgFolderXMData + "btn_add_fav_p.png"
            firstText: favorite == "on" ? stringInfo.sSTR_XMDATA_DELETEFAVORITE : stringInfo.sSTR_XMDATA_ADDFAVORITE
            firstTextSize: 26
            firstTextColor: colorInfo.subTextGrey
            firstTextPressColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextStyle: systemInfo.font_NewHDB
            focus: focusFavoriteBtn

            onClickOrKeySelected: {
                idListItem.ListView.view.currentIndex = index;
                idCenterFocusScope.focus = true;
                idListItem.ListView.view.currentItem.focusFavoriteBtn = true;
                if(weatherDataManager.addOrDeleteFavorite(cityID, itemType))
                {
                    if(favorite == "on")
                        showAddedToFavorite(weatherDataManager.getRegisterFavoriteCount());
                    else
                        showDeletedSuccessfully();
                }else
                {
                    if(favorite == "off")
                        idListIsFullPopUp.show();
                }
            }
        }

        onHomeKeyPressed: {
            gotoFirstScreen();
        }
        onBackKeyPressed: {
            gotoBackScreen(false);
        }
        onWheelRightKeyPressed: {
            if(ListView.view.flicking || ListView.view.moving)   return;

            if(focusFavoriteBtn == false)
            {
                focusFavoriteBtn = true;
            }else
            {
                idListView.moveOnPageByPage(rowPerPage, true);
                if(index != ListView.view.currentIndex){
                    ListView.view.currentItem.focusFavoriteBtn = false;
                    focusFavoriteBtn = false;
                }
            }
        }
        onWheelLeftKeyPressed: {
            if(ListView.view.flicking || ListView.view.moving)   return;

            if(focusFavoriteBtn)
            {
                focusFavoriteBtn = false;
            }
            else
            {
                idListView.moveOnPageByPage(rowPerPage, false);
                if(index != ListView.view.currentIndex)
                    ListView.view.currentItem.focusFavoriteBtn = true;
            }
        }
    }
}
