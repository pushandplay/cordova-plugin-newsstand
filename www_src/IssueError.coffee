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

`/**
 *  IssueError.
 *  An error code assigned by an implementation when an error has occurred
 * @constructor
 */`
IssueError = (err) ->
	@code = (typeof err isnt 'undefined' ? err : null)

`/**
 * Error codes
 */`
IssueError.UNKNOWN_ERROR = 0
IssueError.INVALID_ARGUMENT_ERROR = 1
IssueError.TIMEOUT_ERROR = 2
IssueError.PENDING_OPERATION_ERROR = 3
IssueError.IO_ERROR = 4
IssueError.NOT_SUPPORTED_ERROR = 5
IssueError.PERMISSION_DENIED_ERROR = 20

module.exports = IssueError