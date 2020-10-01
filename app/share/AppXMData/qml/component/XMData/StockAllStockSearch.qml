import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "./Javascript/Definition.js" as MDefinition
import "../XMData/Popup" as MPopup

// Because Loader is a focus scope, converted from FocusScope to Item.
FocusScope {
    focus: true
    onVisibleChanged:
    {
        if(visible == true)
        {
            focus = true;
            idCityList.focus = true;
        }
    }
    XMDelegate.XMStockListSearchDelegate { id: idStockListSearchDelegate }

    XMList.XMDataNormalList {
        id: idCityList
        x: 0
        y: 0
        width: parent.width
        height: parent.height
        listModel: stockDataFilter
        listDelegate: idStockListSearchDelegate
        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_SPORTS_NO_SEARCH_RESULT

        onCountChanged: {
            if(visible)
            {
                idMenuBar.foundItemCount = count;
                idMenuBar.imageSearchItemIcon = imageInfo.imgFolderXMData + "icon_stock.png"
            }
        }
    }

    Binding {
        target: stockDataManager; property: "searchPredicate"; value: idMenuBar.textSearchTextInput; when: idMenuBar.intelliUpdate
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
        visible : false;
        focus:false;
        detailText1: stringInfo.sSTR_XMDATA_LIST_IS_FULL;
        detailText2: stringInfo.sSTR_XMDATA_UPMOST_100_ITEMS_CAN_BE_ADDED;

        onClose: {
            hide();
        }
        function show(){
            idMenuBar.z = 0;
            idListIsFullPopUp.z = idMenuBar.z+2;
            idCityList.focus = false;
            idListIsFullPopUp.visible = true;
            idListIsFullPopUp.focus = true;
        }
        function hide(){
            idListIsFullPopUp.z = idMenuBar.z-1;
            idMenuBar.z = 1;
            idListIsFullPopUp.visible = false;
            idListIsFullPopUp.focus = false;
            idCityList.focus = true;
            idCityList.forceActiveFocus();
        }
    }
}
