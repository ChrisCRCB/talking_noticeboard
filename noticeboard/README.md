# Talking Noticeboard

## Description

This is a two-part piece of software, which allows the creation of a talking noticeboard, running on a touchscreen device running Android, and possibly other platforms as well.

## Setup

### 1. Running the server

Running `server/bin/server.dart` will start a web server which gets notices from a directory you specify.

For example:

```shell
cd server
dart bin/server.dart c:\users\someone\OneDrive\talking_notices
```

You'll now want to use something like [ngrok](https://ngrok.com/) to allow the noticeboard client to see the server.

```shell
ngrok http 8080
```

### 2. Configuring the URL in the client

When you first load the client, either with a call to `flutter run` or by running a pre-built APK, the noticeboard will prompt you to enter a notices URL. If connections to this URL fail, the same screen will come up again. There is no other way to change the URL.

### 3. Showing notices

So long as the app can connect to the server, it will display notices whenever someone taps or otherwise interacts with the screen.

Every effort has been made to keep users from inadvertently closing the app, but a home button, hardware or simulated, will still close the app.

## Recommended Configuration

For best results with the app, I recommend the following configuration:

- Disable screen lock.
- Make sure the screen will never go automatically lock itself.
- Set screen brightness and music volumes to a comfortable level.
- Consider using an app like [MacroDroid](https://play.google.com/store/apps/details?id=com.arlosoft.macrodroid&hl=en_US) to re-open the app when it closes or is covered.
- Turn off all device notifications

I know this is obvious, but bears reiterating: You will be leaving a device lying about with 0 security on it. Make sure there is nothing sensitive on it.

## Notices

To create new notices, simple create a new folder in the notices folder you used when starting the server.

In this folder, there should be either 1 text document (that is a plain text documented created in Windows Notepad or the like with a `.txt` extension), or a single MP3 file.

If no text is available, then a default message will be used. This is definitely *not* what you want.

If there is no MP3 file, then the device text-to-speech will be used instead.

To remove notices from the noticeboard, just delete the folder containing the text and audio files.

## Problems

If you have any problems with this software, either [create an issue](https://github.com/ChrisCRCB/talking_noticeboard/issues/new), or send me an [email](chris@crcb.org.uk).
