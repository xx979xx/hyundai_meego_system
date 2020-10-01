/**
 * FileName: FuelPriceSearchBrand.qml
 * Author: David.Bae
 * Time: 2012-06-13 15:39
 *
 * - 2012-06-13 Initial Created by David
 */

import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "./Javascript/Definition.js" as MDefinition
//import "./Common" as XMCommon

FocusScope{
    id:container
    width:systemInfo.lcdWidth;
    height:systemInfo.lcdHeight-systemInfo.titleAreaHeight;
    focus: true

    //XMCommon.StringInfo { id: stringInfo }

    Image
    {
        x:0
        y:0
        width: parent.width
        height: parent.height
        source: imageInfo.imgFolderGeneral + "bg_main.png"
    }

    Component.onCompleted: {
        init();
    }

    function init()
    {
//        fuelPriceDataManager.searchBrandPredicate = "^-";
    }

    onVisibleChanged: {
        if(container.visible==true){
            init();
        }
    }

    Component{
        id: idXMFuelPricesListDelegate
        XMDelegate.XMFuelPricesSearchBrandListDelegate{}
    }

    XMList.XMDataNormalList{
        id:idFuelPricesList
        x:0;y:0
        focus: true
        width: parent.width;
        height: parent.height;
        listModel: fuelBrandListForSearch
        listDelegate: idXMFuelPricesListDelegate

//        KeyNavigation.down: {
//            if( showQwertyKeypad == true )
//                return idQwertyKeypad;
//            else
//                return idFuelPricesList;
//        }
        noticeWhenListEmpty: stringInfo.sSTR_XMDATA_SPORTS_NO_SEARCH_RESULT
        onCountChanged: {
            if(visible)
            {
                idMenuBar.foundItemCount = count;
                idMenuBar.imageSearchItemIcon = imageInfo.imgFolderXMData + "icon_fuel.png"
            }
        }
    }

    // Binding for search text
//    Binding {
//        target: fuelPriceDataManager; property: "searchBrandPredicate"; value: idMenuBar.textSearchTextInput
//    }
    Binding {
        target: fuelPriceDataManager; property: "searchBrandPredicate"; value: idMenuBar.textSearchTextInput; when: idMenuBar.intelliUpdate
    }
}
