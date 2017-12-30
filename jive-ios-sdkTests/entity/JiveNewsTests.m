//
//  JiveNewsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/26/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveNews.h"
#import "JiveNewsStream.h"

#import "JiveObjectTests.h"


@interface JiveNewsTests : JiveObjectTests

@property (nonatomic, readonly) JiveNews *news;

@end


@implementation JiveNewsTests

- (void)setUp {
    [super setUp];
    self.object = [JiveNews new];
}

- (JiveNews *)news {
    return (JiveNews *)self.object;
}

- (void)testType {
    XCTAssertEqualObjects(self.news.type, @"news", @"Wrong type.");
}

- (void)initializeDocument {
    JivePerson *owner = [JivePerson new];
    JiveNewsStream *newsStream = [JiveNewsStream new];
    JiveStream *stream = [JiveStream new];
    
    owner.location = @"cloud";
    [owner setValue:owner.location forKey:JivePersonAttributes.displayName];
    [newsStream setValue:stream forKey:JiveNewsStreamAttributes.stream];
    [self.news setValue:owner forKey:JiveNewsAttributes.owner];
    [self.news setValue:@[newsStream] forKey:JiveNewsAttributes.newsStreams];
}

- (void)initializeAlternateDocument {
    JivePerson *owner = [JivePerson new];
    JiveNewsStream *newsStream = [JiveNewsStream new];
    JiveStream *stream = [JiveStream new];
    
    owner.location = @"Taxi";
    [owner setValue:owner.location forKey:JivePersonAttributes.displayName];
    [newsStream setValue:stream forKey:JiveNewsStreamAttributes.stream];
    [self.news setValue:owner forKey:JiveNewsAttributes.owner];
    [self.news setValue:@[newsStream] forKey:JiveNewsAttributes.newsStreams];
}

- (void)testNewsToJSON {
    NSDictionary *JSON = [self.news toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveNewsAttributes.type], @"news", @"Wrong type");
    
    [self initializeDocument];
    
    JSON = [self.news toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveNewsAttributes.type], self.news.type, @"Wrong type");
}

- (void)testPersistentJSON_newsStreams {
    JiveNewsStream *newsStream1 = [JiveNewsStream new];
    JiveStream *stream1 = [JiveStream new];
    JiveNewsStream *newsStream2 = [JiveNewsStream new];
    JiveStream *stream2 = [JiveStream new];
    
    [newsStream1 setValue:stream1 forKey:JiveNewsStreamAttributes.stream];
    [newsStream2 setValue:stream2 forKey:JiveNewsStreamAttributes.stream];
    [self.news setValue:@[newsStream1] forKey:JiveNewsAttributes.newsStreams];
    
    NSDictionary *JSON = [self.news persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveNewsAttributes.type], self.news.type, @"Wrong type");
    
    NSArray *array = JSON[JiveNewsAttributes.newsStreams];
    NSDictionary *object1 = [array objectAtIndex:0];
    id subObject1 = object1[JiveNewsStreamAttributes.stream];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"newsStreams array not converted");
    XCTAssertEqual([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"newsStream object not converted");
    XCTAssertEqualObjects(object1[JiveNewsStreamAttributes.type], newsStream1.type, @"Wrong value");
    XCTAssertTrue([[subObject1 class] isSubclassOfClass:[NSDictionary class]], @"stream object not converted");
    XCTAssertEqualObjects(subObject1[JiveTypedObjectAttributes.type], stream1.type, @"Wrong value");
    
    [self.news setValue:[self.news.newsStreams arrayByAddingObject:newsStream2]
                 forKey:JiveNewsAttributes.newsStreams];
    
    JSON = [self.news persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveNewsAttributes.type], self.news.type, @"Wrong type");
    
    array = JSON[JiveNewsAttributes.newsStreams];
    object1 = [array objectAtIndex:0];
    subObject1 = object1[JiveNewsStreamAttributes.stream];
    
    id object2 = [array objectAtIndex:1];
    id subObject2 = object2[JiveNewsStreamAttributes.stream];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"newsStreams array not converted");
    XCTAssertEqual([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"newsStream object not converted");
    XCTAssertEqualObjects(object1[JiveNewsStreamAttributes.type], newsStream1.type, @"Wrong value");
    XCTAssertTrue([[subObject1 class] isSubclassOfClass:[NSDictionary class]], @"stream object not converted");
    XCTAssertEqualObjects(subObject1[JiveTypedObjectAttributes.type], stream1.type, @"Wrong value");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"newsStream object not converted");
    XCTAssertEqualObjects(object2[JiveNewsStreamAttributes.type], newsStream1.type, @"Wrong value");
    XCTAssertTrue([[subObject2 class] isSubclassOfClass:[NSDictionary class]], @"stream object not converted");
    XCTAssertEqualObjects(subObject2[JiveTypedObjectAttributes.type], stream1.type, @"Wrong value");
}

- (void)testNewsPersistentJSON {
    NSDictionary *JSON = [self.news persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveNewsAttributes.type], @"news", @"Wrong type");
    
    [self initializeDocument];
    
    JSON = [self.news persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveNewsAttributes.type], self.news.type, @"Wrong type");
    
    NSDictionary *ownerJSON = JSON[JiveNewsAttributes.owner];
    
    XCTAssertTrue([[ownerJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([ownerJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(ownerJSON[JivePersonAttributes.location], self.news.owner.location, @"Wrong value");
    XCTAssertEqualObjects(ownerJSON[JivePersonAttributes.displayName], self.news.owner.displayName, @"Wrong display name");
    
    NSArray *newsStreamsJSON = JSON[JiveNewsAttributes.newsStreams];
    NSDictionary *newsStreamJSON = [newsStreamsJSON objectAtIndex:0];
    NSDictionary *streamJSON = newsStreamJSON[JiveNewsStreamAttributes.stream];
    
    XCTAssertTrue([[newsStreamsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([newsStreamsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([newsStreamJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(newsStreamJSON[JiveNewsStreamAttributes.type],
                         ((JiveNewsStream *)self.news.newsStreams[0]).type, @"Wrong value");
    XCTAssertEqual([streamJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(streamJSON[JiveTypedObjectAttributes.type],
                         ((JiveNewsStream *)self.news.newsStreams[0]).stream.type, @"Wrong value");
}

- (void)testNewsPersistentJSON_alternate {
    [self initializeAlternateDocument];
    
    NSDictionary *JSON = [self.news persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveNewsAttributes.type], self.news.type, @"Wrong type");
    
    NSDictionary *ownerJSON = JSON[JiveNewsAttributes.owner];
    
    XCTAssertTrue([[ownerJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([ownerJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(ownerJSON[JivePersonAttributes.location], self.news.owner.location, @"Wrong value");
    XCTAssertEqualObjects(ownerJSON[JivePersonAttributes.displayName], self.news.owner.displayName, @"Wrong display name");
    
    NSArray *newsStreamsJSON = JSON[JiveNewsAttributes.newsStreams];
    NSDictionary *newsStreamJSON = [newsStreamsJSON objectAtIndex:0];
    NSDictionary *streamJSON = newsStreamJSON[JiveNewsStreamAttributes.stream];
    
    XCTAssertTrue([[newsStreamsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([newsStreamsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([newsStreamJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(newsStreamJSON[JiveNewsStreamAttributes.type],
                         ((JiveNewsStream *)self.news.newsStreams[0]).type, @"Wrong value");
    XCTAssertEqual([streamJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(streamJSON[JiveTypedObjectAttributes.type],
                         ((JiveNewsStream *)self.news.newsStreams[0]).stream.type, @"Wrong value");
}

- (void)testNewsParsing {
    [self initializeDocument];
    
    id JSON = [self.news persistentJSON];
    JiveNews *newNews = [JiveNews objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newNews class] isSubclassOfClass:[self.news class]], @"Wrong item class");
    XCTAssertEqualObjects(newNews.type, self.news.type, @"Wrong type");
    XCTAssertEqualObjects(newNews.owner.location, self.news.owner.location, @"Wrong owner");
    
    if ([newNews.newsStreams count] > 0) {
        id convertedObject = newNews.newsStreams[0];
        
        XCTAssertEqual([convertedObject class], [JiveNewsStream class], @"Wrong news stream object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveNewsStream class]])
            XCTAssertEqualObjects([(JiveNewsStream *)convertedObject stream].type,
                                 ((JiveNewsStream *)self.news.newsStreams[0]).stream.type, @"Wrong news streams object");
    }
}

- (void)testNewsParsingAlternate {
    [self initializeAlternateDocument];
    
    id JSON = [self.news persistentJSON];
    JiveNews *newNews = [JiveNews objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newNews class] isSubclassOfClass:[self.news class]], @"Wrong item class");
    XCTAssertEqualObjects(newNews.type, self.news.type, @"Wrong type");
    XCTAssertEqualObjects(newNews.owner.location, self.news.owner.location, @"Wrong owner");
    
    if ([newNews.newsStreams count] > 0) {
        id convertedObject = newNews.newsStreams[0];
        
        XCTAssertEqual([convertedObject class], [JiveNewsStream class], @"Wrong news stream object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveNewsStream class]])
            XCTAssertEqualObjects([(JiveNewsStream *)convertedObject stream].type,
                                 ((JiveNewsStream *)self.news.newsStreams[0]).stream.type, @"Wrong news streams object");
    }
}

@end
