
import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Local Import
import "./List" as XMList
import "../QML/DH" as MCommon

FocusScope{
    id:container;

    property alias listModel:       idList.listModel;
    property alias listDelegate:    idList.listDelegate;
    property alias count:           idList.count;
    property alias textWhenListIsEmpty: idList.noticeWhenListEmpty;
    property alias sectionProperty: idList.sectionProperty


    property alias idListView         :idList.listView;

    property alias rowPerPage: idList.rowPerPage//[ITS 193372]
    property bool isKeyDrag: false

    XMList.XMDataNormalList {
        id:idList;
        x:0;y:0
        width:container.width;
        height:container.height;

        property int selectedIndex:0

        focus: true

        //XMRectangleForDebug{}
    }

    function checkFocusOfMovementEnd()
    {
        checkFocusOfScreen();
    }

    function checkFocusOfScreen()
    {
        if(container.visible == true && idMenuBar.contentItem.KeyNavigation.up.activeFocus == true){
            idCenterFocusScope.focus = true;
            idReorderFavorite.focus = true;
            idList.focus = true;
        }
    }

}
