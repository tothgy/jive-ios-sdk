//
//  NSErrorJiveTests.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 2/28/13.
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

#import <XCTest/XCTest.h>
#import "NSError+Jive.h"

@interface NSErrorJiveTests : XCTestCase

@end

@implementation NSErrorJiveTests

- (void)testNoJSON {
    NSError *nativeError = [[NSError alloc] initWithDomain:@"AFNetworkingErrorDomain"
                                                      code:404
                                                  userInfo:nil];
    NSError *jiveError = [NSError jive_errorWithUnderlyingError:nativeError
                                                       JSON:nil];
    
    XCTAssertEqualObjects(jiveError.domain, JiveErrorDomain, @"Not Jive Error Domain");
    XCTAssertEqual(jiveError.code, nativeError.code, @"Native error code not duplicated");
    XCTAssertNil(jiveError.localizedRecoverySuggestion, @"Missing message found");
    XCTAssertEqualObjects(jiveError.jive_HTTPStatusCode, @0, @"Wrong status code reported");
}

- (void)testBasicJSONError {
    NSString *message = @"'The specified name is too long. 18 is the max length permitted.'";
    NSNumber *status = [NSNumber numberWithInt:409];
    NSString *description = [NSString stringWithFormat:@"Expected status code in (200-299), got %@", status];
    NSDictionary *JSONError = @{@"error": @{@"message":message, @"status":status}};
    NSDictionary *userInfo = @{@"NSLocalizedRecoverySuggestion":[NSString stringWithFormat:@"{\"error\":{\"message\":%@,\"status\":%@}}", message, status],
                               @"NSLocalizedDescription":description};
    NSError *nativeError = [[NSError alloc] initWithDomain:@"AFNetworkingErrorDomain"
                                                      code:404
                                                  userInfo:userInfo];
    NSError *jiveError = [NSError jive_errorWithUnderlyingError:nativeError
                                                       JSON:JSONError];
    
    XCTAssertEqualObjects(jiveError.domain, JiveErrorDomain, @"Not Jive Error Domain");
    XCTAssertEqual(jiveError.code, nativeError.code, @"Native error code not duplicated");
    XCTAssertEqualObjects(jiveError.localizedDescription, nativeError.localizedDescription, @"Native error not duplicated");
    XCTAssertEqualObjects(jiveError.localizedFailureReason, nativeError.localizedFailureReason, @"Native error not duplicated");
    XCTAssertEqualObjects(jiveError.localizedRecoveryOptions, nativeError.localizedRecoveryOptions, @"Native error not duplicated");
    XCTAssertEqualObjects(jiveError.helpAnchor, nativeError.helpAnchor, @"Native error not duplicated");
    XCTAssertEqualObjects(jiveError.localizedRecoverySuggestion, message, @"Wrong message found");
    XCTAssertEqualObjects(jiveError.jive_HTTPStatusCode, status, @"Wrong status found");
}

@end
