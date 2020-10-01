import Qt 4.7

// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
//import "../QML/DH" as MComp
//import "./ListElement" as XMListElement
//import "./Popup" as MPopup
//import "./Javascript/Definition.js" as MDefinition
//import "./Menu" as MMenu

// Because Loader is a focus scope, converted from FocusScope to Item.
//Item {
FocusScope{
    id:container

    property alias listModel: idFuelPricesList.listModel


    Component{
        id: idFuelPricesTypeDelegate
        XMDelegate.XMFuelTypeListDelegate
        {
            onItemSelected: {
                selectTypename(index);
            }
        }
    }

    XMList.XMDataNormalList{
        id: idFuelPricesList
        focus: true
        width: parent.width;
        height: 92*6
        listDelegate: idFuelPricesTypeDelegate
        listModel: idFuelTypeModel;

        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_NO_TYPE_DATA

        Connections{
            target : fuelPriceDataManager
            onCheckForFocus:{
                if(idFuelPricesList.visible)
                {
                    idFuelPricesList.listView.positionViewAtIndex(0, ListView.Visible);
                    idFuelPricesList.listView.currentIndex = 0;
                }
            }
        }
        onCountChanged: {
            if(visible)
            {
                doCheckEnableMenuBtn();
            }
        }
    }

    ListModel {
        id:idFuelTypeModel
        ListElement { name: "[ENG]Regular" }
        ListElement { name: "[ENG]Mid-Grade" }
        ListElement { name: "[ENG]Premium"}
        ListElement { name: "[ENG]Diesel" }
    }
    function setModelString(){
        idFuelTypeModel.get(0).name = stringInfo.sSTR_XMDATA_REGULAR;
        idFuelTypeModel.get(1).name = stringInfo.sSTR_XMDATA_MIDGRADE;
        idFuelTypeModel.get(2).name = stringInfo.sSTR_XMDATA_PREMIUM;
        idFuelTypeModel.get(3).name = stringInfo.sSTR_XMDATA_DIESEL;
    }
    // Loading Completed!!
    Component.onCompleted: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: setModelString()
    }
    function doCheckEnableMenuBtn(){
        if(visible && onRoute == false)
            idMenuBar.enableMenuBtn = idFuelPricesList.count == 0 ? false : true;
    }

}
