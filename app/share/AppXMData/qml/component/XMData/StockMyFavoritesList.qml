import Qt 4.7

// System Import
import "../QML/DH" as MComp

// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
// Because Loader is a focus scope, converted from FocusScope to Item.
FocusScope {
    property alias listCount: idMyFavoriteList.count
    property alias listView: idMyFavoriteList.listView
    XMDelegate.XMStockListEditDelegate { id: idStockListEditDelegate }

    XMList.XMDataNormalList {
        id: idMyFavoriteList
        focus: true
        listModel: stockMyFavoriteDataModel
        //listModel: stockMyFavoriteData
        listDelegate: idStockListEditDelegate
        noticeWhenListEmpty: /*idAppMain.isDRSChange ? stringInfo.sSTR_XMDATA_DRS_WARNING_EX :*/ stringInfo.sSTR_XMDATA_PLEASE_MAKE_YOUR_FAVORITES_STOCK
        showSearchButtonWhenListEmpty: true
        sectionShow:false;

        x: 0
        y: 0
        width: parent.width
        height: parent.height

        onSearchButton: {
            selectAll();
        }

        Behavior on height { NumberAnimation { duration: 200 } }
    }
}
