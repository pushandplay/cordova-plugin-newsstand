`/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/`

argscheck = require 'cordova/argscheck'
exec = require 'cordova/exec'
utils = require 'cordova/utils'

`/**
* Contains information about a single issue.
* @constructor
* @param {DOMString} id unique identifier
* @param {DOMString} date
* @param {DOMString} url
* @param {DOMString} cover
*/`
Issue = (@id, @date, @file, @cover) -> @

`/**
* Persists issue metadata to device storage.
* @param successCB success callback
* @param errorCB error callback
*/`
Issue::add = (id, date, successCB, errorCB) ->
Issue::get = (id) ->
Issue::delete = (id, archive = false) ->
Issue::download = (id, url) ->
Issue::addCover = (id, url, successCB, errorCB) ->


module.exports = Issue