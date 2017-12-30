//
//  JivePollTests.m
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

#import "JivePollTests.h"

@implementation JivePollTests

NSString * const JivePollTestsOptionsImageImageKey = @"image";

- (void)setUp {
    [super setUp];
    self.object = [[JivePoll alloc] init];
}

- (JivePoll *)poll {
    return (JivePoll *)self.categorizedContent;
}

- (void)testType {
    XCTAssertEqualObjects(self.poll.type, @"poll", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.poll.type forKey:@"type"];
    
    XCTAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.poll class], @"Poll class not registered with JiveTypedObject.");
    XCTAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.poll class], @"Poll class not registered with JiveContent.");
}

- (void)testPollToJSON {
    NSString *tag = @"wordy";
    NSString *option = @"option";
    NSString *vote = @"vote";

    NSMutableDictionary *optionsImages = [NSMutableDictionary new];
    [optionsImages setValue:[JiveImage new] forKey:option];
    
    NSDictionary *JSON = [self.poll toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], @"poll", @"Wrong type");
    
    self.poll.options = [NSArray arrayWithObject:option];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:JiveContentAttributes.tags];
    [self.poll setValue:[NSNumber numberWithInt:1] forKey:JivePollAttributes.voteCount];
    [self.poll setValue:[NSArray arrayWithObject:vote] forKey:JivePollAttributes.votes];
    [self.poll setValue:optionsImages forKey:JivePollAttributes.optionsImages];
    self.poll.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    JSON = [self.poll toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.poll.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JivePollAttributes.voteCount], self.poll.voteCount, @"Wrong voteCount");
    XCTAssertEqualObjects([JSON objectForKey:JiveContentAttributes.visibleToExternalContributors], self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *votesJSON = [JSON objectForKey:JivePollAttributes.votes];
    
    XCTAssertTrue([[votesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([votesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([votesJSON objectAtIndex:0], vote, @"Wrong value");
    
    NSArray *optionsJSON = [JSON objectForKey:JivePollAttributes.options];
    
    XCTAssertTrue([[optionsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([optionsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([optionsJSON objectAtIndex:0], option, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveContentAttributes.tags];
    
    XCTAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *optionsImagesJson = [JSON objectForKey:JivePollAttributes.optionsImages];
    XCTAssertTrue([[optionsImagesJson class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([optionsImagesJson count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertTrue([[[optionsImagesJson objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"Option image record is not a dictionary");
    
    
    NSDictionary *optionsImagesImageRecord = [optionsImagesJson objectAtIndex:0];
    XCTAssertEqual([optionsImagesImageRecord objectForKey:option], option, @"Option image had wrong option key");
    XCTAssertTrue([[[optionsImagesImageRecord objectForKey:JivePollTestsOptionsImageImageKey] class] isSubclassOfClass:[NSDictionary class]], @"Option image record was not a dictionary");
    
}

- (void)testPollToJSON_alternate {
    NSString *tag = @"concise";
    NSString *option = @"option";
    NSString *vote = @"vote";
    
    self.poll.options = [NSArray arrayWithObject:option];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:JiveContentAttributes.tags];
    [self.poll setValue:[NSNumber numberWithInt:2] forKey:JivePollAttributes.voteCount];
    [self.poll setValue:[NSArray arrayWithObject:vote] forKey:JivePollAttributes.votes];
    
    NSDictionary *JSON = [self.poll toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.poll.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JivePollAttributes.voteCount], self.poll.voteCount, @"Wrong voteCount");
    XCTAssertEqualObjects([JSON objectForKey:JiveContentAttributes.visibleToExternalContributors], self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *votesJSON = [JSON objectForKey:JivePollAttributes.votes];
    
    XCTAssertTrue([[votesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([votesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([votesJSON objectAtIndex:0], vote, @"Wrong value");
    
    NSArray *optionsJSON = [JSON objectForKey:JivePollAttributes.options];
    
    XCTAssertTrue([[optionsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([optionsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([optionsJSON objectAtIndex:0], option, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveContentAttributes.tags];
    
    XCTAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testPollParsing {
    NSString *tag = @"wordy";
    NSString *option = @"option";
    NSString *vote = @"vote";
    
    self.poll.options = [NSArray arrayWithObject:option];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:JiveContentAttributes.tags];
    [self.poll setValue:[NSNumber numberWithInt:1] forKey:JivePollAttributes.voteCount];
    [self.poll setValue:[NSArray arrayWithObject:vote] forKey:JivePollAttributes.votes];
    self.poll.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    id JSON = [self.poll toJSONDictionary];
    JivePoll *newContent = [JivePoll objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.poll class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.poll.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.voteCount, self.poll.voteCount, @"Wrong voteCount");
    XCTAssertEqualObjects(newContent.visibleToExternalContributors, self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    XCTAssertEqual([newContent.tags count], [self.poll.tags count], @"Wrong number of tags");
    XCTAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    XCTAssertEqual([newContent.options count], [self.poll.options count], @"Wrong number of options");
    XCTAssertEqualObjects([newContent.options objectAtIndex:0], option, @"Wrong option");
    XCTAssertEqual([newContent.votes count], [self.poll.votes count], @"Wrong number of votes");
    XCTAssertEqualObjects([newContent.votes objectAtIndex:0], vote, @"Wrong vote");
}

- (void)testOptionImagesParsed {
    JivePoll *poll = [self pollFromTestData];
    NSDictionary *optionsImages = poll.optionsImages;
    NSUInteger expectedImageCount = 6;
    XCTAssertEqual([optionsImages count], expectedImageCount, @"Expected six images");
    
    for (NSString *option in poll.options) {
        XCTAssertNotNil([optionsImages objectForKey:option], @"Did not get an image for an expected option %@", option);
    }
    
    XCTAssertNil([optionsImages objectForKey:@"abcdefghijklmonop"], @"Got non-null image for an option that does not exist");
    
}

- (void)testPollParsingAlternate {
    NSString *tag = @"concise";
    NSString *option = @"option";
    NSString *vote = @"vote";
    
    self.poll.options = [NSArray arrayWithObject:option];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:JiveContentAttributes.tags];
    [self.poll setValue:[NSNumber numberWithInt:2] forKey:JivePollAttributes.voteCount];
    [self.poll setValue:[NSArray arrayWithObject:vote] forKey:JivePollAttributes.votes];
    
    id JSON = [self.poll toJSONDictionary];
    JivePoll *newContent = [JivePoll objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.poll class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.poll.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.voteCount, self.poll.voteCount, @"Wrong voteCount");
    XCTAssertEqualObjects(newContent.visibleToExternalContributors, self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    XCTAssertEqual([newContent.tags count], [self.poll.tags count], @"Wrong number of tags");
    XCTAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    XCTAssertEqual([newContent.options count], [self.poll.options count], @"Wrong number of options");
    XCTAssertEqualObjects([newContent.options objectAtIndex:0], option, @"Wrong option");
    XCTAssertEqual([newContent.votes count], [self.poll.votes count], @"Wrong number of votes");
    XCTAssertEqualObjects([newContent.votes objectAtIndex:0], vote, @"Wrong vote");
}

-(void) testCanVote {
    JivePoll *poll = [self pollFromTestData];
    XCTAssertTrue(poll.canVote, @"Should be able to vote");
}

#pragma mark - Test Object Generator

-(JivePoll*) pollFromTestData {
    NSString* dummyPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"poll"
                                                                           ofType:@"json"];
    
    NSData* dummyContent = [NSData dataWithContentsOfFile:dummyPath];
    
    NSError *error;
    NSMutableDictionary *pollDictionary = [NSJSONSerialization
                                           JSONObjectWithData:dummyContent
                                           options:0
                                           error:&error];
    JivePoll *poll = [JivePoll objectFromJSON:pollDictionary withInstance:self.instance];

    return poll;
}

@end
