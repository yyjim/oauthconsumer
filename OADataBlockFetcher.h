//
//  OADataBlockFetcher.h
//  PicCollage
//
//  Created by Kai on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAMutableURLRequest.h"
#import "OAServiceTicket.h"

typedef void (^OADataBlockFetcherCompletedBlock)(OAMutableURLRequest *request, 
                                                 OAServiceTicket *ticket, 
                                                 NSError *error);
@interface OADataBlockFetcher : NSObject

- (void)fetchDataWithRequest:(OAMutableURLRequest *)aRequest 
              completedBlock:(OADataBlockFetcherCompletedBlock)block;

- (void)fetchSynchronousDataWithRequest:(OAMutableURLRequest *)aRequest 
                                 thenDo:(OADataBlockFetcherCompletedBlock)block;

- (void)cancel;
@end
