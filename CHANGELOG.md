## 0.2.1 (December 6, 2010)

- Bug fixes

  * Titan::Titan#pid has to be an Integer

## 0.2.0 (December 4, 2010)

- Features

  * Use pid files for each thread instead of one global .titan file [Issue #5]
  * !!! You've to call Titan::Thread#run in order to start the created thread

- Bug fixes

  * Synchronize threads when removing dead ones (Thanks to Tal Atlas)

## 0.1.1 (November 26, 2010)

- Features

  * Synchronize a thread after changing its id by default

## 0.1.0 (November 26, 2010)

!!! Cleaned up the API. Now, everything is available through Titan::Thread.

## 0.0.3 (November 25, 2010)

- Bug fixes

  * Fixed problems with Ruby 1.8.7

## 0.0.2 (November 24, 2010)

- Bug fixes

  * Fixed issue #1: Titan::Manager doesn't work with Ruby 1.9.2

## 0.0.1 (November 24, 2010)

Initial version.
