//
//  JiveAPITestCase.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/3/12.
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
#import <OCMock/OCMock.h>
#import <UIKit/UIKit.h>

#import "JiveAsyncTestCase.h"
#import "Jive.h"
#import "JiveHTTPBasicAuthCredentials.h"
#import "MockJiveURLProtocol.h"
#import "OCMockObject+JiveAuthorizationDelegate.h"

@interface JiveAPITestCase : JiveAsyncTestCase

- (id) mockJiveURLDelegate:(NSURL*) url returningContentsOfFile:(NSString*) path;
- (id) mockJiveAuthenticationDelegate:(NSString*) username password:(NSString*) password;
- (id) mockJiveAuthenticationDelegate;

- (id) entityForClass:(Class) entityClass
        fromJSONNamed:(NSString *)jsonName;

@end
