//
//  JiveFileTests.m
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

#import "JiveFileTests.h"
#import "JivePerson.h"

@implementation JiveFileTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveFile alloc] init];
}

- (JiveFile *)file {
    return (JiveFile *)self.authorableContent;
}

- (void)testType {
    XCTAssertEqualObjects(self.file.type, @"file", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.file.type
                                                                            forKey:JiveTypedObjectAttributes.type];
    
    XCTAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.file class], @"File class not registered with JiveTypedObject.");
    XCTAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.file class], @"File class not registered with JiveContent.");
}

- (void)initializeFile {
    [self.file setValue:[NSURL URLWithString:@"http://dummy.com/text.txt"] forKey:JiveFileAttributes.binaryURL];
    [self.file setValue:@"text/html" forKeyPath:JiveFileAttributes.contentType];
    [self.file setValue:@"name" forKeyPath:JiveFileAttributes.name];
    self.file.restrictComments = @YES;
    [self.file setValue:@42 forKey:JiveFileAttributes.size];
}

- (void)initializeAlternateFile {
    [self.file setValue:[NSURL URLWithString:@"http://super.com/mos.png"] forKey:JiveFileAttributes.binaryURL];
    [self.file setValue:@"application/dummy" forKeyPath:JiveFileAttributes.contentType];
    [self.file setValue:@"toby" forKeyPath:JiveFileAttributes.name];
    [self.file setValue:@777291 forKey:JiveFileAttributes.size];
}

- (void)testFileToJSON {
    NSDictionary *JSON = [self.file toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"file", @"Wrong type");
    
    [self initializeFile];
    
    JSON = [self.file toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.file.type, @"Wrong type");
    if ([self.file commentsNotAllowed])
        XCTAssertTrue([JSON[JiveFileAttributes.restrictComments] boolValue], @"Wrong restrictComments");
    else
        XCTFail(@"Wrong restrictComments");
}

- (void)testFileToJSON_alternate {
    [self initializeAlternateFile];
    
    NSDictionary *JSON = [self.file toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.file.type, @"Wrong type");
    if (![self.file commentsNotAllowed])
        XCTAssertNil(JSON[JiveFileAttributes.restrictComments], @"Wrong restrictComments");
    else
        XCTFail(@"Wrong restrictComments");
}

- (void)testPersistentJSON {
    NSDictionary *JSON = [self.file toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"file", @"Wrong type");
    
    [self initializeFile];
    
    JSON = [self.file persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.file.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveFileAttributes.binaryURL], [self.file.binaryURL absoluteString], @"Wrong binaryURL");
    XCTAssertEqualObjects(JSON[JiveFileAttributes.size], self.file.size, @"Wrong size");
    XCTAssertEqualObjects(JSON[JiveFileAttributes.contentType], self.file.contentType, @"Wrong contentType");
    XCTAssertEqualObjects(JSON[JiveFileAttributes.name], self.file.name, @"Wrong name");
    if ([self.file commentsNotAllowed])
        XCTAssertTrue([JSON[JiveFileAttributes.restrictComments] boolValue], @"Wrong restrictComments");
    else
        XCTFail(@"Wrong restrictComments");
}

- (void)testPersistentJSON_alternate {
    [self initializeAlternateFile];
    
    NSDictionary *JSON = [self.file persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.file.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveFileAttributes.binaryURL], [self.file.binaryURL absoluteString], @"Wrong binaryURL");
    XCTAssertEqualObjects(JSON[JiveFileAttributes.size], self.file.size, @"Wrong size");
    XCTAssertEqualObjects(JSON[JiveFileAttributes.contentType], self.file.contentType, @"Wrong contentType");
    XCTAssertEqualObjects(JSON[JiveFileAttributes.name], self.file.name, @"Wrong name");
    if (![self.file commentsNotAllowed])
        XCTAssertNil(JSON[JiveFileAttributes.restrictComments], @"Wrong restrictComments");
    else
        XCTFail(@"Wrong restrictComments");
}

- (void)testFileParsing {
    [self initializeFile];
    
    id JSON = [self.file persistentJSON];
    JiveFile *newContent = [JiveFile objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.file class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.file.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.binaryURL, self.file.binaryURL, @"Wrong binaryURL");
    XCTAssertEqualObjects(newContent.contentType, self.file.contentType, @"Wrong contentType");
    XCTAssertEqualObjects(newContent.name, self.file.name, @"Wrong name");
    XCTAssertEqualObjects(newContent.restrictComments, self.file.restrictComments, @"Wrong restrictComments");
    XCTAssertEqualObjects(newContent.size, self.file.size, @"Wrong size");
}

- (void)testFileParsingAlternate {
    [self initializeAlternateFile];
    
    id JSON = [self.file persistentJSON];
    JiveFile *newContent = [JiveFile objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.file class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.file.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.binaryURL, self.file.binaryURL, @"Wrong binaryURL");
    XCTAssertEqualObjects(newContent.contentType, self.file.contentType, @"Wrong contentType");
    XCTAssertEqualObjects(newContent.name, self.file.name, @"Wrong name");
    XCTAssertEqualObjects(newContent.restrictComments, self.file.restrictComments, @"Wrong restrictComments");
    XCTAssertEqualObjects(newContent.size, self.file.size, @"Wrong size");
}

@end
