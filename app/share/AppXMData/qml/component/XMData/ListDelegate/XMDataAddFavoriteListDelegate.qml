/**
 * FileName: XMDataAddFavoriteListDelegate.qml
 * Author: David.Bae
 * Time: 2012-06-14 15:09
 *
 * - 2012-06-14 Initial Created by David
 */
import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXMData

XMDataLargeTypeListDelegate {
    id:container

    //property alias addFavoriteButtonEnabled: idAddFavoriteButton.mEnabled;

    signal addFavoriteButtonClicked();
    signal delFavoriteButtonClicked();

    MComp.MButton{
        id:idAddFavoriteButton
        x: 870
        y: 7
        width: 274; height: 79

        bgImage:            imageInfo.imgFolderXMData + "btn_fav_n.png"
        bgImagePress:       imageInfo.imgFolderXMData + "btn_fav_p.png"
        bgImageFocus:       imageInfo.imgFolderXMData + "btn_fav_f.png"
        //bgImageFocusPress:  imageInfo.imgFolderXMData + "btn_fav_fp.png"

        onVisibleChanged: {
//            console.log("[QML]affiliateName : " + affiliateName + "[QML] sportsDataManager.searchMyFavorites(affiliateName):" + sportsDataManager.searchMyFavorites(affiliateName))
        }

        firstText: favorite == "on" ? stringInfo.sSTR_XMDATA_DELETEFAVORITE : stringInfo.sSTR_XMDATA_ADDFAVORITE

//        firstTextWidth: 244
        firstTextX: 20
//        firstTextY: 38
        firstTextSize: 26//32
        firstTextColor: colorInfo.subTextGrey
        firstTextStyle: systemInfo.font_NewHDB
//        firstTextAlies: "Center"

        onClickOrKeySelected: {
                if(firstText == stringInfo.sSTR_XMDATA_DELETEFAVORITE)
                {
                    delFavoriteButtonClicked();
                }else{
                    if(sportsDataManager.canIAddToFavorite() == true)
                        addFavoriteButtonClicked();
                    else
                        showListToFavoriteIsFull();
                }
        }
    }
    onClickOrKeySelected: {
            if(idAddFavoriteButton.firstText == stringInfo.sSTR_XMDATA_DELETEFAVORITE)
            {
                delFavoriteButtonClicked();
            }else{
                if(sportsDataManager.canIAddToFavorite() == true)
                    addFavoriteButtonClicked();
                else
                    showListToFavoriteIsFull();
            }
    }
    //MXMData.XMRectangleForDebug{}
}
