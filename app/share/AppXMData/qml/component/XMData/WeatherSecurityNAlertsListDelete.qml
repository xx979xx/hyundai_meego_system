/**
 * FileName: MovieTimesMyFavoritesDeleteTheaters.qml
 * Author: David.Bae
 * Time: 2012-05-11 15:58
 *
 * - 2012-05-11 Initial Created by David
 */
import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./ListDelegate" as XMDelegate
import "../XMData/Popup" as MPopup


XMDataFavoritesAddTemplate{
    id:idDeleteFavarite
    x: 0; y : 0
    width:systemInfo.lcdWidth;
    height: systemInfo.lcdHeight-systemInfo.titleAreaHeight;

    property int changeCount:0;
    focus: true
    onChangeCountChanged: {
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_DELETE;
        idMenuBar.textTitleForDeleteAll = "("+changeCount+")";
    }

    //List Delegate
    Component{
        id: idDelegate
        XMDelegate.XMWeatherSecurityNAlertListSelectDelegate {
            //isAddFavorite: true;
            onCheckOn: {
                weatherDataManager.setDeleteCheckToWSAList(index, true);
                changeCount = changeCount +1;
            }
            onCheckOff: {
                weatherDataManager.setDeleteCheckToWSAList(index, false);
                changeCount = changeCount -1;
            }
        }
    }
    listModel: WSAlertsList
    listDelegate: idDelegate
    buttonNumber: 4
    buttonText1: stringInfo.sSTR_XMDATA_DELETE;
    buttonText2: stringInfo.sSTR_XMDATA_DELETE_ALL;
    buttonText3: stringInfo.sSTR_XMDATA_DESELECT;
    buttonText4: stringInfo.sSTR_XMDATA_CANCEL;

    buttonEnabled1: changeCount != 0;
    buttonEnabled2: idDeleteFavarite.count != 0
    buttonEnabled3: changeCount != 0;

    textWhenListIsEmpty: stringInfo.sSTR_XMDATA_WSA_NO_INFO

    onInitialze: {
        weatherDataManager.initWSADeleteList();
        changeCount = 0;
        idMenuBar.textTitle = stringInfo.sSTR_XMDATA_DELETE;
        idMenuBar.textTitleForDeleteAll = "("+changeCount+")";
    }

    onClickMenu1: { // "Delete"
        weatherDataManager.deleteWSAListByDeleteRole();
        showDeletedSuccessfully();
        callItWhenClose();
    }
    onClickMenu2: {
        idDeleteAllQuestion.show();
        changeCount = weatherDataManager.getWSAListCountForDeleteAll();
    }
    onClickMenu3: {
        weatherDataManager.initWSADeleteList();
        changeCount = 0;
    }
    onClickMenu4: {
        weatherDataManager.initWSADeleteList();
        callItWhenClose();
    }
    function callItWhenClose(){
        parent.hide();
    }
}//idDeleteFavarite
