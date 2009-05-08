/** 
 * This code is free software; you can redistribute it and/or modify it under
 * the terms of the new BSD License.
 *
 * Copyright (c) 2009, Sebastian Staudt
 */

#import <arpa/inet.h>
#import <netinet/in.h>

#import "SteamCondenserException.h"
#import "TCPSocket.h"


@implementation TCPSocket

-(void) connectWithHost:(NSHost*) aHost andPort:(unsigned short) aPort {
    remoteHost = aHost;
    remotePort = aPort;
    
    struct sockaddr_in remoteSocket;
    remoteSocket.sin_family = AF_INET;
    remoteSocket.sin_port = htons(remotePort);
    NSString* address;
    NSEnumerator* addressEnumerator = [[remoteHost addresses] objectEnumerator];
    while(address = [addressEnumerator nextObject]) {
        if(inet_pton(AF_INET, [address cStringUsingEncoding:NSASCIIStringEncoding], &remoteSocket.sin_addr) == 1) {
            break;
        }
    }
    
    fdsocket = socket(AF_INET, SOCK_STREAM, 0);
    if(fdsocket < 0) {
        @throw [[SteamCondenserException alloc] initWithMessage:[NSString stringWithFormat:@"Error creating socket: %s", strerror(errno)]];
    }
    
    if(connect(fdsocket, (struct sockaddr*) &remoteSocket, sizeof(remoteSocket)) < 0) {
        @throw [[SteamCondenserException alloc] initWithMessage:[NSString stringWithFormat:@"Error connecting socket: %s", strerror(errno)]];
    }
    
    if(!isBlocking) {
        fcntl(fdsocket, F_SETFL, O_NONBLOCK);
    }
    else {
        fcntl(fdsocket, F_SETFL, 0);
    }
}

@end
