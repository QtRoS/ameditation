/*
    YaD - unofficial Yandex.Disk client for Ubuntu Phone.
    Copyright (C) 2015  Roman Shchekin aka QtRoS

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/
*/
.pragma library

var suffixesArray = ["b", "kb", "mb", "gb"]
var PATH_DELIMITER = "/"

var STATUS_INITIAL = "initial"
var STATUS_REQUESTED = "requested"
var STATUS_INPROGRESS = "inprogress"
var STATUS_FINISHED = "finished"
var STATUS_ERROR = "error"

var TRANSFER_DOWNLOAD = "download"
var TRANSFER_UPLOAD = "upload"

function decorateFileSize(size) {
    if (!size)
        return "directory"

    var iter = 0

    for (; size > 1024; iter++)
        size = size / 1024.0

    return (Math.round(size * 100) / 100) + " " + suffixesArray[iter];
}

function decorateDate(lastMod, formatStr) {
    var strDate = Qt.formatDateTime(new Date(lastMod))
    if (!formatStr)
        return strDate
    else return formatStr.arg(strDate)
}

function decorateTitle(text) {
    var ind = text.lastIndexOf(PATH_DELIMITER) + 1
    text = text.substr(ind)
    return text
}

function getFileName(fullPath) {
    var ind = fullPath.lastIndexOf(PATH_DELIMITER)
    if (ind === -1)
        return fullPath

    return fullPath.substr(ind + 1)
}

function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
}

function combinePath(path, suffix) {
    if (endsWith(path, PATH_DELIMITER))
        return path + suffix
    else return path + PATH_DELIMITER + suffix
}

