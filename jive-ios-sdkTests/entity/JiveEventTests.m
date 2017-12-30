//
//  JiveEventTests.m
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/25/13.
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

#import "JiveEventTests.h"


@implementation JiveEventTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveEvent alloc] init];
}

- (JiveEvent *)event {
    return (JiveEvent *)self.content;
}

- (void)testType {
    XCTAssertEqualObjects(self.event.type, @"event", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.event.type forKey:@"type"];
    
    XCTAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.event class], @"event class not registered with JiveTypedObject.");
    XCTAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.event class], @"event class not registered with JiveContent.");
}

@end
