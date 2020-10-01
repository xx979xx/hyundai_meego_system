import Qt 4.7

// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
// Because Loader is a focus scope, converted from FocusScope to Item.
Item {
    width: systemInfo.lcdWidth - x

    XMDelegate.XMStockListDelegate { id: idStockListDelegate }

    XMList.XMNormalList {
        focus: true
        listModel: stockData
        listDelegate: idStockListDelegate
    }

    Keys.onPressed: {
        if( idAppMain.isMenuKey(event) ) {
            if( idMenu.y == 639 )
            {
                idMenu.y = 730; /* hide */
                idStockSymbolist.height = idStockSymbolist.height + 81;
            }
            else
            {
                idMenu.y = 639; /* show */
                idSortByButton.forceActiveFocus();
                idStockSymbolist.height = idStockSymbolist.height - 81;
            }
        }
    }
}
