/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
	issues: [],
	// Application Constructor
	initialize: function () {
		this.bindEvents();
	},
	// Bind Event Listeners
	//
	// Bind any events that are required on startup. Common events are:
	// 'load', 'deviceready', 'offline', and 'online'.
	bindEvents: function () {
		document.addEventListener('deviceready', this.onDeviceReady, false);
	},
	// deviceready Event Handler
	//
	// The scope of 'this' is the event. In order to call the 'receivedEvent'
	// function, we must explicitly call 'app.receivedEvent(...);'
	onDeviceReady: function () {
		app.receivedEvent('deviceready');
	},
	// Update DOM on a Received Event
	receivedEvent: function (id) {
		console.log('Received Event: ' + id);

		//for(var i=0; i<10; i++) {
		//	navigator.Newsstand.addItem("issue-"+i, '2014-08-23 07:48:01', 'http://img1.wikia.nocookie.net/__cb20131211202311/walkingdead/images/f/f2/TWD-cover-124-dressed.jpeg');
		//}

		document.getElementById('btn-addItem').onclick = this.test_addItem;
		document.getElementById('btn-removeItem').onclick = this.test_removeItem;
		document.getElementById('btn-archiveItem').onclick = this.test_archiveItem;
		document.getElementById('btn-getItems').onclick = this.test_getItems;
		document.getElementById('btn-updateNewsstandIconImage').onclick = this.test_updateNewsstandIconImage;
		document.getElementById('btn-downloadItem').onclick = this.test_downloadItem;

		Newsstand.onDownloadProgress = function(issueName, bytesWritten, totalBytesWritten, expectedTotalBytes) {
			var progressEl = document.querySelector('#' + issueName + ' .progress');
			progressEl.style.width = Math.round(totalBytesWritten/expectedTotalBytes*100) + '%';
			console.log("onDownloadProgress->"+issueName, bytesWritten, totalBytesWritten, expectedTotalBytes);
		};

		Newsstand.onIssueStatus = function(issueName, issueStatus) {
			document.getElementById(issueName).setAttribute('data-status', issueStatus);
			console.log("onIssueStatus->"+issueName+"->"+issueStatus);
		};

		app.test_getItems();
	},
	test_addItem: function () {
		var issueName = "issue-" + app.issues.length;
		var issueDate = new Date().toISOString().slice(0, 19).replace('T', ' ');
		var successCallback = function (issueDate) {
			console.log('test_addItem->success', JSON.stringify(issueDate));
			app.test_getItems()
		};
		var errorCallback = function (msg) {
			console.log('test_addItem->error: ' + msg);
		};

		Newsstand.addItem(issueName, issueDate, successCallback, errorCallback);
	},
	test_removeItem: function () {
		var lastIssue = app.issues[0];
		var successCallback = function () {
			app.issues.pop();
			console.log('test_removeItem->success', JSON.stringify(app.issues.length));
			app.test_getItems();
		};
		var errorCallback = function (msg) {
			console.log('test_removeItem->error: ' + msg);
		};

		if (lastIssue) {
			lastIssue.remove(successCallback, errorCallback);
		} else {
			app.test_getItems();
		}
	},
	test_archiveItem: function (e) {

	},
	test_getItems: function () {
		var successCallback = function (data) {
			app.issues = data;
			console.log('test_getItems->success: ' + JSON.stringify(app.issues));
			app.updateIssuesList();
		};
		var errorCallback = function () {
			console.log('test_getItems->error');
		};
		Newsstand.getItems(successCallback, errorCallback);
	},
	test_updateNewsstandIconImage: function (e) {
		var iconUrl = 'http://img1.wikia.nocookie.net/__cb20131211202311/walkingdead/images/f/f2/TWD-cover-124-dressed.jpeg';
		var successCallback = function (msg) {
			console.log('test_updateNewsstandIconImage->success: ' + msg);
		};
		var errorCallback = function () {
			console.log('test_updateNewsstandIconImage->error');
		};

		Newsstand.updateNewsstandIconImage(iconUrl, successCallback, errorCallback);
	},
	test_downloadItem: function () {
		var lastIssue = app.issues[0];
		var successCallback = function (msgObj) {
			console.log('test_downloadItems->success: ' + JSON.stringify(msgObj));
			app.test_getItems();
		};
		var errorCallback = function (msg) {
			console.log('test_downloadItems->error: ' + msg);
		};

		if (lastIssue) {
			lastIssue.download(successCallback, errorCallback)
		} else {
			app.test_getItems();
		}
	},
	updateIssuesList: function () {
		var boxEl = document.getElementById('issues');
		var issueHtml = [];
		var currentIssue = void 0;
		var currentIssueArr = [];
		var issuesCount = app.issues.length;

		for (var i = 0; i < issuesCount; ++i) {
			currentIssueArr = [];
			currentIssue = app.issues[i];

			currentIssueArr.push('<div id="' + currentIssue.name + '" class="issue" data-status="'+currentIssue.status+'">');
			currentIssueArr.push('<h4>');
			currentIssueArr.push(currentIssue.name);
			currentIssueArr.push('</h4> ');
			currentIssueArr.push('<div class="progress"></div>');
			currentIssueArr.push('</div>');

			issueHtml.push(currentIssueArr.join(''));
		}

		boxEl.innerHTML = issueHtml.join('');
	}

};

app.initialize();