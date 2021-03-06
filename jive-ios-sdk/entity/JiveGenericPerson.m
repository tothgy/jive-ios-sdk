//
//  JiveGenericPerson.m
//  jive-ios-sdk
//
//  Created by Janeen Neri on 1/15/14.
//
//    Copyright 2014 Jive Software Inc.
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

#import "JiveGenericPerson.h"

struct JiveGenericPersonAttributes const JiveGenericPersonAttributes = {
	.email = @"email",
    .name = @"name",
    .person = @"person",
};

@implementation JiveGenericPerson
@synthesize email, name, person;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:email forKey:JiveGenericPersonAttributes.email];
    [dictionary setValue:name forKey:JiveGenericPersonAttributes.name];
    
    return dictionary;
}

-(id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    if (person)
        [dictionary setValue:[person persistentJSON] forKey:JiveGenericPersonAttributes.person];
    
    return dictionary;
}

@end
