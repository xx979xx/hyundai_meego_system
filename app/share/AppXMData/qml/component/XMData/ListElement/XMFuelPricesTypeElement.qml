import Qt 4.7

QtObject {
    property string name
    property string nameText: getName(name)

    function getName(str) {
        switch( str )
        {
//        case "Regular": return qsTr("Regular"); /*stringInfo.sSTR_XMDATA_REGULAR;*/ break;
//        case "Mid-Grade": return qsTr("Mid-Grade"); /*stringInfo.sSTR_XMDATA_MIDGRADE;*/ break;
//        case "Premium": return qsTr("Premium"); /*stringInfo.sSTR_XMDATA_PREMIUM;*/ break;
//        case "Diesel": return qsTr("Diesel"); /*stringInfo.sSTR_XMDATA_DIESEL;*/ break;
        case "Regular": return stringInfo.sSTR_XMDATA_REGULAR;
        case "Mid-Grade": return stringInfo.sSTR_XMDATA_MIDGRADE;
        case "Premium": return stringInfo.sSTR_XMDATA_PREMIUM;
        case "Diesel": return stringInfo.sSTR_XMDATA_DIESEL;
        default: return ""; break;
        }
    }
}
