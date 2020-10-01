/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.App.IM 0.1

AccountContent {
    id: googleTalkAccountContent
    connectionManager: "gabble"
    protocol: "jabber"
    icon: "im-google-talk"

    onAboutToCreateAccount: {
        // if the user didn't put his full mail address, we should complete
        // using @gmail.com
        if(accountHelper.displayName.indexOf("@") < 0) {
            accountHelper.displayName += "@gmail.com";
        }

        // set the server
        accountHelper.setAccountParameter("server", "talk.google.com");
    }
}
