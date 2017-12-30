//
//  JiveRetryingHTTPRequestOperationTests.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/21/13.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

#import "JiveRetryingHTTPRequestOperationTests.h"
#import "JiveRetryingHTTPRequestOperation.h"

@implementation JiveRetryingHTTPRequestOperationTests {
    AFHTTPRequestOperation<JiveRetryingOperation> *testObject;
}

#pragma mark - SenTestCase

- (void)setUp {
    [super setUp];
    
    testObject = [[[self classUnderTest] alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]]];
}

#pragma mark - JiveRetryingURLConnectionOperationTests

- (Class)classUnderTest {
    return [JiveRetryingHTTPRequestOperation class];
}

#pragma mark - tests

- (void)testClassUnderTestIsSubclassOfAFHTTPRequestOperation {
    XCTAssertTrue([[self classUnderTest] isSubclassOfClass:[AFHTTPRequestOperation class]]);
}

- (void)testCanProcessRequestYESOnlyForExactJiveRetryingHTTPRequestOperationClass {
    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
    XCTAssertTrue([JiveRetryingHTTPRequestOperation canProcessRequest:URLRequest]);
}

- (void)testSuccessCallback {
    [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
        return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
    })
                              withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self successCallbackOHHTTPStubsResponseWithResponder:nil];
    })];
    
    BOOL __block successCalled = NO;
    BOOL __block failureCalled = NO;
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        [testObject setCompletionBlockWithSuccess:(^(AFHTTPRequestOperation *operation, id responseObject) {
            successCalled = YES;
            finishedBlock();
        })
                                          failure:(^(AFHTTPRequestOperation *operation, NSError *error) {
            failureCalled = YES;
            finishedBlock();
        })];
        
        [testObject start];
    });
    // give the failure block a chance to run
    // in case it got tacked onto the end of the run loop somehow
    [self delay];
    
    XCTAssertTrue(successCalled);
    XCTAssertFalse(failureCalled);
}

- (void)testFailureCallback {
    [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
        return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
    })
                              withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithError:testError];
    })];
    
    BOOL __block successCalled = NO;
    BOOL __block failureCalled = NO;
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        [testObject setCompletionBlockWithSuccess:(^(AFHTTPRequestOperation *operation, id responseObject) {
            successCalled = YES;
            finishedBlock();
        })
                                          failure:(^(AFHTTPRequestOperation *operation, NSError *error) {
            failureCalled = YES;
            finishedBlock();
        })];
        
        [testObject start];
    });
    // give the success block a chance to run
    // in case it got tacked onto the end of the run loop somehow
    [self delay];
    
    XCTAssertFalse(successCalled);
    XCTAssertTrue(failureCalled);
    
    XCTAssertEqualObjects([testObject.error domain], [testError domain]);
    XCTAssertEqual([testObject.error code], [testError code]);
}

- (void)testFailureCallbackBecauseOfStatusCode {
    [OHHTTPStubs shouldStubRequestsPassingTest:(^BOOL(NSURLRequest *request) {
        return [[[request URL] absoluteString] isEqualToString:@"http://example.com"];
    })
                              withStubResponse:(^OHHTTPStubsResponse *(NSURLRequest *request) {
        OHHTTPStubsResponse *response = [self successCallbackOHHTTPStubsResponseWithResponder:nil];
        response.statusCode = 401;
        return response;
    })];
    
    BOOL __block successCalled = NO;
    BOOL __block failureCalled = NO;
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        [testObject setCompletionBlockWithSuccess:(^(AFHTTPRequestOperation *operation, id responseObject) {
            successCalled = YES;
            finishedBlock();
        })
                                          failure:(^(AFHTTPRequestOperation *operation, NSError *error) {
            failureCalled = YES;
            finishedBlock();
        })];
        
        [testObject start];
    });
    // give the success block a chance to run
    // in case it got tacked onto the end of the run loop somehow
    [self delay];
    
    XCTAssertFalse(successCalled);
    XCTAssertTrue(failureCalled);
    
    XCTAssertEqualObjects([testObject.error domain], AFNetworkingErrorDomain);
    XCTAssertEqual([testObject.error code], (NSInteger)NSURLErrorBadServerResponse);
}

- (void)testInvalidRequestOperation {
    __block BOOL errorReporterCalled = NO;
    
    waitForTimeout(^(dispatch_block_t finishedBlock) {
        NSOperation *operation = [[self classUnderTest] createOperationForInvalidRequest:^{
            errorReporterCalled = YES;
            finishedBlock();
        }];
        
        XCTAssertNotNil(operation, @"We didn't get a real operation");
        XCTAssertTrue([operation conformsToProtocol:@protocol(JiveRetryingOperation)], @"The operation must respond to JiveRetryingOperation");
        [operation start];
        XCTAssertFalse(errorReporterCalled, @"Wait for it");
    });
    
    XCTAssertTrue(errorReporterCalled, @"Do it now");
}

@end
