//
//  JiveStreamTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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

#import "JiveContentTests.h"
#import "JiveStreamEntry.h"

@interface JiveStreamEntryTests : JiveContentTests

@property (nonatomic, readonly) JiveStreamEntry *stream;

@end

@implementation JiveStreamEntryTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveStreamEntry alloc] init];
}

- (JiveStreamEntry *)stream {
    return (JiveStreamEntry *)self.object;
}

- (void)testStreamEntryToJSON {
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");
    
    [self.stream setValue:@"verb" forKey:JiveStreamEntryAttributes.verb];
    
    JSON = [self.stream toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");
}

- (void)testStreamEntryPersistentJSON {
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");
    
    [self.stream setValue:@"verb" forKey:JiveStreamEntryAttributes.verb];
    
    JSON = [self.stream persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamEntryAttributes.verb], self.stream.verb, @"Wrong verb");
}

- (void)testStreamEntryPersistentJSON_alternate {
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");

    [self.stream setValue:@"noun" forKey:JiveStreamEntryAttributes.verb];
    
    JSON = [self.stream persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveStreamEntryAttributes.verb], self.stream.verb, @"Wrong verb");
}

- (void)testStreamEntryParsing {
    [self.stream setValue:@"verb" forKey:JiveStreamEntryAttributes.verb];
    
    id JSON = [self.stream persistentJSON];
    JiveStreamEntry *newStream = [JiveStreamEntry objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newStream class] isSubclassOfClass:[self.stream class]], @"Wrong item class");
    XCTAssertEqualObjects(newStream.type, self.stream.type, @"Wrong type");
    XCTAssertEqualObjects(newStream.verb, self.stream.verb, @"Wrong verb");
}

- (void)testStreamEntryParsingAlternate {
    [self.stream setValue:@"noun" forKey:JiveStreamEntryAttributes.verb];
    
    id JSON = [self.stream persistentJSON];
    JiveStreamEntry *newStream = [JiveStreamEntry objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newStream class] isSubclassOfClass:[self.stream class]], @"Wrong item class");
    XCTAssertEqualObjects(newStream.type, self.stream.type, @"Wrong type");
    XCTAssertEqualObjects(newStream.verb, self.stream.verb, @"Wrong verb");
}

@end
