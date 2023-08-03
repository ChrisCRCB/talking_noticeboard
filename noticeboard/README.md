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

## Recommended COnfiguration

For best results with the app, I recommend the following configuration:

- Disable screen lock.
- Make sure the screen will never go automatically lock itself.
- Consider using an app like [MacroDroid](https://play.google.com/store/apps/details?id=com.arlosoft.macrodroid&hl=en_US) to re-open the app when it closes or is covered.
- Turn off all device notifications

I know this is obvious, but bears reiterating: You will be leaving a device lying about with 0 security on it. Make sure there is nothing sensitive on it.
