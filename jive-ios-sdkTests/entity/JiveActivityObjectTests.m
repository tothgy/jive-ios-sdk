//
//  JiveActivityObjectTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/26/12.
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

#import "JiveActivityObjectTests.h"
#import "JiveActivityObject.h"
#import "JiveMediaLink.h"
#import "JiveObject_internal.h"
#import "JiveImage.h"
#import "JiveContentVideo.h"


@implementation JiveActivityObjectTests

- (void)setUp {
    [super setUp];
    self.object = [JiveActivityObject new];
}

- (JiveActivityObject *)activity {
    return (JiveActivityObject *)self.object;
}

- (void)createJiveActivityObject {
    JiveActivityObject *author = [JiveActivityObject new];
    JiveMediaLink *image = [JiveMediaLink new];
    JivePersonJive *jive = [JivePersonJive new];
    
    author.jiveId = @"3456";
    [image setValue:[NSURL URLWithString:@"http://dummy.com/icon.png"] forKey:@"url"];
    jive.username = @"Silly Rabbit";
    [jive setValue:@YES forKey:JivePersonJiveAttributes.visible];
    self.activity.content = @"text";
    self.activity.jiveId = @"1234";
    self.activity.displayName = @"President";
    self.activity.objectType = @"Running";
    self.activity.summary = @"summary";
    self.activity.question = @YES;
    self.activity.resolved = @"open";
    self.activity.answer = [NSURL URLWithString:@"http://answer.com"];
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JiveActivityObjectAttributes.published];
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JiveActivityObjectAttributes.updated];
    [self.activity setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:JiveActivityObjectAttributes.url];
    [self.activity setValue:author forKey:JiveActivityObjectAttributes.author];
    [self.activity setValue:image forKey:JiveActivityObjectAttributes.image];
    [self.activity setValue:@YES forKey:JiveActivityObjectAttributes.canReply];
    [self.activity setValue:@YES forKey:JiveActivityObjectAttributes.canComment];
    [self.activity setValue:@8 forKey:JiveActivityObjectAttributes.helpfulCount];
    [self.activity setValue:jive forKey:JiveActivityObjectAttributes.jive];
    
    JiveImage *contentImage = [[JiveImage alloc] init];
    [contentImage setValue:@"1234" forKey:JiveImageAttributes.jiveId];
    [contentImage setValue:@320 forKey:JiveImageAttributes.width];
    [contentImage setValue:@100 forKey:JiveImageAttributes.height];
    [contentImage setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:JiveImageAttributes.ref];
    [contentImage setValue:@[@"abcd"] forKey:JiveImageAttributes.tags];
    [self.activity setValue:@[contentImage] forKey:JiveActivityObjectAttributes.contentImages];
    
    JiveContentVideo *contentVideo = [[JiveContentVideo alloc] init];
    [contentVideo setValue:@640 forKey:JiveContentVideoAttributes.width];
    [contentVideo setValue:@200 forKey:JiveContentVideoAttributes.height];
    [contentVideo setValue:[NSURL URLWithString:@"http://dummy.com"]
                    forKey:JiveContentVideoAttributes.stillImageURL];
    [self.activity setValue:@[contentVideo] forKey:JiveActivityObjectAttributes.contentVideos];
}

- (void)createJiveActivityObjectAlternate {
    JiveActivityObject *author = [JiveActivityObject new];
    JiveMediaLink *image = [JiveMediaLink new];
    JivePersonJive *jive = [JivePersonJive new];
    
    author.jiveId = @"9876";
    [image setValue:[NSURL URLWithString:@"http://super.com/icon.png"] forKey:@"url"];
    jive.username = @"Humbug";
    [jive setValue:@YES forKey:JivePersonJiveAttributes.viewContent];
    self.activity.content = @"html";
    self.activity.jiveId = @"4321";
    self.activity.displayName = @"Grunt";
    self.activity.objectType = @"Toil";
    self.activity.summary = @"wrong";
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JiveActivityObjectAttributes.published];
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JiveActivityObjectAttributes.updated];
    [self.activity setValue:[NSURL URLWithString:@"http://super.com"] forKey:JiveActivityObjectAttributes.url];
    [self.activity setValue:author forKey:JiveActivityObjectAttributes.author];
    [self.activity setValue:image forKey:JiveActivityObjectAttributes.image];
    [self.activity setValue:@234 forKey:JiveActivityObjectAttributes.helpfulCount];
    [self.activity setValue:jive forKey:JiveActivityObjectAttributes.jive];
}

- (void)testToJSON {
    NSDictionary *JSON = [self.activity toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self createJiveActivityObject];
    
    JSON = [self.activity toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.content], self.activity.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.displayName], self.activity.displayName, @"Wrong displayName.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.activity.jiveId, @"Wrong jive id.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.objectType], self.activity.objectType, @"Wrong objectType.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.summary], self.activity.summary, @"Wrong summary");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.question], self.activity.question);
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.resolved], self.activity.resolved);
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.answer], [self.activity.answer absoluteString]);

    XCTAssertNil(JSON[JiveActivityObjectAttributes.helpfulCount], @"There should be no helpfulCount");

    NSArray *contentImagesJSON = JSON[JiveActivityObjectAttributes.contentImages];
    XCTAssertNil(contentImagesJSON, @"There should be no contentImages");
    
    NSArray *contentVideosJSON = JSON[JiveActivityObjectAttributes.contentVideos];
    XCTAssertNil(contentVideosJSON, @"There should be no contentVideos");
}

- (void)testToJSON_alternate {
    [self createJiveActivityObjectAlternate];
    
    NSDictionary *JSON = [self.activity toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.content], self.activity.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.activity.jiveId, @"Wrong jive id.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.displayName], self.activity.displayName, @"Wrong displayName.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.objectType], self.activity.objectType, @"Wrong objectType.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.summary], self.activity.summary, @"Wrong summary");
    
    XCTAssertNil(JSON[JiveActivityObjectAttributes.helpfulCount], @"There should be no helpfulCount");
}

- (void)testPersistentJSON {
    NSDictionary *JSON = [self.activity toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self createJiveActivityObject];
    
    JSON = [self.activity persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)19, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.content], self.activity.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.activity.jiveId, @"Wrong jive id.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.displayName], self.activity.displayName, @"Wrong displayName.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.objectType], self.activity.objectType, @"Wrong objectType.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.summary], self.activity.summary, @"Wrong summary");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.published], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.updated], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.url], [self.activity.url absoluteString], @"Wrong url.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.question], self.activity.question);
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.resolved], self.activity.resolved);
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.answer], [self.activity.answer absoluteString]);
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.canReply], self.activity.canReply);
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.canComment], self.activity.canComment);
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.helpfulCount], self.activity.helpfulCount);
    
    NSDictionary *authorJSON = JSON[JiveActivityObjectAttributes.author];
    
    XCTAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([authorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(authorJSON[JiveObjectConstants.id], self.activity.author.jiveId, @"Wrong value");
    
    NSDictionary *imageJSON = JSON[JiveActivityObjectAttributes.image];
    
    XCTAssertTrue([[imageJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([imageJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(imageJSON[@"url"], [self.activity.image.url absoluteString], @"Wrong value");
    
    NSArray *contentImagesJSON = JSON[JiveActivityObjectAttributes.contentImages];
    XCTAssertTrue([[contentImagesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([contentImagesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    
    NSDictionary *contentImageDictionary = contentImagesJSON[0];
    JiveImage *contentImage = (JiveImage *)self.activity.contentImages[0];
    XCTAssertEqualObjects(contentImageDictionary[@"ref"], contentImage.ref.absoluteString, @"Wrong value");
    XCTAssertEqualObjects(contentImageDictionary[@"name"], contentImage.name, @"Wrong value");
    XCTAssertEqualObjects(contentImageDictionary[@"width"], contentImage.width, @"Wrong value");
    XCTAssertEqualObjects(contentImageDictionary[@"height"], contentImage.height, @"Wrong value");
    XCTAssertEqualObjects(contentImageDictionary[@"tags"], contentImage.tags, @"Wrong value");
    
    NSArray *contentVideosJSON = JSON[JiveActivityObjectAttributes.contentVideos];
    XCTAssertTrue([[contentVideosJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([contentVideosJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    
    NSDictionary *contentVideoDictionary = contentVideosJSON[0];
    JiveContentVideo *contentVideo = (JiveContentVideo *)self.activity.contentVideos[0];
    XCTAssertEqualObjects(contentVideoDictionary[@"stillImageURL"], contentVideo.stillImageURL.absoluteString, @"Wrong value");
    XCTAssertEqualObjects(contentVideoDictionary[@"videoSourceURL"], contentVideo.videoSourceURL.absoluteString, @"Wrong value");
    XCTAssertEqualObjects(contentVideoDictionary[@"width"], contentVideo.width, @"Wrong value");
    XCTAssertEqualObjects(contentVideoDictionary[@"height"], contentVideo.height, @"Wrong value");
    
    NSDictionary *jiveJSON = JSON[JiveActivityObjectAttributes.jive];
    
    XCTAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([jiveJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(jiveJSON[JivePersonJiveAttributes.username], self.activity.jive.username, @"Wrong value");
    XCTAssertEqualObjects(jiveJSON[JivePersonJiveAttributes.visible], self.activity.jive.visible, @"Wrong value");
}

- (void)testPersistentJSON_alternate {
    [self createJiveActivityObjectAlternate];
    
    NSDictionary *JSON = [self.activity persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)12, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.content], self.activity.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.id], self.activity.jiveId, @"Wrong jive id.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.displayName], self.activity.displayName, @"Wrong displayName.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.objectType], self.activity.objectType, @"Wrong objectType.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.summary], self.activity.summary, @"Wrong summary");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.published], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.updated], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.url], [self.activity.url absoluteString], @"Wrong url.");
    XCTAssertEqualObjects(JSON[JiveActivityObjectAttributes.helpfulCount], self.activity.helpfulCount);
    
    NSDictionary *authorJSON = JSON[JiveActivityObjectAttributes.author];
    
    XCTAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([authorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(authorJSON[JiveObjectConstants.id], self.activity.author.jiveId, @"Wrong value");
    
    NSDictionary *imageJSON = JSON[JiveActivityObjectAttributes.image];
    
    XCTAssertTrue([[imageJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([imageJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(imageJSON[@"url"], [self.activity.image.url absoluteString], @"Wrong value");
    
    NSDictionary *jiveJSON = JSON[JiveActivityObjectAttributes.jive];
    
    XCTAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([jiveJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(jiveJSON[JivePersonJiveAttributes.username], self.activity.jive.username);
    XCTAssertEqualObjects(jiveJSON[JivePersonJiveAttributes.viewContent],
                         self.activity.jive.viewContent);
}

- (void)testPlaceParsing {
    [self createJiveActivityObject];
    
    id JSON = [self.activity persistentJSON];
    JiveActivityObject *newActivity = [JiveActivityObject objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([newActivity class], [self.activity class], @"Wrong item class");
    XCTAssertEqualObjects(newActivity.jiveId, self.activity.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newActivity.content, self.activity.content, @"Wrong content");
    XCTAssertEqualObjects(newActivity.displayName, self.activity.displayName, @"Wrong displayName");
    XCTAssertEqualObjects(newActivity.objectType, self.activity.objectType, @"Wrong objectType");
    XCTAssertEqualObjects(newActivity.summary, self.activity.summary, @"Wrong summary");
    XCTAssertEqualObjects(newActivity.published, self.activity.published, @"Wrong published");
    XCTAssertEqualObjects(newActivity.updated, self.activity.updated, @"Wrong updated");
    XCTAssertEqualObjects(newActivity.url, self.activity.url, @"Wrong url");
    XCTAssertEqualObjects(newActivity.author.jiveId, self.activity.author.jiveId, @"Wrong author");
    XCTAssertEqualObjects(newActivity.image.url, self.activity.image.url, @"Wrong image");
    XCTAssertEqualObjects(newActivity.jive.username, self.activity.jive.username);
    XCTAssertEqualObjects(newActivity.jive.visible, self.activity.jive.visible);
    
    JiveImage *newActivityContentImage = newActivity.contentImages[0];
    JiveImage *activityContentImage = self.activity.contentImages[0];
    XCTAssertEqual([newActivity.contentImages count], [self.activity.contentImages count], @"Wrong number of contentImage entries");
    XCTAssertEqualObjects(newActivityContentImage.ref, activityContentImage.ref, @"Wrong contentImage");
    
    JiveContentVideo *newActivityContentVideo = newActivity.contentVideos[0];
    JiveContentVideo *activityContentVideo = self.activity.contentVideos[0];
    XCTAssertEqual([newActivity.contentVideos count], [self.activity.contentVideos count], @"Wrong number of contentVideo entries");
    XCTAssertEqualObjects(newActivityContentVideo.stillImageURL, activityContentVideo.stillImageURL, @"Wrong contentVideo");
    XCTAssertEqualObjects(newActivity.helpfulCount, self.activity.helpfulCount, @"Wrong helpfulCount");
}

- (void)testPlaceParsingAlternate {
    [self createJiveActivityObjectAlternate];
    
    id JSON = [self.activity persistentJSON];
    JiveActivityObject *newActivity = [JiveActivityObject objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([newActivity class], [self.activity class], @"Wrong item class");
    XCTAssertEqualObjects(newActivity.jiveId, self.activity.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newActivity.content, self.activity.content, @"Wrong content");
    XCTAssertEqualObjects(newActivity.displayName, self.activity.displayName, @"Wrong displayName");
    XCTAssertEqualObjects(newActivity.objectType, self.activity.objectType, @"Wrong objectType");
    XCTAssertEqualObjects(newActivity.summary, self.activity.summary, @"Wrong summary");
    XCTAssertEqualObjects(newActivity.published, self.activity.published, @"Wrong published");
    XCTAssertEqualObjects(newActivity.updated, self.activity.updated, @"Wrong updated");
    XCTAssertEqualObjects(newActivity.url, self.activity.url, @"Wrong url");
    XCTAssertEqualObjects(newActivity.author.jiveId, self.activity.author.jiveId, @"Wrong author");
    XCTAssertEqualObjects(newActivity.image.url, self.activity.image.url, @"Wrong image");
    XCTAssertEqualObjects(newActivity.helpfulCount, self.activity.helpfulCount, @"Wrong helpfulCount");
    XCTAssertEqualObjects(newActivity.jive.username, self.activity.jive.username);
    XCTAssertEqualObjects(newActivity.jive.viewContent, self.activity.jive.viewContent);
}

@end
