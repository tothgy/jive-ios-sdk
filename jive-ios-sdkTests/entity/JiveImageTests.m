//
//  JiveImageTests.m
//  jive-ios-sdk
//
//  Created by Paola Sandrinelli on 8/20/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveObjectTests.h"
#import "JiveImage.h"

@interface JiveImageTests : JiveObjectTests

@property (nonatomic, readonly) JiveImage *image;

@end


@implementation JiveImageTests

- (void)setUp {
    [super setUp];
    self.object = [JiveImage new];
}

- (JiveImage *)image {
    return (JiveImage *)self.object;
}

- (void)testToJSON {
    
    NSDictionary *JSON = [self.image toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeImage];
    
    JSON = [self.image toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.jiveId], self.image.jiveId, @"Wrong id.");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveImageAttributes.tags];
    XCTAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([tagsJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(tagsJSON[0], self.image.tags[0], @"Wrong value");
}

- (void)testAlternateToJSON {
    
    NSDictionary *JSON = [self.image toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeAlternateImage];
    
    JSON = [self.image toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.jiveId], self.image.jiveId, @"Wrong id.");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveImageAttributes.tags];
    XCTAssertNil(tagsJSON, @"There should be no tags");
}

- (void)testPersistentJSON {
    
    NSDictionary *JSON = [self.image toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeImage];
    
    JSON = [self.image persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.jiveId], self.image.jiveId, @"Wrong id.");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.width], self.image.width, @"Wrong width.");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.height], self.image.height, @"Wrong height.");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.ref], [self.image.ref absoluteString], @"Wrong name.");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.size], self.image.size, @"Wrong size.");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.name], self.image.name, @"Wrong ref.");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.contentType], self.image.contentType, @"Wrong type.");

    NSArray *tagsJSON = [JSON objectForKey:JiveImageAttributes.tags];
    XCTAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([tagsJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(tagsJSON[0], self.image.tags[0], @"Wrong value");
    XCTAssertEqualObjects(tagsJSON[1], self.image.tags[1], @"Wrong value");
}

- (void)testAlternatePersistentJSON {
    
    NSDictionary *JSON = [self.image toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeAlternateImage];
    
    JSON = [self.image persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.jiveId], self.image.jiveId, @"Wrong id.");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.width], self.image.width, @"Wrong width.");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.height], self.image.height, @"Wrong height.");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.ref], [self.image.ref absoluteString], @"Wrong ref.");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.size], self.image.size, @"Wrong size.");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.name], self.image.name, @"Wrong name.");
    XCTAssertEqualObjects(JSON[JiveImageAttributes.contentType], self.image.contentType, @"Wrong type.");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveImageAttributes.tags];
    XCTAssertNil(tagsJSON, @"There should be no tags");
}

- (void)testImageParsing {
    
    [self initializeImage];
    
    id JSON = [self.image persistentJSON];
    JiveImage *newImage = [JiveImage objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newImage class] isSubclassOfClass:[self.image class]], @"Wrong item class");
    XCTAssertEqualObjects(newImage.type, self.image.type, @"Wrong type");
    XCTAssertEqualObjects(newImage.jiveId, self.image.jiveId, @"Wrong id.");
    XCTAssertEqualObjects(newImage.width, self.image.width, @"Wrong width.");
    XCTAssertEqualObjects(newImage.height, self.image.height, @"Wrong height.");
    XCTAssertEqualObjects([newImage.ref absoluteString], [self.image.ref absoluteString], @"Wrong ref.");
    XCTAssertEqualObjects(newImage.size, self.image.size, @"Wrong size.");
    XCTAssertEqualObjects(newImage.name, self.image.name, @"Wrong name.");
    XCTAssertEqualObjects(newImage.contentType, self.image.contentType, @"Wrong type.");
    XCTAssertEqual([newImage.tags count], [self.image.tags count], @"Wrong number of tags");
    XCTAssertEqual(newImage.tags[0], self.image.tags[0], @"Wrong number of tags");
}

- (void)testAlternateImageParsing {
    
    [self initializeAlternateImage];
    
    id JSON = [self.image persistentJSON];
    JiveImage *newImage = [JiveImage objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newImage class] isSubclassOfClass:[self.image class]], @"Wrong item class");
    XCTAssertEqualObjects(newImage.type, self.image.type, @"Wrong type");
    XCTAssertEqualObjects(newImage.jiveId, self.image.jiveId, @"Wrong id.");
    XCTAssertEqualObjects(newImage.width, self.image.width, @"Wrong width.");
    XCTAssertEqualObjects(newImage.height, self.image.height, @"Wrong height.");
    XCTAssertEqualObjects([newImage.ref absoluteString], [self.image.ref absoluteString], @"Wrong ref.");
    XCTAssertEqualObjects(newImage.size, self.image.size, @"Wrong size.");
    XCTAssertEqualObjects(newImage.name, self.image.name, @"Wrong name.");
    XCTAssertEqualObjects(newImage.contentType, self.image.contentType, @"Wrong type.");
    XCTAssertEqual([newImage.tags count], [self.image.tags count], @"Wrong number of tags");
    XCTAssertNil(newImage.tags, @"There should be no tags");
}


#pragma mark - Private

- (void)initializeImage {
    [self.image setValue:@"1234" forKey:JiveImageAttributes.jiveId];
    [self.image setValue:@320 forKey:JiveImageAttributes.width];
    [self.image setValue:@100 forKey:JiveImageAttributes.height];
    [self.image setValue:[NSURL URLWithString:@"http://dummy.com/wacky.jpg"] forKey:JiveImageAttributes.ref];
    [self.image setValue:@[@"qwerty", @"asdf"] forKey:JiveImageAttributes.tags];
    [self.image setValue:@888 forKey:JiveImageAttributes.size];
    [self.image setValue:@"imagename1" forKey:JiveImageAttributes.name];
    [self.image setValue:@"image" forKey:JiveImageAttributes.contentType];
}

- (void)initializeAlternateImage {
    [self.image setValue:@"567" forKey:JiveImageAttributes.jiveId];
    [self.image setValue:@3120 forKey:JiveImageAttributes.width];
    [self.image setValue:@2000 forKey:JiveImageAttributes.height];
    [self.image setValue:[NSURL URLWithString:@"http://dummy.com/wacky2.jpg"] forKey:JiveImageAttributes.ref];
    [self.image setValue:@999 forKey:JiveImageAttributes.size];
    [self.image setValue:@"imagename2" forKey:JiveImageAttributes.name];
    [self.image setValue:@"image" forKey:JiveImageAttributes.contentType];
}

@end
