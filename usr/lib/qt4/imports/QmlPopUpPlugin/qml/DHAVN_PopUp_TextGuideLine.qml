import Qt 4.7
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST
import AppEngineQMLConstants 1.0

Rectangle
{
    id: popup

    /** --- Input parameters --- */
    property string title: ""
    property string popupType: RES.const_POPUP_TYPE_D

    property bool enableCloseBtn: false

    property ListModel guideline: ListModel
    {
        ListElement{ guideline_n: ""; guideline_p: ""; guideline_s: ""; guideline_f: "" }
        ListElement{ guideline_n: ""; guideline_f: "" }
        ListElement{ guideline_n: ""; guideline_f: "" }
        ListElement{ guideline_n: ""; guideline_f: "" }
    }
    property ListModel message: ListModel {}
    property ListModel buttons: ListModel {}

    property int currentIndex: 0
    property int buttonSpace: CONST.const_POPUP_GUIDELINE_BTN_SPACING

    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal guideLineClicked( variant index )
    signal translateText(variant context)

    function retranslateUI( context )
    {
       if (context) { __lang_context = context }
       __emptyString = " "
       __emptyString = ""

       base.retranslateUI(context)
       translateText(context)
    }

    property string __lang_context: CONST.const_LANGCONTEXT
    property string __emptyString: ""


    /** --- Functions --- */
    function jogHandler( jogEvent )
    {
        console.log("[SystemPopUp] jogEvent - ", jogEvent);
        switch( jogEvent )
        {
            case CONST.const_JOG_EVENT_ARROW_UP:
            case CONST.const_JOG_EVENT_ARROW_DOWN:

                console.log( "[SystemPopUp] const_JOG_EVENT_ARROW_UP & const_JOG_EVENT_ARROW_DOWN" );

                __bIsListFocused = !__bIsListFocused
                if(!__bIsListFocused)
                {
                    popupBtn.initFocusedIndex()
                }
                else
                {
                    popupBtn.dropFocusedIndex()
                }
                break;

            case CONST.const_JOG_EVENT_ARROW_LEFT:

                console.log( "[SystemPopUp] const_JOG_EVENT_ARROW_LEFT" );

                if( !__bIsListFocused )
                {
                    popupBtn.prevBtn();
                }
                break;

            case CONST.const_JOG_EVENT_ARROW_RIGHT:

                console.log( "[SystemPopUp] const_JOG_EVENT_ARROW_RIGHT" );

                if( !__bIsListFocused )
                {
                   popupBtn.nextBtn();
                }
                break;

            case CONST.const_JOG_EVENT_WHEEL_LEFT:

                console.log( "[SystemPopUp] const_JOG_EVENT_WHEEL_LEFT" );

                if ( __bIsListFocused )
                {
                    if( guide_line.curSelectedIndex != 0 )
                    {
                        guide_line.curSelectedIndex--
                    }
                    else
                    {
                        guide_line.curSelectedIndex = guide_line_repeater.count - 1
                    }
                }
                else
                {
                    popupBtn.initFocusedIndex()
                }

                break;

            case CONST.const_JOG_EVENT_WHEEL_RIGHT:

                console.log( "[SystemPopUp] const_JOG_EVENT_WHEEL_RIGHT" );

                if ( __bIsListFocused )
                {
                    if( guide_line.curSelectedIndex != guide_line_repeater.count - 1 )
                    {
                        guide_line.curSelectedIndex++
                    }
                    else
                    {
                        guide_line.curSelectedIndex = 0
                    }
                }
                else
                {
                    popupBtn.initFocusedIndex()
                }
                break;

            case CONST.const_JOG_EVENT_CENTER:

                console.log("[SystemPopUp] const_JOG_EVENT_CENTER ");

                if( !__bIsListFocused )
                {
                     popupBtn.selectBtn();
                }
                break;
        }
    }

    /** --- Private property --- */
    property variant __defaultImages: [ RES.const_POPUP_GUIDELINE_ITEM_1_IMG,
                                        RES.const_POPUP_GUIDELINE_ITEM_2_IMG,
                                        RES.const_POPUP_GUIDELINE_ITEM_3_IMG,
                                        RES.const_POPUP_GUIDELINE_ITEM_4_IMG ]
    property bool __bIsListFocused: false

    /** --- Child object --- */
    DHAVN_PopUp_Base
    {
        id: base
        titleText: title
        isCloseBtnVisible:enableCloseBtn
        type: popupType
        content: popupContent

        Item
        {
            id: popupContent

            Column
            {
                width: parent.width

                anchors.centerIn: parent               

                /** Text message */
                DHAVN_PopUp_Item_SuperText
                {
                    id: popupSuperText
                    txtModel: message
                }

                Connections
                {
                   target: popup
                   onTranslateText:
                   {
                      popupSuperText.retranslateUI(context)
                   }
                }

                Row
                {
                    id: guide_line

                    property int curSelectedIndex: popup.currentIndex;   

                    spacing: CONST.const_POPUP_GUIDELINE_ITEM_SPACING

                    anchors.horizontalCenter: parent.horizontalCenter

                    Repeater
                    {
                        id: guide_line_repeater

                        model: guideline

                        delegate: Component
                        {
                            DHAVN_PopUp_Item_Button
                            {
                                id: guideline_btn

                                bg_img_n: guideline_n ? guideline_n : __defaultImages[ index ]
                                bg_img_p: guideline_p ? guideline_p : __defaultImages[ index ]
                                bg_img_s: guideline_s ? guideline_s : __defaultImages[ index ]
                                bg_img_f: guideline_f

                                Binding {
                                    target: guideline_btn;
                                    property: "bFocused";
                                    value: guide_line.curSelectedIndex == index
                                }

                                Binding {
                                    target: guideline_btn;
                                    property: "highlighted";
                                    value: ( guide_line.curSelectedIndex == index )
                                }

                                onBtnClicked:
                                {
                                    guide_line.curSelectedIndex = index;
                                    __bIsListFocused = true;
                                    popupBtn.dropFocusedIndex()
                                }

                                Connections
                                {
                                   target: popup
                                   onTranslateText:
                                   {
                                     guideline_btn.retranslateUI(context)
                                   }
                                }
                            }
                        }
                    }

                    onCurSelectedIndexChanged:
                    {
                       popup.guideLineClicked( guide_line.curSelectedIndex );
                    }

                }

                /** Button spacing */
                Item { width: 1; height: buttonSpace }

                /** Buttons */
                DHAVN_PopUp_Item_Buttons
                {
                    id: popupBtn

                    btnModel: popup.buttons

                    onBtnClicked:
                    {
                        popup.btnClicked( btnId );
                        __bIsListFocused = false;
                    }

                    Connections
                    {
                      target: popup
                      onTranslateText:
                      {
                        popupBtn.retranslateUI(context)
                      }
                    }
                }

            }

        }

    }

}
