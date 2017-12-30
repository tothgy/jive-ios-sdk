//
//  JiveUpdateTests.m
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

#import "JiveUpdateTests.h"

@implementation JiveUpdateTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveUpdate alloc] init];
}

- (JiveUpdate *)update {
    return (JiveUpdate *)self.content;
}

- (void)testType {
    XCTAssertEqualObjects(self.update.type, @"update", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.update.type
                                                                            forKey:JiveTypedObjectAttributes.type];
    
    XCTAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.update class], @"Update class not registered with JiveTypedObject.");
    XCTAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.update class], @"Update class not registered with JiveContent.");
}

- (void)initializeUpdate {
    JiveUpdate *repost = [JiveUpdate new];
    
    [repost setValue:@222 forKeyPath:JiveUpdateAttributes.latitude];
    [self.update setValue:@1.234 forKey:JiveUpdateAttributes.latitude];
    [self.update setValue:@-0.456 forKey:JiveUpdateAttributes.longitude];
    [self.update setValue:repost forKeyPath:JiveUpdateAttributes.repost];
    self.update.visibility = @"place";
}

- (void)initializeAlternateUpdate {
    JiveUpdate *repost = [JiveUpdate new];
    
    [repost setValue:@1.543 forKeyPath:JiveUpdateAttributes.latitude];
    [self.update setValue:@-123.4 forKey:JiveUpdateAttributes.latitude];
    [self.update setValue:@22.6 forKey:JiveUpdateAttributes.longitude];
    [self.update setValue:repost forKeyPath:JiveUpdateAttributes.repost];
    self.update.visibility = @"all";
}

- (void)testUpdateToJSON {
    NSDictionary *JSON = [self.update toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"update", @"Wrong type");
    
    [self initializeUpdate];
    
    JSON = [self.update toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.update.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveUpdateAttributes.visibility], self.update.visibility, @"Wrong visibility");
}

- (void)testUpdateToJSON_alternate {
    [self initializeAlternateUpdate];
    
    NSDictionary *JSON = [self.update toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveUpdateAttributes.visibility], self.update.visibility, @"Wrong visibility");
}

- (void)testUpdatePersistentJSON {
    NSDictionary *JSON = [self.update persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"update", @"Wrong type");
    
    [self initializeUpdate];
    
    JSON = [self.update persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.update.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveUpdateAttributes.latitude], self.update.latitude, @"Wrong latitude");
    XCTAssertEqualObjects(JSON[JiveUpdateAttributes.longitude], self.update.longitude, @"Wrong longitude");
    XCTAssertEqualObjects(JSON[JiveUpdateAttributes.visibility], self.update.visibility, @"Wrong visibility");
    
    NSDictionary *repostJSON = JSON[JiveUpdateAttributes.repost];
    
    XCTAssertTrue([[repostJSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([repostJSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(repostJSON[JiveTypedObjectAttributes.type], self.update.repost.type, @"Wrong type");
    XCTAssertEqualObjects(repostJSON[JiveUpdateAttributes.latitude], self.update.repost.latitude, @"Wrong latitude");
}

- (void)testUpdatePersistentJSON_alternate {
    [self initializeAlternateUpdate];
    
    NSDictionary *JSON = [self.update persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.update.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveUpdateAttributes.latitude], self.update.latitude, @"Wrong latitude");
    XCTAssertEqualObjects(JSON[JiveUpdateAttributes.longitude], self.update.longitude, @"Wrong longitude");
    XCTAssertEqualObjects(JSON[JiveUpdateAttributes.visibility], self.update.visibility, @"Wrong visibility");
    
    NSDictionary *repostJSON = JSON[JiveUpdateAttributes.repost];
    
    XCTAssertTrue([[repostJSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([repostJSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(repostJSON[JiveTypedObjectAttributes.type], self.update.repost.type, @"Wrong type");
    XCTAssertEqualObjects(repostJSON[JiveUpdateAttributes.latitude], self.update.repost.latitude, @"Wrong latitude");
}

- (void)testUpdateParsing {
    [self initializeUpdate];
    
    id JSON = [self.update persistentJSON];
    JiveUpdate *newContent = [JiveUpdate objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.update class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.update.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.latitude, self.update.latitude, @"Wrong latitude");
    XCTAssertEqualObjects(newContent.longitude, self.update.longitude, @"Wrong longitude");
    XCTAssertEqualObjects(newContent.repost.latitude, self.update.repost.latitude, @"Wrong repost");
    XCTAssertEqualObjects(newContent.visibility, self.update.visibility, @"Wrong visibility");
}

- (void)testUpdateParsingAlternate {
    [self initializeAlternateUpdate];
    
    id JSON = [self.update persistentJSON];
    JiveUpdate *newContent = [JiveUpdate objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.update class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.update.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.latitude, self.update.latitude, @"Wrong latitude");
    XCTAssertEqualObjects(newContent.longitude, self.update.longitude, @"Wrong longitude");
    XCTAssertEqualObjects(newContent.repost.latitude, self.update.repost.latitude, @"Wrong repost");
    XCTAssertEqualObjects(newContent.visibility, self.update.visibility, @"Wrong visibility");
}

@end
