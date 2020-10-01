import Qt 4.7
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Resources.js" as RES

/** Text message */

Column
{
    id: property_table
    property string fontFamily
    Connections
    {
       target: UIListener
       onRetranslateUi:{
           //fontFamily = popUpBase.getFont(languageId);
           LocTrigger.retrigger();
       }
    }

//Rectangle{
//    color:"red"
//    opacity:0.5
//    width:property_table.width
//    height:property_table.height
//    anchors.left: property_table.left
//    anchors.top: property_table.top
//    visible:true
//}
    /** --- Input parameters --- */
    property ListModel propertyModel: ListModel {}
    property bool txtOnly: false

    function retranslateUI( context )
    {
        if (context) { __lang_context = context }
        __emptyString = ""
    }

    property string __lang_context: CONST.const_LANGCONTEXT
    property string __emptyString: ""

    /** --- Child object --- */

    function getPropertyName(index)
    {
        var strPropertyName;
        if ( propertyModel.get(index).name.indexOf("STR_") === 0 )
            strPropertyName = qsTranslate(__lang_context, propertyModel.get(index).name)
        else
            strPropertyName = propertyModel.get(index).name

        return strPropertyName;
    }

    function getPropertyValue(index)
    {
        var strPropertyValue;
        if ( propertyModel.get(index).value.indexOf("STR_") === 0 )
            strPropertyValue = qsTranslate(__lang_context, propertyModel.get(index).value)
        else
            strPropertyValue = propertyModel.get(index).value

        return strPropertyValue;
    }

    function getEnableMarquee(index)
    {
        var enable;

        if ( propertyModel.get(index).enableMarquee !== undefined )
            enable = propertyModel.get(index).enableMarquee;
        else
            enable = 'false';

        return enable;
    }

    function getTextWidth(text, pointSize, parent)
    {
        var width;

        var textElement = Qt.createQmlObject(
                'import Qt 4.7; Text { font.pointSize: ' + pointSize + '; text: "' + text + '"}',
                parent, "calcColumnWidths");

        width = textElement.width;
        textElement.destroy();

        return width;
    }

    function getLableMargin(labelWidth, valueWidth, parent)
    {
        var marginWidth = 0;
        var width = labelWidth + valueWidth;

        if( width < CONST.const_PROPERTY_TABLE_TEXT_MAX_WIDTH && width > 0 )
            marginWidth = (CONST.const_PROPERTY_TABLE_TEXT_MAX_WIDTH - labelWidth - valueWidth)/2;

        return marginWidth;
    }

    Repeater
    {
        model: propertyModel

        delegate: Component
        {
            Item
            {
                id: row_item

                property int txtSpacing: model.txt_spacing ||
                             ( property_table.txtOnly ? CONST.const_TEXTONLY_SPACING : CONST.const_TEXT_SPACING_32 )

                width: property_table.width
                height: 44//( labelText.font.pixelSize + txtSpacing )
                anchors.left:parent.left

                Text
                {
                    id: labelText
                    text: property_table.getPropertyName(index)
//                    width:{
//                        Math.min( property_table.getTextWidth(text, font.pointSize, labelText), CONST.const_PROPERTY_TABLE_ITEM_MAX_WIDTH)
//                    }
                    height: parent.height

                    anchors.left:parent.left
                   // anchors.leftMargin:property_table.getLableMargin(width, valueText.valueWidth, font.pixelSize, labelText)
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft

                    color: ( model.txt_color || CONST.const_TEXT_COLOR )
                    font.pointSize: model.txt_pixelsize || CONST.const_TEXT_PT
                    font.family: fontFamily

                    //wrapMode: Text.WordWrap
                    style : Text.Sunken
                }

                Text
                {
                    id: divider
                    text: " : "

                    //width: CONST.const_PROPERTY_TABLE_DIVIDER_WIDTH
                    height: labelText.height

                    anchors.left: labelText.right
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft//Text.AlignHCenter

                    font.pointSize:  labelText.font.pointSize
                    font.family: fontFamily
                    color: labelText.color
                    style : Text.Sunken
                }


                DHAVN_PopUp_Item_MarqueeText
                {
                    id: valueText
                    text: property_table.getPropertyValue(index)
                    property int valueWidth: property_table.getTextWidth(text, font.pixelSize, valueText)

                    width: (CONST.const_PROPERTY_TABLE_TEXT_MAX_WIDTH - labelText.width - (labelText.anchors.leftMargin*2))
                    height: parent.height

                    anchors.left:divider.right
                    fontSize: labelText.font.pointSize
                    //fontFamily: fontFamily

                    color: labelText.color
                    style : Text.Sunken
                    enableMarquee: (property_table.getEnableMarquee(index) && (valueWidth > width))
                }
            }
        }
    }
}

