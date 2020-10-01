/**
 * FileName: XMDataChangeRowListDelegate.qml
 * Author: David.Bae
 * Time: 2012-04-26 16:46
 *
 * - 2012-04-26 Initial Created by David
 */
import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXMData

MComp.MComponent {
    id: idListItem

    Component.onCompleted: {
        if(ListView.view.count > 0)
        {
            upFocusAndLock(false);
        }
    }

    //for Key
    onWheelRightKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        ListView.view.moveOnPageByPage(rowPerPage, true);
    }
    onWheelLeftKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        ListView.view.moveOnPageByPage(rowPerPage, false);
    }
}
