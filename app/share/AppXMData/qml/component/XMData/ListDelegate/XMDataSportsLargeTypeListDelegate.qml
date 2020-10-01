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
        ListView.view.sportmoveOnPageByPage(rowPerPage, true);
    }
    onWheelLeftKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        ListView.view.sportmoveOnPageByPage(rowPerPage, false);
    }

    onClickReleased: {
        ListView.view.currentIndex = index;
        var startIndex = ListView.view.getStartIndex(ListView.view.contentY);
        var endIndex = ListView.view.getEndIndex(ListView.view.contentY);
        if( (ListView.view.currentIndex < (ListView.view.count-1)) && (endIndex == ListView.view.currentIndex) && ((startIndex + 3) == endIndex) ){
            ListView.view.positionViewAtIndex(ListView.view.currentIndex, ListView.Beginning);
        }
    }
}
