/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "CDVNewsstand.h"
#import <Cordova/CDV.h>


#define ISSUE_COVER_NAME        "cover.jpg"


@implementation CDVNewsstand

- (void)addItem:(CDVInvokedUrlCommand *)command {
	[self.commandDelegate runInBackground:^{
		CDVPluginResult *pluginResult = nil;
		NSString *issueName = @"";
		NSString *issueDate = @"";

		if ([command.arguments count] >= 1) {
			issueName = [NSString stringWithFormat:@"%@", (NSString *) (command.arguments)[0]];
		}
		if ([command.arguments count] >= 2) {
			issueDate = (NSString *) (command.arguments)[1];
		}

		NKIssue *nkIssue = [self getIssueByName:issueName];

		if (nkIssue == nil) {
			NKLibrary *nkLib = [NKLibrary sharedLibrary];
			NSDate *dateFromString = [[self getIssueDateFormatter:@"YYYY-MM-dd HH:mm:ss"] dateFromString:issueDate];
			nkIssue = [nkLib addIssueWithName:issueName date:dateFromString];
			NSDictionary *pluginResultDictionary = [self getIssueDataAsObject:nkIssue];
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:pluginResultDictionary];
		} else {
			NSString *msg = [NSString stringWithFormat:@"ussue with name \"%@\" already exist", issueName];
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
		}

		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)removeItem:(CDVInvokedUrlCommand *)command {
	[self.commandDelegate runInBackground:^{
		CDVPluginResult *pluginResult = nil;
		NKLibrary *nkLib = [NKLibrary sharedLibrary];
		NSString *issueName = @"";

		if ([command.arguments count] >= 1) {
			issueName = [NSString stringWithFormat:@"%@", (NSString *) (command.arguments)[0]];
		}

		NKIssue *nkIssue = [self getIssueByName:issueName];

		if (nkIssue != nil) {
			[nkLib removeIssue:nkIssue];
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		} else {
			NSString *msg = [NSString stringWithFormat:@"ussue with name \"%@\" not exist", issueName];
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
		}

		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)archiveItem:(CDVInvokedUrlCommand *)command {
}

- (void)getItem:(CDVInvokedUrlCommand *)command {
}

- (void)getItems:(CDVInvokedUrlCommand *)command {
	[self.commandDelegate runInBackground:^{
		CDVPluginResult *pluginResult = nil;
		NKLibrary *nkLib = [NKLibrary sharedLibrary];
		NSMutableArray *issuesArray = [[NSMutableArray alloc] init];

		for (NKIssue *nkIssue in [nkLib issues]) {
			[issuesArray addObject:[self getIssueDataAsObject:nkIssue]];
		}

		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:issuesArray];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)downloadItem:(CDVInvokedUrlCommand *)command {
	[self.commandDelegate runInBackground:^{
		CDVPluginResult *pluginResult = nil;
		NSString *issueName = @"";

		if ([command.arguments count] >= 1) {
			issueName = [NSString stringWithFormat:@"%@", (NSString *) (command.arguments)[0]];
		}

		NKIssue *nkIssue = [self getIssueByName:issueName];

		if (nkIssue != nil) {
			if (nkIssue.status == NKIssueContentStatusNone) {
				NSString *remoteURL = @"https://dl.dropboxusercontent.com/u/26238/pdfkiosk/library/oil-industry/issues/2014-1-rus.pdf";
				NSURL *assetURL = [NSURL URLWithString:remoteURL];
				NSURLRequest *request = [NSURLRequest requestWithURL:assetURL];
				NKAssetDownload *asset = [nkIssue addAssetWithRequest:request];
				NSDictionary *info = @{
						@"name" : issueName,
						@"contentURL" : remoteURL
				};

				[asset setUserInfo:info];
				[asset downloadWithDelegate:self];

				pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"ok"];
			} else {
				NSString *msg = [NSString stringWithFormat:@"ussue with name \"%@\" busy, status: %d", issueName, nkIssue.status];
				pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
			}
		} else {
			NSString *msg = [NSString stringWithFormat:@"ussue with name \"%@\" not exist", issueName];
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
		}

		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)updateNewsstandIconImage:(CDVInvokedUrlCommand *)command {
	[self.commandDelegate runInBackground:^{
		CDVPluginResult *pluginResult = nil;
		NSString *coverURL = @"";
		if ([command.arguments count] >= 1) {
			coverURL = (NSString *) (command.arguments)[0];
		}

		if (coverURL != nil && [coverURL length] > 0) {
			NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:coverURL]];
			UIImage *image = [UIImage imageWithData:imageData];
			if (image) {
				[[UIApplication sharedApplication] setNewsstandIconImage:image];
			}

			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"ok"];
		} else {
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
		}

		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}


- (NKIssue *)getIssueByName:(NSString *)issueName {
	return [[NKLibrary sharedLibrary] issueWithName:issueName];
}

- (NSDictionary *)getIssueDataAsObject:(NKIssue *)nkIssue {
	NSDictionary *pluginResultDictionary = @{
			@"name" : nkIssue.name,
			@"status" : @([[@(nkIssue.status) stringValue] intValue]),
			@"date" : [[self getIssueDateFormatter:@"dd-MM-yyyy"] stringFromDate:nkIssue.date],
			@"contentURL" : [nkIssue.contentURL absoluteString]
	};

	return pluginResultDictionary;
}

- (NSDateFormatter *)getIssueDateFormatter:(NSString *)dateFormat {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:dateFormat];

	return dateFormatter;
}

- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
	float progress = [@((NSInteger) totalBytesWritten) floatValue];
	float total = [@((NSInteger) expectedTotalBytes) floatValue];
	float percentFloat = progress/total;
	int percents = (int) (percentFloat*100 + 0.5);
	NKAssetDownload *asset = [connection newsstandAssetDownload];
	NKIssue *nkIssue = [asset issue];
	NSLog(@"progress: %i, nkIssue: %@", percents, nkIssue.name);
}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL {
	// Get a reference to our NKAssetDownload and NKIssue
	NKAssetDownload *asset = [connection newsstandAssetDownload];
	NKIssue *issue = [asset issue];
	// Get the filename of our issue download from the user info
	NSString *contentURL = [asset userInfo][@"contentURL"];

	// Get the path of Issue’s folder at ~/Library/Caches/Newsstand
	NSURL *issueURL = [issue contentURL];
	NSURL *toURL = [issueURL URLByAppendingPathComponent:[contentURL lastPathComponent]];

	// Move the downloaded asset to our issue folder
	NSError *error = nil;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	bool success = [fileManager moveItemAtURL:destinationURL
										toURL:toURL
										error:&error];

	// If for some reason we failed to move the issue, tell us why
	if (!success) {
		NSLog(@"%@", [error localizedDescription]);
	} else {
		NSLog(@"success");
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"connection -> didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"connection -> didReceiveData");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"connectionDidFinishLoading");
}

@end