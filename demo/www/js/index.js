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
		document.getElementById('btn-updateItem').onclick = this.test_updateItem;
		document.getElementById('btn-getItems').onclick = this.test_getItems;
		document.getElementById('btn-updateNewsstandIconImage').onclick = this.test_updateNewsstandIconImage;
	},
	test_addItem: function (e) {
		var issueName = "issue-0";
		var issueDate = new Date().toISOString().slice(0, 19).replace('T', ' ');
		var iconUrl = 'http://img1.wikia.nocookie.net/__cb20131211202311/walkingdead/images/f/f2/TWD-cover-124-dressed.jpeg';
		var successCallback = function (issueDate) {
			console.log('test_addItem->success', JSON.stringify(issueDate));
		};
		var errorCallback = function (msg) {
			console.log('test_addItem->error: ' + msg);
		};

		var issueItem = Newsstand.addItem(issueName, issueDate, iconUrl);
		issueItem.save(successCallback, errorCallback);
	},
	test_removeItem: function (e) {

	},
	test_archiveItem: function (e) {

	},
	test_updateItem: function (e) {

	},
	test_getItems: function (e) {
		var successCallback = function (data) {
			console.log('test_getItems->success: ' + JSON.stringify(data));
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
	}
};

app.initialize();