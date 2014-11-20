//
//  GTalkXMPP.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 19/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#ifndef MYOrse_GTalkXMPP_h
#define MYOrse_GTalkXMPP_h

#import "XMPP.h"

#define XMPP_TIMESTAMP @"timestamp"
#define XMPP_STATUS @"status"

#define XMPP_MESSAGE_TO @"to"
#define XMPP_MESSAGE_FROM @"from"
#define XMPP_MESSAGE_TEXT @"text"
#define XMPP_MESSAGE_USERNAME @"user"
#define XMPP_MESSAGE_TYPE @"type"
#define XMPP_MESSAGE_TYPE_CHAT @"chat"
#define XMPP_MESSAGE_TYPE_ERROR @"error"

#define XMPP_CONNECTION_OK @"ok"
#define XMPP_CONNECTION_CONNECTING @"connect"
#define XMPP_CONNECTION_AUTH @"auth"
#define XMPP_CONNECTION_ERROR_AUTH @"unauth"
#define XMPP_CONNECTION_ERROR_TIMEOUT @"timeout"
#define XMPP_CONNECTION_ERROR_REGISTER @"unregistered"
#define XMPP_CONNECTION_ERROR @"error"

#define XMPP_PRESENCE_TYPE @"type"
#define XMPP_PRESENCE_TYPE_OFFLINE @"unavailable"
#define XMPP_PRESENCE_TYPE_ONLINE @"available"
#define XMPP_PRESENCE_TYPE_ERROR @"error"
#define XMPP_PRESENCE_TYPE_UNSUB @"unsubscribe"
#define XMPP_PRESENCE_TYPE_UNSUBBED @"unsubscribed"
#define XMPP_PRESENCE_TYPE_SUB @"subscribe"
#define XMPP_PRESENCE_TYPE_SUBBED @"subscribed"
#define XMPP_PRESENCE_TYPE_PROBE @"probe"

#define XMPP_PRESENCE_STATUS @"status"
#define XMPP_PRESENCE_USERNAME @"username"
#define XMPP_PRESENCE_DOMAIN @"domain"

#define XMPP_PRESENCE_SHOW @"show"
#define XMPP_PRESENCE_SHOW_AWAY @"away"
#define XMPP_PRESENCE_SHOW_AWAY_EXTENDED @"xa"
#define XMPP_PRESENCE_SHOW_BUSY @"dnd"
#define XMPP_PRESENCE_SHOW_CHAT @"chat"

// List the modules you're using here:

//#import "XMPPBandwidthMonitor.h"

#import "XMPPCoreDataStorage.h"

#import "XMPPReconnect.h"

#import "XMPPRoster.h"
#import "XMPPRosterMemoryStorage.h"
//#import "XMPPRosterCoreDataStorage.h"

#import "XMPPGoogleSharedStatus.h"

//#import "XMPPJabberRPCModule.h"
//#import "XMPPIQ+JabberRPC.h"
//#import "XMPPIQ+JabberRPCResponse.h"
//
//#import "XMPPPrivacy.h"

#import "XMPPMUC.h"
#import "XMPPRoom.h"
#import "XMPPRoomMemoryStorage.h"
//#import "XMPPRoomCoreDataStorage.h"
//#import "XMPPRoomHybridStorage.h"

#import "XMPPvCardTempModule.h"
#import "XMPPvCardCoreDataStorage.h"

//#import "XMPPPubSub.h"
//
//#import "TURNSocket.h"
//
#import "XMPPDateTimeProfiles.h"
#import "NSDate+XMPPDateTimeProfiles.h"

#import "XMPPMessage+XEP_0085.h"
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"

//#import "XMPPTransports.h"

#import "XMPPCapabilities.h"
#import "XMPPCapabilitiesCoreDataStorage.h"

#import "XMPPvCardAvatarModule.h"

//#import "XMPPMessage+XEP_0184.h"
//
//#import "XMPPPing.h"
//#import "XMPPAutoPing.h"
//
//#import "XMPPTime.h"
//#import "XMPPAutoTime.h"
//
//#import "XMPPElement+Delay.h"



#endif
