import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "./Javascript/Definition.js" as MDefinition
import "../XMData/Popup" as MPopup

FocusScope{
    id:container
    width:systemInfo.lcdWidth;
    height:systemInfo.lcdHeight-systemInfo.titleAreaHeight;
    focus: true

    property alias listModel: idFuelPricesList.listModel

    Image
    {
        x:0
        y:0
        width: parent.width
        height: parent.height
        source: imageInfo.imgFolderGeneral + "bg_main.png"
    }

    function init()
    {

    }

    Component.onCompleted: {
        init();
    }

    onVisibleChanged: {
        if(container.visible==true){
            init();
        }
    }

    Component{
        id: idXMFuelPricesListDelegate
        XMDelegate.XMFuelPricesSearchListDelegate{

            onGoButtonClicked: {
                checkSDPopup(locationID, name, addr);
            }
            onAddButtonClicked: {
                fuelPriceDataManager.setToFavoriteFromSearchListItem(entryID, true);
            }
            onDelButtonClicked: {
                fuelPriceDataManager.setToFavoriteFromSearchListItem(entryID, false);
            }
        }
    }

    XMList.XMDataNormalList{
        id:idFuelPricesList
        x:0;y:0
        focus: true
        width: parent.width;
        height: parent.height;
        listModel: fuelPriceListForSearch
        listDelegate: idXMFuelPricesListDelegate
        rowPerPage: 4

        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_SPORTS_NO_SEARCH_RESULT;

        onCountChanged: {
            if(visible)
            {
                idMenuBar.foundItemCount = count;
                idMenuBar.imageSearchItemIcon = imageInfo.imgFolderXMData + "icon_fuel.png"
            }
        }
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
        y: -systemInfo.titleAreaHeight;
        z: 0
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
            idFuelPricesList.focus = false;
            idListIsFullPopUp.visible = true;
            idListIsFullPopUp.focus = true;
        }
        function hide(){
            idListIsFullPopUp.z = idMenuBar.z-1;
            idMenuBar.z = 1;
            idListIsFullPopUp.visible = false;
            idListIsFullPopUp.focus = false;
            idFuelPricesList.focus = true;
            idFuelPricesList.forceActiveFocus();
        }
    }

    Binding {
        target: fuelPriceDataManager; property: "searchPredicate"; value: idMenuBar.textSearchTextInput; when: idMenuBar.intelliUpdate
    }
}
