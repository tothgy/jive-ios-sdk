//
//  JiveProfileEntry.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
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

#import "JiveObject.h"

extern struct JiveProfileEntryAttributes {
    __unsafe_unretained NSString *jive_label;
    __unsafe_unretained NSString *value;
} const JiveProfileEntryAttributes;

//! \class JiveProfileEntry
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/ProfileEntity.html
@interface JiveProfileEntry : JiveObject

//! Label for this profile entry.
@property(nonatomic, readonly, copy) NSString* jive_label;

//! Value for this profile entry.
@property(nonatomic, readonly, copy) NSString* value;

@end
