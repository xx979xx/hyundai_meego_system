/**
 * FileName: XMDataFavoriteAddTemplate.qml
 * Author: David.Bae
 * Time: 2012-04-25 17:41
 *
 * - 2012-04-25 Initial Created by David
 */
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

    property alias buttonNumber: idAddMenu.buttonNumber;
    property alias buttonText1: idAddMenu.buttonText1
    property alias buttonText2: idAddMenu.buttonText2
    property alias buttonText3: idAddMenu.buttonText3
    property alias buttonText4: idAddMenu.buttonText4

    property alias buttonEnabled1: idAddMenu.buttonEnabled1
    property alias buttonEnabled2: idAddMenu.buttonEnabled2
    property alias buttonEnabled3: idAddMenu.buttonEnabled3
    property alias buttonEnabled4: idAddMenu.buttonEnabled4

    property alias textWhenListIsEmpty: idList.noticeWhenListEmpty;

    property alias sectionX: idList.sectionX;
    property alias sectionShow: idList.sectionShow;
    property alias sectionProperty: idList.sectionProperty;
    property alias sectionCriteriaFirstCharecter: idList.sectionCriteriaFirstCharecter;

    property alias rowPerPage: idList.rowPerPage

    property alias listView: idList
    property bool checkDRSVisible: false

    signal initialze();
    signal clickMenu1();
    signal clickMenu2();
    signal clickMenu3();
    signal clickMenu4();

    Component.onCompleted: {
        initialze();
    }

    FocusScope{
        id:idMain
        width:parent.width;
        height:parent.height;
        focus:true;
        XMList.XMDataNormalList {
            id:idList;
            x:0;y:0
            width:container.width - idAddMenu.width;
            height:container.height;
            property int selectedIndex:0
            bDeleteScroll: true

            focus: true
            //listModel: this model being determined by parent.
            //listDelegate: this delegate being determined by parent.
            KeyNavigation.right: idAddMenu
        }
        MCommon.MEditMode {
            id:idAddMenu
            height:systemInfo.lcdHeight-systemInfo.titleAreaHeight
            onClickButton1: { clickMenu1();}
            onClickButton2: { idList.focus = true; clickMenu2();}
            onClickButton3: { clickMenu3();}
            onClickButton4: { clickMenu4();}
            KeyNavigation.left:idList
            Keys.onPressed:
            {
                if(event.key == Qt.Key_Up && event.modifiers == Qt.NoModifier)
                {
                    idList.focus = true;
                    idMenuBar.focusInitLeft();
                }
            }
        }
    }

    function moveFocusToList()
    {
        idList.focus = true;
    }

    onCheckDRSVisibleChanged:
    {
        if(visible && checkDRSVisible)
        {
            idList.focus = true;
        }
    }

    function checkFocusOfMovementEnd()
    {
        checkFocusOfScreen();
    }

    function checkFocusOfScreen()
    {
        if(container.visible == true && idAddMenu.activeFocus == true){
            idMain.focus = true;
            idList.focus = true;
        }
        else if(container.visible == true && idMenuBar.contentItem.KeyNavigation.up.activeFocus == true){
            idCenterFocusScope.focus = true;
            idDeleteFavorite.focus = true;
            idMain.focus = true;
            idList.focus = true;
        }
    }
}
