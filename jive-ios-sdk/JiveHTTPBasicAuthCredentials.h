//
//  JiveHTTPBasicAuthCredentials.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 4/30/13.
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

#import <Foundation/Foundation.h>
#import "JiveCredentials.h"

//! \class JiveHTTPBasicAuthCredentials
@interface JiveHTTPBasicAuthCredentials : NSObject<JiveCredentials,NSCoding>

@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *password;

//! Initialize the credentials object with a username and password.
- (id)initWithUsername:(NSString *)username
              password:(NSString *)password;

@end
