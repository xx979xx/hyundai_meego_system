/**
 * FileName: MOvieTimesMyFavoritesAddTheater.qml
 * Author: David.Bae
 * Time: 2012-05-09 17:46
 *
 * - 2012-05-09 Initial Created by David
 */
import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "../XMData/Popup" as MPopup

FocusScope{
    id:container
    width:systemInfo.lcdWidth;
    height:systemInfo.lcdHeight-systemInfo.titleAreaHeight;
    focus: true;

    Component{
        id : idMovieListDelegate
        XMDelegate.XMMovieTimesListSearchDelegate {
            onGoButtonClicked:{
                checkSDPopup(index, entryID, name, address, phonenumber, latitude, longitude, statename, city, street, zipcode, amenityseating, amenityrocker);
            }
        }
    }

    XMList.XMDataNormalList{
        id:idTheaterSearchList
        x:0;y:0
        focus: true
        width: parent.width;
        height: parent.height;
        listModel: theaterListForSearch
        listDelegate: idMovieListDelegate

        onCountChanged: {
            if(visible)
            {
                idMenuBar.foundItemCount = count;
                idMenuBar.imageSearchItemIcon = imageInfo.imgFolderXMData + "icon_loction.png"
            }
        }
        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_SPORTS_NO_SEARCH_RESULT
    }

    function showListIsFull()
    {
        idListIsFullPopUp.show();
    }

    function hideListIsFull()
    {
        if(idListIsFullPopUp.visible)
            idListIsFullPopUp.hide();
    }

    MPopup.Case_E_Warning{
        id:idListIsFullPopUp
        x: 0
        y: -systemInfo.titleAreaHeight;
        z: 0
        width:parent.width-x;
        height:parent.height;
        visible : false;
        focus:false;
        detailText1: stringInfo.sSTR_XMDATA_LIST_IS_FULL;
        detailText2: stringInfo.sSTR_XMDATA_UPMOST_10_ITEMS_CAN_BE_ADDED;

        onClose: {
            hide();
        }
        function show(){
            idMenuBar.z = 0;
            idListIsFullPopUp.z = idMenuBar.z+2;
            idListIsFullPopUp.visible = true;
            idListIsFullPopUp.focus = true;
        }
        function hide(){
            idListIsFullPopUp.z = idMenuBar.z-1;
            idMenuBar.z = 1;
            idListIsFullPopUp.visible = false;
            idListIsFullPopUp.focus = false;
            idTheaterSearchList.focus = true;
            idTheaterSearchList.forceActiveFocus();
        }
    }
    Binding {
        target: movieTimesDataManager; property: "searchPredicate"; value: idMenuBar.textSearchTextInput; when: idMenuBar.intelliUpdate
    }
}



