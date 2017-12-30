//
//  JiveActionLinkTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/27/12.
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

#import "JiveActionLinkTests.h"
#import "JiveActionLink.h"

@implementation JiveActionLinkTests

- (void)testToJSON {
    JiveActionLink *actionLink = [[JiveActionLink alloc] init];
    NSDictionary *JSON = [actionLink toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    actionLink.caption = @"text";
    actionLink.httpVerb = @"1234";
    actionLink.target = [NSURL URLWithString:@"http://dummy.com"];
    
    JSON = [actionLink toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"caption"], actionLink.caption, @"Wrong caption.");
    XCTAssertEqualObjects([JSON objectForKey:@"httpVerb"], actionLink.httpVerb, @"Wrong httpVerb.");
    XCTAssertEqualObjects([JSON objectForKey:@"target"], [actionLink.target absoluteString], @"Wrong target.");
}

- (void)testToJSON_alternate {
    JiveActionLink *actionLink = [[JiveActionLink alloc] init];
    NSDictionary *JSON = [actionLink toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    actionLink.caption = @"html";
    actionLink.httpVerb = @"6541";
    actionLink.target = [NSURL URLWithString:@"http://super.com"];
    
    JSON = [actionLink toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"caption"], actionLink.caption, @"Wrong caption.");
    XCTAssertEqualObjects([JSON objectForKey:@"httpVerb"], actionLink.httpVerb, @"Wrong httpVerb.");
    XCTAssertEqualObjects([JSON objectForKey:@"target"], [actionLink.target absoluteString], @"Wrong target.");
}

@end
