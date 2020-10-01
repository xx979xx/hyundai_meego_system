/**
 * FileName: RadioOptionMenu.qml
 * Author: HYANG
 * Time: 2012-02-
 *
 * - 2012-02- Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComp.MOptionMenu{
    id: idMListMenu
    x: 0; y:0; z: 10

    property bool featuredfavoritesMenuList : true//false

    menu1Enabled: featuredfavoritesMenuList
    menu2Enabled: idAppMain.isSkipChannelListEmpty

    //****************************** # Item Model #
    linkedModels: ListModel { id: idRadioListMenuModel }

    //****************************** # Item Clicked #
    onMenu0Click: {
        console.log(">>>>>>>>>>>>>  Now Listening")
        idMListMenu.offOptionMenu();
        setAppMainScreen("AppRadioMain", false);
    }
    onMenu1Click: {
        console.log(">>>>>>>>>>>>>  Featured Favorite")
        idMListMenu.offOptionMenu();

        if (FFManager.handleFFCount() == 0)
        {
            setAppMainScreen("PopupRadioWarning1Line", true);
            idRadioPopupWarning1Line.item.onPopupWarning1LineFirst(stringInfo.sSTR_XMRADIO_NO_FEATURED_FAVORITE);
            idRadioPopupWarning1Line.item.onPopupWarning1LineWrap(false);
        }
        else
        {
            setAppMainScreen("AppRadioFeaturedFavorites", false);
        }
    }
    onMenu2Click: {
        console.log(">>>>>>>>>>>>>  Skip")
        idAppMain.sxm_list_skipcount = UIListener.HandleListSkipcount(idAppMain.sxm_list_currcat);
        idMListMenu.offOptionMenu();
        XMOperation.onListSkip();
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        console.log("XMAudioListMenu - BackKey Clicked");
        idMListMenu.hideOptionMenu();
    }
    /* CCP Menu Key */
    onClickMenuKey: {
        console.log("XMAudioOptionMenu - MenuKey Clicked");
        idMListMenu.hideOptionMenu();
    }

    onOptionMenuFinished:{
        console.log("XMAudioListMenu - optionMenuFinished() ")
        idMListMenu.hideOptionMenu();
    }

    onLeftKeyMenuClose:{
        console.log("XMAudioListMenu - leftKeyMenuClose() ")
        idMListMenu.hideOptionMenu();
    }

    onTuneLeftKeyPressed: {
        console.log("XMAudioListMenu - Wheel Left Key Pressed")
        idRadioList.item.setListForceFocusChannelListPosition();
    }

    onTuneRightKeyPressed: {
        console.log("XMAudioListMenu - Wheel Right Key Pressed")
        idRadioList.item.setListForceFocusChannelListPosition();
    }

    function onFeaturedFavoritesMenuList(b_status)
    {
        featuredfavoritesMenuList = b_status;
    }

    function setListMenuModelString(){
        var data1 = {"name" : stringInfo.sSTR_XMRADIO_NOW_LISTENING, "opType":""};
        var data2 = {"name" : stringInfo.sSTR_XMRADIO_FEATURED_FAVORITE, "opType":""};
        var data3 = {"name" : stringInfo.sSTR_XMRADIO_SKIP, "opType":""};

        idRadioListMenuModel.clear();
        idRadioListMenuModel.append(data1);
        idRadioListMenuModel.append(data2);
        idRadioListMenuModel.append(data3);
    }
}
