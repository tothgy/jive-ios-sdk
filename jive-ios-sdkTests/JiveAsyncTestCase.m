//
//  JiveAsyncTestCase.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/6/12.
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

#import "JiveAsyncTestCase.h"
#import "JAPIRequestOperation.h"

static NSTimeInterval const JiveAsyncTestCaseTimeout = 5;
static NSTimeInterval const JiveAsyncTestCaseDelayInterval = 1;

NSString *STComposeString(NSString *format, ...) {
    if (!format) return @"";

    NSString *composedString;
    va_list args;

    va_start(args, format);
    composedString = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    return composedString;
}

@implementation NSException (TestFailure)

+ (NSException *) failureInCondition:(NSString *) condition isTrue:(BOOL) isTrue inFile:(NSString *) filename atLine:(int) lineNumber withDescription:(NSString *)formatString, ...
/*" This method returns a NSException with a name of "SenTestFailureException".
 A reason constructed from the condition, the boolean isTrue and the
 formatString and the variable number of arguments that follow it
 (just like in the NSString method -stringWithFormat:).
 And an user info dictionary that contain the following information for the
 given keys:
 _{SenFailureTypeKey SenConditionFailure.}
 _{SenTestConditionKey The condition (as a string) that caused this failure.}
 _{SenTestFilenameKey The filename containing the code that caused the exception.}
 _{SenTestLineNumberKey The lineNumber of the code that caused the exception.}
 _{SenTestDescriptionKey A description constructed from the formatString and
 the variable number of arguments that follow it.}
 "*/
{
    NSString *stkDescription = nil;
    NSString *aReason = nil;
    NSDictionary *aUserInfo = nil;

    if ( formatString != nil ) {
        va_list argList;

        va_start(argList, formatString);
        stkDescription = [[NSString alloc] initWithFormat:formatString
                                                arguments:argList];

        va_end(argList);
    } else {
        stkDescription = @"";
    }

    aReason = [NSString stringWithFormat:@"\"%@\" should be %@. %@",
               condition, (isTrue ? @"false" : @"true"), stkDescription];
    aUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                 SenConditionFailure, SenFailureTypeKey,
                 condition, SenTestConditionKey,
                 filename, SenTestFilenameKey,
                 [NSNumber numberWithInt:lineNumber], SenTestLineNumberKey,
                 stkDescription, SenTestDescriptionKey,
                 nil];
    return [self exceptionWithName:SenTestFailureException
                            reason:aReason
                          userInfo:aUserInfo];
}

@end

NSString * const SenTestFailureException = @"SenTestFailureException";

NSString * const SenFailureTypeKey = @"SenFailureTypeKey";
NSString * const SenUnconditionalFailure = @"SenUnconditionalFailure";
NSString * const SenConditionFailure = @"SenConditionFailure";
NSString * const SenEqualityFailure = @"SenEqualityFailure";
NSString * const SenRaiseFailure = @"SenRaiseFailure";

NSString * const SenTestConditionKey = @"SenTestConditionKey";
NSString * const SenTestEqualityLeftKey = @"SenTestEqualityLeftKey";
NSString * const SenTestEqualityRightKey = @"SenTestEqualityRightKey";
NSString * const SenTestEqualityAccuracyKey = @"SenTestEqualityAccuracyKey";

NSString * const SenTestFilenameKey = @"SenTestFilenameKey";
NSString * const SenTestLineNumberKey = @"SenTestLineNumberKey";
NSString * const SenTestDescriptionKey = @"SenTestDescriptionKey";

#define JVAssertTrue(expr, file, line, description, ...) \
do { \
    BOOL _evaluatedExpression = !!(expr);\
    if (!_evaluatedExpression) {\
        NSString *_expression = [NSString stringWithUTF8String:#expr];\
        [self failWithException:([NSException failureInCondition:_expression \
                         isTrue:NO \
                         inFile:[NSString stringWithUTF8String:file] \
                         atLine:line \
                withDescription:@"%@", STComposeString(description, ##__VA_ARGS__)])]; \
    } \
} while (0)

@implementation JiveAsyncTestCase

- (void)setUp {
    [super setUp];
    
    [OHHTTPStubs removeAllRequestHandlers];
}

- (void)tearDown {
    [OHHTTPStubs removeAllRequestHandlers];
    
    [super tearDown];
}

- (void)waitForTimeout:(void (^)(dispatch_block_t finishedBlock))asynchBlock
                  file:(const char *)file
                  line:(int)line {
    __block BOOL finished = NO;
    void (^finishedBlock)(void) = [^{
        finished = YES;
    } copy];
    
    asynchBlock(finishedBlock);
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:JiveAsyncTestCaseTimeout];
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    
    while (!finished && ([loopUntil timeIntervalSinceNow] > 0)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
    
    JVAssertTrue(finished, file, line, @"Asynchronous call never finished.");
}

- (void)delay {
    NSDate *loopUntilDate = [NSDate dateWithTimeIntervalSinceNow:JiveAsyncTestCaseDelayInterval];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                             beforeDate:loopUntilDate];
}

- (void)failWithException:(NSException *)exception {
    [exception raise];
}

@end

@implementation OHHTTPStubsResponse (JiveAsyncTestCase)


+ (instancetype)responseWithJSON:(id)JSON {
    return [self responseWithJSON:JSON
                        responder:NULL];
}

+ (instancetype)responseWithJSON:(id)JSON
                       responder:(OHHTTPStubsResponder)responder {
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:JSON
                                                       options:NSJSONWritingPrettyPrinted error:NULL];
    OHHTTPStubsResponse *response = [self responseWithData:JSONData
                                                statusCode:200
                                              responseTime:0
                                                   headers:(@{
                                                            @"Content-Type" : @"application/json",
                                                            })];
    response.responder = responder;
    return response;
}

+ (instancetype)responseWithJSONFile:(NSString *)fileName {
    return [self responseWithJSONFile:fileName
                            responder:NULL];
}

+ (instancetype)responseWithJSONFile:(NSString *)fileName
                           responder:(OHHTTPStubsResponder)responder {
    OHHTTPStubsResponse *response = [self responseWithFile:fileName
                                               contentType:@"application/json"
                                              responseTime:0];
    response.responder = responder;
    return response;
}

+ (instancetype)responseWithHTML:(NSString *)HTML {
    return [self responseWithHTML:HTML
                        responder:NULL];
}

+ (instancetype)responseWithHTML:(NSString *)HTML
                       responder:(OHHTTPStubsResponder)responder {
    OHHTTPStubsResponse *response = [self responseWithData:[HTML dataUsingEncoding:NSUTF8StringEncoding]
                                                statusCode:200
                                              responseTime:0
                                                   headers:(@{
                                                            @"Content-Type" : @"text/html",
                                                            })];
    response.responder = responder;
    return response;
    
}

+ (instancetype)responseThatRedirectsToLocation:(NSURL *)locationURL {
    return [self responseThatRedirectsToLocation:locationURL
                                       responder:NULL];
}

+ (instancetype)responseThatRedirectsToLocation:(NSURL *)locationURL
                                      responder:(OHHTTPStubsResponder)responder {
    OHHTTPStubsResponse *response = [self responseWithData:[@"<html></html>" dataUsingEncoding:NSUTF8StringEncoding]
                                                statusCode:300
                                              responseTime:0
                                                   headers:(@{
                                                            @"Content-Type" : @"text/html",
                                                            @"Location" : [locationURL absoluteString],
                                                            })];
    response.responder = responder;
    return response;
}

+ (instancetype)responseWithError:(NSError *)error
                        responder:(OHHTTPStubsResponder)responder {
    OHHTTPStubsResponse *response = [self responseWithError:error];
    response.responder = responder;
    return response;
}

@end
