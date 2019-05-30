//
//  OADataBlockFetcher.m
//  PicCollage
//
//  Created by Kai on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OADataBlockFetcher.h"

@interface OADataBlockFetcher ()
    <NSURLConnectionDelegate>

@property (nonatomic, copy) OADataBlockFetcherCompletedBlock completedBlock;
@property (nonatomic, retain) OAMutableURLRequest *request;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *responseData;

@end

@implementation OADataBlockFetcher
@synthesize completedBlock = _completedBlock;
@synthesize request = _request;
@synthesize response = _response;
@synthesize connection = _connection;
@synthesize responseData = _responseData;

#pragma mark - Object lifecycle

- (void)dealloc
{    
    [self cancel];    
    [super dealloc];
}

- (void)setConnection:(NSURLConnection *)connection
{
    [_connection cancel];
    [_connection autorelease];
    
    _connection = [connection retain];
}

#pragma mark - Public methods

- (void)fetchDataWithRequest:(OAMutableURLRequest *)aRequest
              completedBlock:(OADataBlockFetcherCompletedBlock)block
{
    self.completedBlock = block;
    self.request = aRequest;
    [self.request prepare];
    self.responseData = [[[NSMutableData alloc] init] autorelease];
    self.connection = [[[NSURLConnection alloc] initWithRequest:self.request delegate:self] autorelease];
    [self.connection start];
}

- (void)fetchSynchronousDataWithRequest:(OAMutableURLRequest *)aRequest 
                                 thenDo:(OADataBlockFetcherCompletedBlock)block;
{
    self.request = aRequest;
    [self.request prepare];

    NSURLResponse *response_ = nil;
    NSError *error_ = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:self.request
                                         returningResponse:&response_
                                                     error:&error_];

    BOOL didSucceed = [(NSHTTPURLResponse *)self.response statusCode] < 400;
    OAServiceTicket *ticket = 
    [[[OAServiceTicket alloc] initWithRequest:self.request
                                     response:self.response
                                         data:data
                                   didSucceed:didSucceed] 
     autorelease];
    block(self.request, ticket, error_);
}

- (void)cancel
{
    self.connection = nil;
    self.request = nil;
    self.response = nil;
    self.responseData = nil;
    self.completedBlock = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)aConnection 
didReceiveResponse:(NSURLResponse *)aResponse
{
    self.response = aResponse;
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error
{
	OAServiceTicket *ticket = 
    [[[OAServiceTicket alloc] initWithRequest:self.request
                                     response:self.response
                                         data:self.responseData
                                   didSucceed:NO] autorelease];
    
    self.completedBlock(self.request, ticket, error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    BOOL didSucceed = [(NSHTTPURLResponse *)self.response statusCode] < 400;
    OAServiceTicket *ticket = 
    [[[OAServiceTicket alloc] initWithRequest:self.request
                                     response:self.response
                                         data:self.responseData
                                   didSucceed:didSucceed] autorelease];
    self.completedBlock(self.request, ticket, nil);
}

@end
