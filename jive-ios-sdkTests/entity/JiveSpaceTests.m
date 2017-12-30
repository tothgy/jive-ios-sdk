//
//  JiveSpaceTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/28/12.
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

#import "JiveSpaceTests.h"

@implementation JiveSpaceTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveSpace alloc] init];
}

- (JiveSpace *)space {
    return (JiveSpace *)self.place;
}

- (void)testType {
    XCTAssertEqualObjects(self.space.type, @"space", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.space.type forKey:@"type"];
    
    XCTAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.space class], @"Space class not registered with JiveTypedObject.");
    XCTAssertEqualObjects([JivePlace entityClass:typeSpecifier], [self.space class], @"Space class not registered with JivePlace.");
}

- (void)testTaskToJSON {
    NSString *tag = @"wordy";
    NSString *locale = @"Jiverado";
    NSDictionary *JSON = [self.space toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], @"space", @"Wrong type");
    
    [self.space setValue:[NSNumber numberWithInt:1] forKey:@"childCount"];
    self.space.locale = locale;
    [self.space setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    JSON = [self.space toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.space.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:@"childCount"], self.space.childCount, @"Wrong childCount");
    XCTAssertEqualObjects([JSON objectForKey:JiveSpaceAttributes.locale], locale, @"Wrong locale");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    XCTAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testTaskToJSON_alternate {
    NSString *tag = @"concise";
    NSString *locale = @"Club Fed";
    
    [self.space setValue:[NSNumber numberWithInt:5] forKey:@"childCount"];
    self.space.locale = locale;
    [self.space setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    NSDictionary *JSON = [self.space toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.space.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:@"childCount"], self.space.childCount, @"Wrong childCount");
    XCTAssertEqualObjects([JSON objectForKey:JiveSpaceAttributes.locale], locale, @"Wrong locale");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    XCTAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testPostParsing {
    NSString *tag = @"wordy";
    NSString *locale = @"Jiverado";
    
    [self.space setValue:[NSNumber numberWithInt:1] forKey:@"childCount"];
    self.space.locale = locale;
    [self.space setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.space toJSONDictionary];
    JiveSpace *newPlace = [JiveSpace objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newPlace class] isSubclassOfClass:[self.space class]], @"Wrong item class");
    XCTAssertEqualObjects(newPlace.type, self.space.type, @"Wrong type");
    XCTAssertEqualObjects(newPlace.childCount, self.space.childCount, @"Wrong childCount");
    XCTAssertEqualObjects(newPlace.locale, locale, @"Wrong locale");
    XCTAssertEqual([newPlace.tags count], [self.space.tags count], @"Wrong number of tags");
    XCTAssertEqualObjects([newPlace.tags objectAtIndex:0], tag, @"Wrong tag");
}

- (void)testPostParsingAlternate {
    NSString *tag = @"concise";
    NSString *locale = @"Club Fed";
    
    [self.space setValue:[NSNumber numberWithInt:5] forKey:@"childCount"];
    self.space.locale = locale;
    [self.space setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.space toJSONDictionary];
    JiveSpace *newPlace = [JiveSpace objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newPlace class] isSubclassOfClass:[self.space class]], @"Wrong item class");
    XCTAssertEqualObjects(newPlace.type, self.space.type, @"Wrong type");
    XCTAssertEqualObjects(newPlace.childCount, self.space.childCount, @"Wrong childCount");
    XCTAssertEqualObjects(newPlace.locale, locale, @"Wrong locale");
    XCTAssertEqual([newPlace.tags count], [self.space.tags count], @"Wrong number of tags");
    XCTAssertEqualObjects([newPlace.tags objectAtIndex:0], tag, @"Wrong tag");
}

@end
