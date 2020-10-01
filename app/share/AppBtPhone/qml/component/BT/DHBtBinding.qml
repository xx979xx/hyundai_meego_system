/**
 * DHBtBinding.qml
 *
 */
import QtQuick 1.1


Item
{
    function convertDashedForm(number, variant) {
        var phone_number = number;
        var country_variant = variant;
        return checkPhoneNumber(phone_number, country_variant);
    }

    function number_debug(msg) {
        if(false) {
            console.log("[BT][NUMBER] " + msg)
        }
    }

    function checkPhoneNumber(phone_number, country_variant) {
        // Remove all non-numbers
        phone_number = phone_number.replace(/[^0-9,*,#,+]/g, '');

        if(3 > phone_number.length) {
            return phone_number;
        }

        // 국제전화번호 검사
        var plus_call = ('+' == phone_number[0]) ? true : false;
        var service_code_length = 0;
        if(true == plus_call) {
            // + 인경우 국제전화로 간주함
            service_code_length = 1;
        } else {
             // +가 아닌 경우 해당 향지별 국제전화 서비스 코드를 검사함
            service_code_length = filterServiceCode(getTableIndexFromVariant(country_variant), phone_number);
        }

        if(0 < service_code_length) {
            // 국제전화
            switch(country_variant) {
                case 1: // eCVNorthAmerica
                case 6: // eCVCanada
                    // 북미만 별도 구현, 아래 processNorthAmerica() 함수와 맞춰 사용할 것
                    return processNorthAmericaInternational(phone_number, plus_call, service_code_length, country_variant);

                case 4: // eCVMiddleEast
                case 5: // eCVEuropa
                case 3: // eCVGeneral
                    // 유럽, 중동, 일반향지
                    return processGeneral(phone_number);

                default:
                    return processInternational(phone_number, plus_call, service_code_length);
            }
        }

        // 향지별 지역 전화번호
        switch(country_variant) {
            case 0:	/* eCVKorea */
            case 2: /* eCVChina */
                // 중국전화번호도 한국과 같은 000-0000 or 0000-0000 체계를 사용함
                return processKorea(phone_number, country_variant);

            case 1: /* eCVNorthAmerica */
            case 6: /* eCVCanada */
                return processNorthAmerica(phone_number, country_variant);

            case 4: /* eCVMiddleEast */
                //return processNumberMiddleEast(phone_number, country_variant);
            case 5: /* eCVEuropa */
                //return processNumberEurope(phone_number, country_variant);
            case 3: /* eCVGeneral */
                return processGeneral(phone_number);

            default:
                //qml_debug("invalid country variant");
                break;
        }

        // Variant 오류일 경우 General로 적용함
        return processGeneral(phone_number);
    }

    /*
     */
    function getTableIndexFromVariant(country_variant) {
        switch(country_variant) {
            case 1: /* eCVNorthAmerica */
            case 6: /* eCVCanada */
                return 1;

            case 0: /* eCVKorea */
            case 2: /* eCVChina */
            case 3: /* eCVGeneral */
            case 4: /* eCVMiddleEast */
            case 5: /* eCVEuropa */
                return country_variant;

            default:
                // Country variant가 없을 경우 강제로 3으로 설정(general)
                return 3;
        }
    }

    /* [주의] Index 반환함
     */
    function getLocalCodeTableIndex(phone_number) {
        var COUNTRY_CODE_FOR_LOCAL_TABLE = [ /* 한국 */   "82"
                                             /* 북미 */ , "1"
                                             /* 중국 */ , "86"
                                            ];

        for(var i = 0; i < COUNTRY_CODE_FOR_LOCAL_TABLE.length; i++) {
            if(phone_number.substr(0, COUNTRY_CODE_FOR_LOCAL_TABLE[i].length) == COUNTRY_CODE_FOR_LOCAL_TABLE[i]) {
                return i;
            }
        }

        return -1;
    }

    /*
     */
    function filterServiceCode(table_index, phone_number) {
        var SERVICE_CODE_TABLE = [  /* eCVKorea */            [ "+", "001", "002", "00700", "00306", "00365", "005", "008", "006", "00300" ]
                                    /* eCVNorthAmerica */   , [ "+1" ]          // , "011" ]
                                    /* eCVChina */          , [ "+", "00" ]
                                    /* eCVGeneral */        , [ "+" ]
                                    /* eCVMiddleEast */     , [ "+" ]
                                    /* eCVEuropa */         , [ "+" ]
                                    ];

        for(var i = 0; i < SERVICE_CODE_TABLE[table_index].length; i++) {
            if(phone_number.substr(0, SERVICE_CODE_TABLE[table_index][i].length) == SERVICE_CODE_TABLE[table_index][i]) {
                return SERVICE_CODE_TABLE[table_index][i].length;
            }
        }

        return 0;
    }

    /*
     */
    function filterCountryCode(phone_number) {
        var COUNTRY_CODE_TABLE = [     "1",  "20", "212", "213", "216", "218", "220", "221", "222", "223", "224"
                                   , "225", "226", "227", "228", "229", "230", "231", "232", "233", "234", "235"
                                   , "236", "237", "238", "239", "240", "241", "242", "243", "244", "245", "246"
                                   , "247", "248", "249", "250", "251", "252", "253", "254", "255", "256", "257"
                                   , "258", "260", "261", "262", "263", "264", "265", "266", "267", "268", "269"
                                   ,  "27", "290", "291", "297", "298", "299",  "30",  "31",  "32",  "33",  "34"
                                   , "350", "351", "352", "353", "354", "355", "356", "357", "358", "359",  "36"
                                   , "370", "371", "372", "373", "374", "375", "376", "377", "378", "380", "381"
                                   , "382", "385", "386", "387", "389",  "39",  "40",  "41", "420", "421", "423"
                                   ,  "43",  "44",  "45",  "46",  "47",  "48",  "49", "500", "501", "502", "503"
                                   , "504", "505", "506", "507", "508", "509",  "51",  "52",  "53",  "54",  "55"
                                   ,  "56",  "57",  "58", "590", "591", "592", "593", "594", "595", "596", "597"
                                   , "598", "599",  "60",  "61",  "62",  "63",  "64",  "65",  "66", "670", "672"
                                   , "673", "674", "675", "676", "677", "678", "679", "680", "681", "682", "683"
                                   , "685", "686", "687", "688", "689", "690", "691", "692",   "7",  "81",  "82"
                                   ,  "84", "850", "852", "853", "855", "856",  "86", "880", "886",  "90",  "91"
                                   ,  "92",  "93",  "94",  "95", "961", "962", "963", "964", "965", "966", "967"
                                   , "968", "970", "971", "972", "973", "974", "975", "976", "977",  "98", "992"
                                   , "993", "994", "995", "996", "998"
                                ];

        for(var i = 0; i < COUNTRY_CODE_TABLE.length; i++) {
            if(phone_number.substr(0, COUNTRY_CODE_TABLE[i].length) == COUNTRY_CODE_TABLE[i]) {
                return COUNTRY_CODE_TABLE[i].length;
            }
        }

        return 0;
    }

    /*
     */
    function filterMobileCode(table_index, phone_number, drop0) {
        var MOBILE_CODE_TABLE = [ /* eCVKorea */          [ "011", "016", "017", "018", "019", "010" ]
                                  /* eCVNorthAmerica */ , [ ]
                                  /* eCVChina */        , [ "134", "135", "136", "137", "138", "139", "147", "150", "151", "152", "157", "158", "159", "182", "187", "188"
                                                          , "130", "131", "132", "155", "156", "185", "186"
                                                          , "133", "153", "180", "189" ]
                                  /* eCVGeneral */      , [ ]
                                  /* eCVMiddleEast */   , [ ]
                                  /* eCVEuropa */       , [ ]
                                ];

        if(true == drop0) {
            for(var i = 0; i < MOBILE_CODE_TABLE[table_index].length; i++) {
                if(phone_number.substr(0, MOBILE_CODE_TABLE[table_index][i].length - 1) == MOBILE_CODE_TABLE[table_index][i].substr(1)) {
                    return MOBILE_CODE_TABLE[table_index][i].length - 1;
                }
            }
        } else {
            for(var i = 0; i < MOBILE_CODE_TABLE[table_index].length; i++) {
                if(phone_number.substr(0, MOBILE_CODE_TABLE[table_index][i].length) == MOBILE_CODE_TABLE[table_index][i]) {
                    return MOBILE_CODE_TABLE[table_index][i].length;
                }
            }
        }

        return 0;
    }

    /*
     */
    function filterLocalCode(table_index, phone_number, drop0) {
        var LOCAL_CODE_TABLE  = [   /* eCVKorea */
                                      [   "02", "031", "032", "033", "041", "042", "043", "044", "051", "052", "053"
                                       , "054", "055", "061", "062", "063", "064", "070", "080" ]
                                    /* eCVNorthAmerica */
                                    , [ "205", "256", "334", "907", "602", "623", "480", "520", "501", "870", "626"
                                      , "341", "510", "530", "935", "909", "768", "562", "661", "760", "310", "616"
                                      , "714", "818", "805", "408", "831", "619", "925", "949", "209", "424", "323"
                                      , "213", "858", "707", "650", "916", "415", "559", "719", "303", "720", "970"
                                      , "203", "860", "202", "904", "305", "786", "407", "727", "813", "912", "706"
                                      , "404", "678", "770", "808", "208", "618", "217", "312", "630", "224", "847"
                                      , "815", "309", "812", "219", "317", "319", "515", "712", "913", "785", "316"
                                      , "270", "606", "502", "225", "337", "504", "318", "207", "410", "443", "617"
                                      , "508", "413", "734", "313", "906", "810", "231", "517", "218", "612", "507"
                                      , "651", "228", "417", "816", "314", "406", "402", "308", "702", "603", "609"
                                      , "908", "973", "732", "856", "505", "518", "607", "718", "347", "516", "212"
                                      , "914", "716", "585", "315", "704", "336", "252", "701", "330", "513", "216"
                                      , "614", "740", "937", "419", "405", "918", "541", "503", "971", "610", "484"
                                      , "814", "570", "717", "215", "412", "401", "803", "605", "423", "865", "901"
                                      , "615", "915", "806", "512", "214", "972", "817", "409", "713", "281", "832"
                                      , "210", "903", "801", "802", "425", "206", "509", "360", "304", "920", "608"
                                      , "414", "715", "307" ]
                                    /* eCVChina */
                                    , [  "010",  "020",  "021",  "022",  "023",  "024",  "025",  "027",  "028",  "029"
                                      , "0310", "0311", "0312", "0313", "0314", "0315", "0316", "0317", "0318", "0319", "0335"
                                      , "0350", "0351", "0352", "0353", "0354", "0355", "0356", "0357", "0358", "0359"
                                      , "0370", "0371", "0372", "0373", "0374", "0375", "0376", "0377", "0378", "0379", "0391", "0392", "0393", "0394"
                                      , "0395", "0396", "0398"
                                      , "0410", "0411", "0412", "0413", "0414", "0415", "0416", "0417", "0418", "0419"
                                      , "0421", "0427", "0429"
                                      , "0431", "0432", "0433", "0434", "0435", "0436", "0437", "0438", "0439", "0440"
                                      , "0450", "0451", "0452", "0453", "0454", "0455", "0456", "0457", "0458", "0459"
                                      , "0470", "0471", "0472", "0473", "0474", "0475", "0476", "0477", "0478", "0479"
                                      , "0482", "0483"
                                      , "0510", "0511", "0512", "0513", "0514", "0515", "0516", "0517", "0518", "0519", "0523"
                                      , "0530", "0531", "0532", "0533", "0534", "0535", "0536", "0537", "0538", "0539"
                                      , "0550", "0551", "0552", "0553", "0554", "0555", "0556", "0557", "0558", "0559"
                                      , "0561", "0562", "0563", "0564", "0565", "0566"
                                      , "0570", "0571", "0572", "0573", "0574", "0575", "0576", "0577", "0578", "0579", "0580"
                                      , "0591", "0592", "0593", "0594", "0595", "0596", "0597", "0598", "0599"
                                      , "0660", "0661", "0662", "0663"
                                      , "0701"
                                      , "0710", "0711", "0712", "0713", "0714", "0715", "0716", "0717", "0718", "0719"
                                      , "0722", "0724", "0728"
                                      , "0730", "0731", "0732", "0733", "0734", "0735", "0736", "0737", "0738", "0739", "0743", "0744", "0745", "0746"
                                      , "0751", "0752", "0753", "0754", "0755", "0756", "0757", "0758", "0759"
                                      , "0760", "0762", "0763", "0765", "0766", "0768", "0769"
                                      , "0770", "0771", "0772", "0773", "0774", "0775", "0776", "0777", "0778", "0779"
                                      , "0790", "0791", "0792", "0793", "0794", "0795", "0796", "0797", "0798", "0799"
                                      , "0810", "0811", "0812", "0813", "0814", "0816", "0817", "0818", "0819"
                                      , "0825", "0826", "0827"
                                      , "0830", "0831", "0832", "0833", "0834", "0835", "0836", "0837", "0838", "0839"
                                      , "0840"
                                      , "0851", "0852", "0853", "0854", "0855", "0856", "0857", "0858", "0859"
                                      , "0870", "0871", "0872", "0873", "0874", "0875", "0876", "0877", "0878", "0879", "0691", "0692"
                                      , "0881", "0883", "0886", "0887", "0888"
                                      , "0890", "0898", "0899", "0891", "0892", "0893"
                                      , "0901", "0902", "0903", "0906", "0908", "0909"
                                      , "0910", "0911", "0912", "0913", "0914", "0915", "0916", "0917", "0919"
                                      , "0930", "0931", "0932", "0933", "0934", "0935", "0936", "0937", "0938"
                                      , "0941", "0943"
                                      , "0971", "0972", "0973", "0974", "0975", "0976", "0977"
                                      , "0990", "0991", "0992", "0993", "0994", "0995", "0996", "0997", "0998", "0999" ]
                                    /* eCVGeneral */
                                    , [ ]
                                    /* eCVMiddleEast */
                                    , [ ]
                                    /* eCVEuropa */
                                    , [ ]
                                ];

        if(true == drop0) {
            for(var i = 0; i < LOCAL_CODE_TABLE[table_index].length; i++) {
                if("0" == LOCAL_CODE_TABLE[table_index][i][0]) {
                    if(phone_number.substr(0, LOCAL_CODE_TABLE[table_index][i].length - 1) == LOCAL_CODE_TABLE[table_index][i].substr(1)) {
                        return LOCAL_CODE_TABLE[table_index][i].length - 1;
                    }
                } else {
                    if(phone_number.substr(0, LOCAL_CODE_TABLE[table_index][i].length) == LOCAL_CODE_TABLE[table_index][i]) {
                        return LOCAL_CODE_TABLE[table_index][i].length;
                    }
                }
            }
        } else {
            for(var i = 0; i < LOCAL_CODE_TABLE[table_index].length; i++) {
                if(phone_number.substr(0, LOCAL_CODE_TABLE[table_index][i].length) == LOCAL_CODE_TABLE[table_index][i]) {
                    return LOCAL_CODE_TABLE[table_index][i].length;
                }
            }
        }

        return 0;
    }

    /*
     */
    function generateFormat(count) {
        var format = "";
        for(var i = 0; i < count; i++) {
            format += ("$" + (i + 1) + "-");
        }

        return format.substr(0, format.length - 1);
    }

    /*
     */
    function generateNumberForm(phone_number, format_count, reg_expr) {
        //number_debug("phone_number = " + phone_number);
        //number_debug("reg_expr = " + reg_expr);

        // Generate format string "$1-$2 ... "
        var format = generateFormat(format_count);

        if(0 < reg_expr.length) {
            /* Convert to dash-number format */
            var reg = new RegExp(reg_expr, "g");
            if(true == reg.test(phone_number)) {
                phone_number = phone_number.replace(reg, format);
            }
        }

        return phone_number;
    }

    /* 국제전화 처리 함수
     */
    function processInternational(phone_number, plus_call, service_code_length) {
        var reg_expr = "";
        var format_count = 0;

        var cut_number = phone_number.substr(service_code_length);

        // 지역번호 또는 모바일 번호를 검사하는 국가코드인지 검사
        var local_code_table_index = getLocalCodeTableIndex(cut_number);

        var country_code_length = 0;

        if(-1 < local_code_table_index) {
            /* 지역번호 또는 모바일 번호를 검사하는 국가코드인 경우
             */
            country_code_length = filterCountryCode(cut_number);
            cut_number = cut_number.substr(country_code_length);

            if(0 < country_code_length) {
                /* 서비스 코드, 국가코드 모두 찾은 상태
                 */
                var mobile_code_length = filterMobileCode(local_code_table_index, cut_number, true);
                cut_number = cut_number.substr(mobile_code_length);

                if(0 < mobile_code_length) {
                    // [PATTERN] 001-82-10-000-0000 or 001-82-10-0000-0000
                    number_debug("-- case 1");
                    if(true == plus_call) {
                        format_count = 2;
                        reg_expr = "([0-9,*,#,+]{" + (country_code_length + 1) + "})([0-9,*,#,+]{" + mobile_code_length + "})";
                    } else {
                        format_count = 3;
                        reg_expr = "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+]{" + country_code_length + "})([0-9,*,#,+]{" + mobile_code_length + "})";
                    }

                    if(0 < cut_number.length) {
                        if(4 > cut_number.length) {
                            number_debug("-- case 1-1");
                            format_count++;
                            reg_expr += "([0-9,*,#,+])";
                        } else if(8 > cut_number.length) {
                            number_debug("-- case 1-2");
                            format_count += 2;
                            reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
                        } else {
                            /*if(0 == local_code_table_index) {
                                // 한국의 경우 4-4 패턴을 추가함
                                if(8 == cut_number.length) {
                                    number_debug("-- case 2-4");
                                    format_count += 2;
                                    reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
                                } else {
                                    // [PATTERN] 0000-0000 을 벗어난 경우 - 삽입하지 않음
                                    number_debug("-- case 2-5");
                                    return phone_number;
                                }
                            } else*/ {
                                // [PATTERN] 000-0000 을 벗어난 경우 - 삽입하지 않음
                                number_debug("-- case 2-5");
                                return phone_number;
                            }
                        }
                    }
                } else {
                    // 지역코드 검사
                    var local_code_length = filterLocalCode(local_code_table_index, cut_number, true);
                    cut_number = cut_number.substr(local_code_length);

                    if(0 < local_code_length) {
                        number_debug("-- case 2");
                        if(true == plus_call) {
                            format_count = 2;
                            reg_expr = "([0-9,*,#,+]{" + (country_code_length + 1) + "})([0-9,*,#,+]{" + local_code_length + "})";
                        } else {
                            format_count = 3;
                            reg_expr = "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+]{" + country_code_length + "})([0-9,*,#,+]{" + local_code_length + "})";
                        }

                        if(0 < cut_number.length) {
                            if(4 > cut_number.length) {
                                number_debug("-- case 2-2");
                                format_count++;
                                reg_expr += "([0-9,*,#,+])";
                            } else if(8 > cut_number.length) {
                                number_debug("-- case 2-3");
                                format_count += 2;
                                reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
                            } else {
                                /*if(0 == local_code_table_index) {
                                    // 한국의 경우 4-4 패턴을 추가함
                                    if(8 == cut_number.length) {
                                        number_debug("-- case 2-4");
                                        format_count += 2;
                                        reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
                                    } else {
                                        // [PATTERN] 0000-0000 을 벗어난 경우 - 삽입하지 않음
                                        number_debug("-- case 2-5");
                                        return phone_number;
                                    }
                                } else*/ {
                                    // [PATTERN] 000-0000 을 벗어난 경우 - 삽입하지 않음
                                    number_debug("-- case 2-5");
                                    return phone_number;
                                }
                            }
                        } else {
                            number_debug("-- case 2-1");
                        }
                    } else {
                        /* 서비스 코드, 국가코드를 찾았지만 지역코드를 못찾은 상태
                         * [PATTERN] +82-2-0000000
                         */
                        if(true == plus_call) {
                            format_count = 1;
                            reg_expr = "([0-9,*,#,+]{" + (country_code_length + 1) + "})";
                        } else {
                            format_count = 2;
                            reg_expr = "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+]{" + country_code_length + "})";
                        }

                        if(0 < cut_number.length) {
                            if(4 > cut_number.length) {
                                number_debug("-- case 3-2");
                                format_count++;
                                reg_expr += "([0-9,*,#,+])";
                            } else if(8 > cut_number.length) {
                                number_debug("-- case 3-3");
                                format_count++;
                                reg_expr += "([0-9,*,#,+]{" + cut_number.length + "})";
                            } else {
                                /*if(0 == local_code_table_index) {
                                    // 한국의 경우 4-4 패턴을 추가함
                                    if(8 == cut_number.length) {
                                        number_debug("-- case 3-4");
                                        format_count += 2;
                                        reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
                                    } else {
                                        // [PATTERN] 0000-0000 을 벗어난 경우 - 삽입하지 않음
                                        number_debug("-- case 3-5");
                                        return phone_number;
                                    }
                                } else*/ {
                                    // [PATTERN] +82-2-0000000 을 벗어난 경우 - 삽입하지 않음
                                    number_debug("-- case 3-6");
                                    return phone_number;
                                }
                            }
                        } else {
                            number_debug("-- case 3-1");
                        }
                    }
                }
            } else {
                /* 서비스 코드는 찾았지만 국가코드를 못찾은 상태
                 * [PATTERN] +8, 00 등
                 */
                if(true == plus_call) {
                    number_debug("-- case 4-1");
                    format_count = 1;
                    reg_expr = "([0-9,*,#,+])";
                } else {
                    if(8 > cut_number.length) {
                        number_debug("-- case 4-2");
                        format_count = 2;
                        reg_expr = "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+])";
                    } else {
                        /*if(0 == local_code_table_index) {
                            // 한국의 경우 4-4 패턴을 추가함
                            if(8 == cut_number.length) {
                                number_debug("-- case 4-3");
                                format_count += 2;
                                reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
                            } else {
                                // [PATTERN] 0000-0000 을 벗어난 경우 - 삽입하지 않음
                                number_debug("-- case 4-4");
                                return phone_number;
                            }
                        } else*/ {
                            // [PATTERN] 000-000-0000 을 벗어난 경우 - 삽입하지 않음
                            number_debug("-- case 4-4");
                            return phone_number;
                        }
                    }
                }
            }
        } else {
            /* 지역번호를 검사하지 않는 국가코드인 경우
             */
            country_code_length = filterCountryCode(cut_number);
            cut_number = cut_number.substr(country_code_length);

            if(0 < country_code_length) {
                // [PATTERN] 001-465-0000000, +465-000-0000
                number_debug("-- case 10");
                if(true == plus_call) {
                    format_count = 1;
                    reg_expr = "([0-9,*,#,+]{" + (country_code_length + 1) + "})";
                } else {
                    format_count = 2;
                    reg_expr = "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+]{" + country_code_length + "})([0-9,*,#,+]{" + mobile_code_length + "})";
                }

                if(0 < cut_number.length) {
                    if(8 > cut_number.length) {
                        // [PATTERN] 001-465-0000000
                        number_debug("-- case 10-1");
                        format_count++;
                        reg_expr += "([0-9,*,#,+]{" + cut_number.length + "})";
                    } else {
                        // [PATTERN] 001-465-0000000 을 벗어난 경우 - 삽입하지 않음
                        number_debug("-- case 10-2");
                        return phone_number;
                    }

                    number_debug(reg_expr);
                }
            } else {
                /* 서비스 코드는 찾았지만 국가코드는 못찾은 상태
                 * [PATTERN] +8, 00 등
                 */
                if(true == plus_call) {
                    number_debug("-- case 11-1");
                    format_count = 1;
                    reg_expr = "([0-9,*,#,+])";
                } else {
                    if(8 > cut_number.length) {
                        // [PATTERN] 001-465-0000000
                        number_debug("-- case 3-2");
                        format_count = 2;
                        reg_expr = "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+]{3})([0-9,*,#,+])";
                    } else {
                        // [PATTERN] 001-465-0000000 을 벗어난 경우 001-465-000-000000.. 형태를 유지함
                        number_debug("-- case 3-4");
                        format_count = 3;
                        reg_expr =  "([0-9,*,#,+]{" + service_code_length + "})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (phone_number.length - 6) + "})";
                    }
                }
            }
        }

        // Generate!!
        return generateNumberForm(phone_number, format_count, reg_expr);
    }

    /* 지역번호와 무관하게 3-3-4 패턴으로 표시할때만 사용(북미전용)
     */
    function processNorthAmericaInternational(phone_number, plus_call, service_code_length, country_variant) {
        var reg_expr = "";
        var format_count = 0;

        var cut_number = "";

        /* 북미 국제전화는  +1, 011 인 경우만 PATTERN 유지함 +1-000-000-0000, 011-000-0000
         */
/*DEPRECATED
        service_code_length = filterServiceCode(getTableIndexFromVariant(country_variant), phone_number);
        if(0 < service_code_length) {
            cut_number = phone_number.substr(service_code_length);

            format_count = 1;
            reg_expr = "([0-9,*,#,+]{" + service_code_length + "})";
        } else {
            // 발생하지 않음
            cut_number = phone_number;
        }

        if(0 < cut_number.length) {
            if(3 > service_code_length) {
                // [PATTERN] +1 인 경우, +1-000-000-0000
                if(5 > cut_number.length) {
                    format_count++;
                    reg_expr += "([0-9,*,#,+])";
                } else if(8 > cut_number.length) {
                    format_count += 2;
                    reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
                } else {
                    // [PATTERN] +1-000-000-0000을 벗어난 경우 - +1-000-000-0000  패턴을 계속 유지
                    format_count += 3;
                    reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (cut_number.length - 6) + "})";
                }
            } else {
                // [PATTERN] 011 인 경우, 011-000-0000
                if(4 > cut_number.length) {
                    format_count++;
                    reg_expr += "([0-9,*,#,+])";
                } else {
                    // [PATTERN] 011-000-0000 을 벗어난 경우 - 000-000-0000  패턴을 계속 유지
                    format_count += 3;
                    reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+]{" + (cut_number.length - 6) + "})";
                }
            }
        }
DEPRECATED*/

        if(6 > phone_number.length) {
            return phone_number;
        }

        cut_number = phone_number.substr(service_code_length);

        if("1" == cut_number[0]) {
            cut_number = cut_number.substr(1);

            var i = 0;
            for(/* var i = 0 */; i < cut_number.length; i++) {
                // do nothing
                if("1" != cut_number[i]) { break; }
            }

            if(i < cut_number.length) {
                if(4 > i) {
                    // [PATTERN] +1111-XXX-XXX-XXXXXXX
                    cut_number = cut_number.substr(i);

                    if(8 > cut_number.length) {
                        // +1111-XXX-XXXX
                        format_count = 3;
                        reg_expr =  "([0-9,*,#,+]{" + (i + 2) + "})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (cut_number.length - 3)+ "})";
                    } else {
                        format_count = 4;
                        reg_expr =  "([0-9,*,#,+]{" + (i + 2) + "})([0-9,*,#,+]{3})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (cut_number.length - 6)+ "})";
                    }
                } else {
                    // [PATTERN] +111111-XXX-XXXXXXXX
                    cut_number = cut_number.substr(i);

                    if(4 > cut_number.length) {
                        // [PATTERN] +111111-XXX
                        format_count = 2;
                        reg_expr =  "([0-9,*,#,+]{" + (i + 2) + "})([0-9,*,#,+]{" + (cut_number.length - i)+ "})";
                    } else {
                        // [PATTERN] +111111-XXX-XXXXXXXXXXXXx
                        format_count = 3;
                        reg_expr =  "([0-9,*,#,+]{" + (i + 2) + "})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (cut_number.length - (3 + i))+ "})";
                    }
                }
            } else {
                // [PATTERN] +1111111111111111111111
                return phone_number;
            }
        } else {
            // [PATTERN] +XXXXXXXXXXXXX....
            return phone_number;
        }

        // Generate!!
        return generateNumberForm(phone_number, format_count, reg_expr);
    }

    /* 북미향
     */
    function processNorthAmerica(phone_number, country_variant) {
        var format_count = 0;
        var reg_expr = "";

        // 지역코드 검사
/*DEPRECATED
        var local_code_length = filterLocalCode(getTableIndexFromVariant(country_variant), phone_number, false);
        var cut_number = phone_number.substr(local_code_length);

        if(0 < local_code_length) {
            // 지역코드를 찾은 경우
            // [PATTERN] 000-000-0000
            number_debug("-- [America] case 1");
            format_count = 1;
            reg_expr = "([0-9,*,#,+]{" + local_code_length + "})";

            if(4 > cut_number.length) {
                // [PATTERN] 000
                number_debug("-- [America] case 1-1");
                format_count++;
                reg_expr += "([0-9,*,#,+])";
            } else if(8 > cut_number.length) {
                // [PATTERN] 000-000-0000
                number_debug("-- [America] case 1-2");
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
            } else {
                // [PATTERN] 000-000-0000을 벗어난 경우 000-000-00000000... 형태를 유지함
                number_debug("-- [America] case 1-3");
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+]{" + (cut_number.length - 3)+ "})";
            }
        } else {
            // 지역 코드를 찾지 못한 경우
            number_debug("-- [America] case 2");
            return phone_number;
        }
DEPRECATED*/

        /* 아래 코드는 지역번호 무관하게 3-3-4 패턴에 맞춘 코드로 필요시 위 코드와 대체하여 사용할 것
         */
        if(6 > phone_number.length) {
            // 1 ~ 5자리 까지는 - 삽입 없이 출력
             return phone_number;
        }

        // [PATTERN] 000-000-0000
        if(1 != phone_number[0]) {
            // 제일 앞자리가 1이 아닌 경우
            if(6 > phone_number.length) {
                // [PATTERN] 000
                format_count = 1;
                reg_expr = "([0-9,*,#,+])";
            } else if(7 > phone_number.length) {
                // [PATTERN] 000-000
                format_count = 2;
                reg_expr = "([0-9,*,#,+]{" + (phone_number.length - 3) + "})([0-9,*,#,+]{3})";
            } else if(8 > phone_number.length) {
                format_count = 2;
                reg_expr = "([0-9,*,#,+]{" + (phone_number.length - 4) + "})([0-9,*,#,+]{4})";
            } else {
                // [PATTERN] 000-000-0000
                format_count = 3;
                reg_expr = "([0-9,*,#,+]{3})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (phone_number.length - 6) + "})";
            } 
        } else {
            // 제일 앞자리가 1 또는 011 인 경우
            if(9 > phone_number.length) {
                // [PATTERN] 000
                format_count = 3;
                reg_expr = "([0-9,*,#,+]{1})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (phone_number.length - 4) + "})";
            } else {
                // [PATTERN] 000-000-0000
                format_count = 4;
                reg_expr = "([0-9,*,#,+]{1})([0-9,*,#,+]{3})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (phone_number.length - 7) + "})";
            } 
        }

        // Generate!!
        return generateNumberForm(phone_number, format_count, reg_expr);
    }

    /**
     *
     */
    function processKorea(phone_number, country_variant) {
        var reg_expr = "";
        var format_count = 0;

        var table_index = getTableIndexFromVariant(country_variant);

        // 모바일 번호 검사
        var mobile_code_length = filterMobileCode(table_index, phone_number, false);
        var cut_number = phone_number.substr(mobile_code_length);

        if(0 < mobile_code_length) {
            // 모바일 번호가 있을 경우(e.g. 011, 010, ... )
            number_debug("-- [Korea] case 1");
            format_count = 1;
            reg_expr = "([0-9,*,#,+]{" + mobile_code_length + "})";

            if(4 > cut_number.length) {
                // [PATTERN] 001-000
                format_count++;
                reg_expr += "([0-9,*,#,+])";
            } else if(8 > cut_number.length) {
                // [PATTERN] 001-000-0000
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
            } /*else if(8 == cut_number.length) {
                // [PATTERN] 001-0000-0000
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
            }*/ else {
                // [PATTERN] 001-0000-0000 을 벗어난 경우 001-0000-00000000... 형태를 유지함
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+]{" + (cut_number.length - 4)+ "})"
            }
        } else {
            // 모바일 번호가 없는 경우, 지역번호 검사
            var local_code_length = filterLocalCode(table_index, cut_number, false);
            cut_number = cut_number.substr(local_code_length);

            if(0 < local_code_length) {
                // 지역번호가 있는 경우(e.g. 02, 031... )
                format_count = 1;
                reg_expr = "([0-9,*,#,+]{" + local_code_length + "})";

                if(4 > cut_number.length) {
                    format_count++;
                    reg_expr += "([0-9,*,#,+])";
                } else if(8 > cut_number.length) {
                    format_count += 2;
                    reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
                } /*else if(8 == cut_number.length) {
                    format_count += 2;
                    reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
                }*/ else {
                    // [PATTERN] 02-0000-0000을 벗어난 경우 02-0000-00000000.. 형태를 유지함
                    format_count += 2;
                    reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+]{" + (cut_number.length - 4)+ "})"
                }
            } else {
                // 모바일 번호, 지역번호 모두 없는 경우
                if(4 > cut_number.length) {
                    // [PATTERN] 000
                    format_count = 1;
                    reg_expr = "([0-9,*,#,+])";
                } else if(8 > cut_number.length) {
                    // [PATTERN] 000-0000
                    format_count = 2;
                    reg_expr = "([0-9,*,#,+]{3})([0-9,*,#,+])";
                } /*else if(8 == cut_number.length) {
                    // [PATTERN] 0000-0000
                    format_count = 2;
                    reg_expr = "([0-9,*,#,+]{4})([0-9,*,#,+])"
                }*/ else {
                    // [PATTERN] 0000-0000 을 벗어난 경우 0000-00000000... 형태를 유지함
                    format_count = 2;
                    reg_expr = "([0-9,*,#,+]{4})([0-9,*,#,+]{" + (phone_number.length - 4)+ "})"
                }
            }
        }

        // Generate!!
        return generateNumberForm(phone_number, format_count, reg_expr);
    }

    /*
     */
    function processGeneral(phone_number) {
        // 유럽, 중동, (일반?) 향지는 - 모두 제거 by HMC
        return phone_number;

/*DEPRECATED
        var reg_expr = "";
        var format_count = 0;

        if(4 > phone_number.length) {
            // [PATTERN] 000
            number_debug("[general] case 1");
            format_count = 1;
            reg_expr = "([0-9,*,#,+])";
        } else if(7 > phone_number.length) {
            // [PATTERN] 000-000
            number_debug("[general] case 2");
            format_count = 2;
            reg_expr = "([0-9,*,#,+]{3})([0-9,*,#,+])";
        } else if(11 > phone_number.length) {
            // [PATTERN] 000-000-0000
            number_debug("[general] case 3");
            format_count = 3;
            reg_expr = "([0-9,*,#,+]{3})([0-9,*,#,+]{3})([0-9,*,#,+])";
        } else {
            // [PATTERN] 000-0000 을 벗어난 경우 000-000-00000000... 형태를 유지함
            number_debug("[general] case 4");
            format_count = 3;
            reg_expr = "([0-9,*,#,+]{3})([0-9,*,#,+]{3})([0-9,*,#,+]{" + (phone_number.length - 6) + "})";

        }

        // Generate!!
        return generateNumberForm(phone_number, format_count, reg_expr);
DEPRECATED*/
    }

    /**
     *
     */
    function processMiddleEast(phone_number, country_variant) {
        var table_index = getTableIndexFromVariant(country_variant);
        return phone_number;
    }

    /**
     *
     */
    function processEurope(phone_number, country_variant) {
        var table_index = getTableIndexFromVariant(country_variant);
        return phone_number;
    }

    /**
     *
     */
    function processChina(phone_number, country_variant) {
        var reg_expr = "";
        var format_count = 0;

        var table_index = getTableIndexFromVariant(country_variant);

        // 모바일 번호 검사
        var mobile_code_length = filterMobileCode(table_index, phone_number, false);
        var cut_number = phone_number.substr(mobile_code_length);

        if(0 < mobile_code_length) {
            // 모바일 번호가 있을 경우(e.g. 011, 010, ... )
            qml_debug("-- [Korea] case 1");
            format_count = 1;
            reg_expr = "([0-9,*,#,+]{" + mobile_code_length + "})";

            if(4 > cut_number.length) {
                // [PATTERN] 001-000
                qml_debug("-- [Korea] case 1 - 1");
                format_count++;
                reg_expr += "([0-9,*,#,+])";
            } else if(8 > cut_number.length) {
                // [PATTERN] 001-000-0000
                qml_debug("-- [Korea] case 1 - 2");
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
            } /*else if(8 == cut_number.length) {
                // [PATTERN] 001-0000-0000
                qml_debug("-- [Korea] case 1 - 3");
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
            }*/ else {
                // [PATTERN] 001-0000-0000 을 벗어난 경우 001-0000-00000000... 형태를 유지함
                qml_debug("-- [Korea] case 1 - 4");
                format_count += 2;
                reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+]{" + (cut_number.length - 4)+ "})"
            }
        } else {
            // 모바일 번호가 없는 경우, 지역번호 검사
            var local_code_length = filterLocalCode(table_index, cut_number, false);
            cut_number = cut_number.substr(local_code_length);

            if(0 < local_code_length) {
                // 지역번호가 있는 경우(e.g. 02, 031... )
                qml_debug("-- [Korea] case 2");
                format_count = 1;
                reg_expr = "([0-9,*,#,+]{" + local_code_length + "})";
            
                if(4 > cut_number.length) {
                    qml_debug("-- [Korea] case 2-1");
                    format_count++;
                    reg_expr += "([0-9,*,#,+])";
                } else if(8 > cut_number.length) {
                    qml_debug("-- [Korea] case 2-2");
                    format_count += 2;
                    reg_expr += "([0-9,*,#,+]{3})([0-9,*,#,+])";
                } /*else if(8 == cut_number.length) {
                    qml_debug("-- [Korea] case 2-3");
                    format_count += 2;
                    reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+])";
                }*/ else {
                    // [PATTERN] 02-0000-0000을 벗어난 경우 02-0000-00000000.. 형태를 유지함
                    qml_debug("-- [Korea] case 2-4");
                    format_count += 2;
                    reg_expr += "([0-9,*,#,+]{4})([0-9,*,#,+]{" + (cut_number.length - 4)+ "})"
                }
            } else {
                // 모바일 번호, 지역번호 모두 없는 경우
                qml_debug("-- [Korea] case 3");
                if(4 > cut_number.length) {
                    // [PATTERN] 000
                    qml_debug("-- [Korea] case 3-1");
                    format_count = 1;
                    reg_expr = "([0-9,*,#,+])";
                } else if(8 > cut_number.length) {
                    // [PATTERN] 000-0000
                    qml_debug("-- [Korea] case 3-2");
                    format_count = 2;
                    reg_expr = "([0-9,*,#,+]{3})([0-9,*,#,+])";
                } /*else if(8 == cut_number.length) {
                    // [PATTERN] 0000-0000
                    qml_debug("-- [Korea] case 3-3");
                    format_count = 2;
                    reg_expr = "([0-9,*,#,+]{4})([0-9,*,#,+])"
                }*/ else {
                    // [PATTERN] 0000-0000 을 벗어난 경우 0000-00000000... 형태를 유지함
                    qml_debug("-- [Korea] case 3-4");
                    format_count = 2;
                    reg_expr = "([0-9,*,#,+]{4})([0-9,*,#,+]{" + (phone_number.length - 4)+ "})"
                }
            }
        }

        // Generate!!
        return generateNumberForm(phone_number, format_count, reg_expr);
    }
}
/* EOF */
