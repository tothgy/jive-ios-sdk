//
//  JiveCommentTests.m
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

#import "JiveCommentTests.h"

@implementation JiveCommentTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveComment alloc] init];
}

- (JiveComment *)comment {
    return (JiveComment *)self.content;
}

- (void)testType {
    XCTAssertEqualObjects(self.comment.type, @"comment", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.comment.type
                                                                            forKey:JiveTypedObjectAttributes.type];
    
    XCTAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.comment class], @"Comment class not registered with JiveTypedObject.");
    XCTAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.comment class], @"Comment class not registered with JiveContent.");
}

- (void)initializeCommentData {
    [self.comment setValue:@"external id" forKey:JiveCommentAttributes.externalID];
    [self.comment setValue:@"root external id" forKey:JiveCommentAttributes.rootExternalID];
    [self.comment setValue:@"rootType" forKey:JiveCommentAttributes.rootType];
    [self.comment setValue:@"rootURI" forKey:JiveCommentAttributes.rootURI];
    [self.comment setValue:[NSDate dateWithTimeIntervalSince1970:0]
                    forKey:JiveCommentAttributes.publishedCalendarDate];
    [self.comment setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                    forKey:JiveCommentAttributes.publishedTime];
}

- (void)initializeAlternateCommentData {
    [self.comment setValue:@"12345" forKey:JiveCommentAttributes.externalID];
    [self.comment setValue:@"54321" forKey:JiveCommentAttributes.rootExternalID];
    [self.comment setValue:@"post" forKey:JiveCommentAttributes.rootType];
    [self.comment setValue:@"http://dummy.com" forKey:JiveCommentAttributes.rootURI];
    [self.comment setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                    forKey:JiveCommentAttributes.publishedCalendarDate];
    [self.comment setValue:[NSDate dateWithTimeIntervalSince1970:0]
                    forKey:JiveCommentAttributes.publishedTime];
}

- (void)testCommentToJSON {
    NSDictionary *JSON = [self.comment toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], @"comment", @"Wrong type");
    
    [self initializeCommentData];
    
    JSON = [self.comment toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], @"comment", @"Wrong type");
}

- (void)testCommentPersistentJSON {
    NSDictionary *JSON = [self.comment toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], @"comment", @"Wrong type");
    
    [self initializeCommentData];
    
    JSON = [self.comment persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.comment.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveCommentAttributes.externalID],
                         self.comment.externalID, @"Wrong externalID");
    XCTAssertEqualObjects([JSON objectForKey:JiveCommentAttributes.rootExternalID],
                         self.comment.rootExternalID, @"Wrong rootExternalID");
    XCTAssertEqualObjects([JSON objectForKey:JiveCommentAttributes.rootType], self.comment.rootType,
                         @"Wrong rootType");
    XCTAssertEqualObjects([JSON objectForKey:JiveCommentAttributes.rootURI], self.comment.rootURI,
                         @"Wrong rootURI");
    XCTAssertEqualObjects([JSON objectForKey:JiveCommentAttributes.publishedCalendarDate],
                         @"1970-01-01T00:00:00.000+0000", @"Wrong publishedCalendarDate");
    XCTAssertEqualObjects([JSON objectForKey:JiveCommentAttributes.publishedTime],
                         @"1970-01-01T00:16:40.123+0000", @"Wrong publishedTime");
}

- (void)testCommentPersistentJSON_alternate {
    [self initializeAlternateCommentData];
    
    NSDictionary *JSON = [self.comment persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.comment.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveCommentAttributes.externalID],
                         self.comment.externalID, @"Wrong externalID");
    XCTAssertEqualObjects([JSON objectForKey:JiveCommentAttributes.rootExternalID],
                         self.comment.rootExternalID, @"Wrong rootExternalID");
    XCTAssertEqualObjects([JSON objectForKey:JiveCommentAttributes.rootType], self.comment.rootType,
                         @"Wrong rootType");
    XCTAssertEqualObjects([JSON objectForKey:JiveCommentAttributes.rootURI], self.comment.rootURI,
                         @"Wrong rootURI");
    XCTAssertEqualObjects([JSON objectForKey:JiveCommentAttributes.publishedCalendarDate],
                         @"1970-01-01T00:16:40.123+0000", @"Wrong publishedCalendarDate");
    XCTAssertEqualObjects([JSON objectForKey:JiveCommentAttributes.publishedTime],
                         @"1970-01-01T00:00:00.000+0000", @"Wrong publishedTime");
}

- (void)testCommentJSONParsing {
    [self initializeCommentData];
    
    NSDictionary *JSON = [self.comment persistentJSON];
    JiveComment *newComment = [JiveComment objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqualObjects(newComment.type, self.comment.type, @"Wrong type");
    XCTAssertEqualObjects(newComment.externalID, self.comment.externalID, @"Wrong externalID");
    XCTAssertEqualObjects(newComment.rootExternalID, self.comment.rootExternalID, @"Wrong rootExternalID");
    XCTAssertEqualObjects(newComment.rootType, self.comment.rootType, @"Wrong rootType");
    XCTAssertEqualObjects(newComment.rootURI, self.comment.rootURI, @"Wrong rootURI");
    XCTAssertEqualObjects(newComment.publishedCalendarDate, self.comment.publishedCalendarDate, @"Wrong publishedCalendarDate");
    XCTAssertEqualObjects(newComment.publishedTime, self.comment.publishedTime, @"Wrong publishedTime");
}

- (void)testCommentJSONParsing_alternate {
    [self initializeAlternateCommentData];
    
    NSDictionary *JSON = [self.comment persistentJSON];
    JiveComment *newComment = [JiveComment objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqualObjects(newComment.type, self.comment.type, @"Wrong type");
    XCTAssertEqualObjects(newComment.externalID, self.comment.externalID, @"Wrong externalID");
    XCTAssertEqualObjects(newComment.rootExternalID, self.comment.rootExternalID, @"Wrong rootExternalID");
    XCTAssertEqualObjects(newComment.rootType, self.comment.rootType, @"Wrong rootType");
    XCTAssertEqualObjects(newComment.rootURI, self.comment.rootURI, @"Wrong rootURI");
    XCTAssertEqualObjects(newComment.publishedCalendarDate, self.comment.publishedCalendarDate, @"Wrong publishedCalendarDate");
    XCTAssertEqualObjects(newComment.publishedTime, self.comment.publishedTime, @"Wrong publishedTime");
}

@end
