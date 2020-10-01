import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate

FocusScope{
    id:container
    property alias listModel: idFuelPricesList.listModel
    Component{
        id: idFuelPricesListDelegate
        XMDelegate.XMFuelBrandListDelegate {}
    }
    XMList.XMDataNormalList{
        id: idFuelPricesList
        focus: true
        width: parent.width;
        height: 92*6;
        listDelegate: idFuelPricesListDelegate

        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_NO_BRAND_DATA

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
                if(count == 0)
                {
                    leftFocusAndLock(true);
                    idAppMain.forceActiveFocus();
                }else
                {
                    leftFocusAndLock(false);
                    doCheckEnableMenuBtn();
                }
            }
        }
    }
    function doCheckEnableMenuBtn(){
        if(visible && onRoute == false)
            idMenuBar.enableMenuBtn = idFuelPricesList.count == 0 ? false : true;
    }
}
