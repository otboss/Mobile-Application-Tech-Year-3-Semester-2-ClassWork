#!/bin/bash
cd calabash-android-example;
ADB_DEVICE_ARG=00b99b2b2ed81786 calabash-android run apk/todolist.apk features/to_do_list.feature;
