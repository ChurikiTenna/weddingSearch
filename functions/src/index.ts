
import * as admin from 'firebase-admin';
// @ts-ignore TS6133: 'functions' is declared but its value is never read.
import * as functions from 'firebase-functions';

admin.initializeApp(functions.config().firebase);

// Notifications
const NotificationFunctions = require('./onNotificationCreate');
export const onNotificationCreate = NotificationFunctions.onNotificationCreate;