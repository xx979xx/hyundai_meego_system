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
    id: facebookAccountContent
    connectionManager: "gabble"
    protocol: "jabber"
    icon: "im-facebook"

    onAboutToCreateAccount: {
        // we need to add @chat.facebook.com to the account name
        if(accountHelper.displayName.indexOf("@chat.facebook.com") < 0) {
            accountHelper.displayName += "@chat.facebook.com";
        }

        // and we also need to set the server
        accountHelper.setAccountParameter("server", "chat.facebook.com");
    }
}
