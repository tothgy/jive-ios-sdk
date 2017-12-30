//
//  JiveContentVideoTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 5/22/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveObjectTests.h"
#import "JiveContentVideo.h"


@interface JiveContentVideoTests : JiveObjectTests

@property(nonatomic, readonly) JiveContentVideo *contentVideo;

@end


@implementation JiveContentVideoTests

- (JiveContentVideo *)contentVideo {
    return (JiveContentVideo *)self.object;
}

- (void)setUp
{
    [super setUp];
    self.object = [JiveContentVideo new];
}

- (void)initializeContentVideo {
    [self.contentVideo setValue:@5 forKey:JiveContentVideoAttributes.height];
    [self.contentVideo setValue:[NSURL URLWithString:@"http://dummy.com/wacky.jpg"]
                         forKey:JiveContentVideoAttributes.stillImageURL];
    [self.contentVideo setValue:[NSURL URLWithString:@"http://dummy.com/wacky2.jpg"]
                         forKey:JiveContentVideoAttributes.videoSourceURL];
    [self.contentVideo setValue:@8 forKey:JiveContentVideoAttributes.width];
}

- (void)initializeAlternateContentVideo {
    [self.contentVideo setValue:@50 forKey:JiveContentVideoAttributes.height];
    [self.contentVideo setValue:[NSURL URLWithString:@"stillImage.png"
                                       relativeToURL:[NSURL URLWithString:@"http://transient.com"]]
                         forKey:JiveContentVideoAttributes.stillImageURL];
    [self.contentVideo setValue:[NSURL URLWithString:@"videoSource.png"
                                       relativeToURL:[NSURL URLWithString:@"http://transient.com"]]
                         forKey:JiveContentVideoAttributes.videoSourceURL];
    [self.contentVideo setValue:@80 forKey:JiveContentVideoAttributes.width];
}

- (void)testContentVideoToJSON {
    NSDictionary *JSON = [self.contentVideo toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");

    [self initializeContentVideo];
    
    JSON = [self.contentVideo toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
}

- (void)testContentVideoPersistentJSON {
    [self initializeContentVideo];
    
    NSDictionary *JSON = [self.contentVideo persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveContentVideoAttributes.height], self.contentVideo.height, @"Wrong height");
    XCTAssertEqualObjects(JSON[JiveContentVideoAttributes.stillImageURL],
                         [self.contentVideo.stillImageURL absoluteString], @"Wrong still image url");
    XCTAssertEqualObjects(JSON[JiveContentVideoAttributes.videoSourceURL],
                         [self.contentVideo.videoSourceURL absoluteString], @"Wrong video source url");
    XCTAssertEqualObjects(JSON[JiveContentVideoAttributes.width], self.contentVideo.width, @"Wrong width");
}

- (void)testContentVideoPersistentJSON_alternate {
    [self initializeAlternateContentVideo];
    
    NSDictionary *JSON = [self.contentVideo persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveContentVideoAttributes.height], self.contentVideo.height, @"Wrong height");
    XCTAssertEqualObjects(JSON[JiveContentVideoAttributes.stillImageURL],
                         [self.contentVideo.stillImageURL absoluteString], @"Wrong still image url");
    XCTAssertEqualObjects(JSON[JiveContentVideoAttributes.videoSourceURL],
                         [self.contentVideo.videoSourceURL absoluteString], @"Wrong video source url");
    XCTAssertEqualObjects(JSON[JiveContentVideoAttributes.width], self.contentVideo.width, @"Wrong width");
}

- (void)testContentVideoParsing {
    [self initializeContentVideo];
    
    NSDictionary *JSON = [self.contentVideo persistentJSON];
    JiveContentVideo *newContentVideo = [JiveContentVideo objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqualObjects(newContentVideo.height, self.contentVideo.height, @"Wrong height");
    XCTAssertEqualObjects([newContentVideo.stillImageURL absoluteString],
                         [self.contentVideo.stillImageURL absoluteString], @"Wrong still image url");
    XCTAssertEqualObjects([newContentVideo.videoSourceURL absoluteString],
                         [self.contentVideo.videoSourceURL absoluteString], @"Wrong video source url");
    XCTAssertEqualObjects(newContentVideo.width, self.contentVideo.width, @"Wrong width");
}

- (void)testContentVideoParsing_alternate {
    [self initializeAlternateContentVideo];
    
    NSDictionary *JSON = [self.contentVideo persistentJSON];
    JiveContentVideo *newContentVideo = [JiveContentVideo objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqualObjects(newContentVideo.height, self.contentVideo.height, @"Wrong height");
    XCTAssertEqualObjects([newContentVideo.stillImageURL absoluteString],
                         [self.contentVideo.stillImageURL absoluteString], @"Wrong still image url");
    XCTAssertEqualObjects([newContentVideo.videoSourceURL absoluteString],
                         [self.contentVideo.videoSourceURL absoluteString], @"Wrong video source url");
    XCTAssertEqualObjects(newContentVideo.width, self.contentVideo.width, @"Wrong width");
}

@end
