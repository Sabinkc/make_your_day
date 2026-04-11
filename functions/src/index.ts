import { onSchedule } from 'firebase-functions/v2/scheduler';
import { onCall } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();

// ============================================
// SCHEDULED FUNCTION - Runs every minute
// ============================================
export const checkAndSendNotifications = onSchedule(
  {
    schedule: '* * * * *',
    timeZone: 'Asia/Kathmandu',
    retryCount: 3,
    timeoutSeconds: 540,
    memory: '256MiB',
  },
  async (event) => {
    console.log('🕐 Checking for scheduled notifications...');
    
    const now = new Date();
    const currentTime = `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`;
    
    try {
      const usersSnapshot = await db.collection('user_notification_settings').get();
      let notificationsSent = 0;
      
      for (const userDoc of usersSnapshot.docs) {
        const settings = userDoc.data();
        if (!settings.notificationsEnabled) continue;
        
        const services = settings.services || {};
        
        for (const [serviceId, serviceData] of Object.entries(services)) {
          const service = serviceData as any;
          if (!service.enabled) continue;
          
          const times = service.times || [];
          if (times.includes(currentTime)) {
            const today = new Date().toDateString();
            const lastSentKey = `last_sent_${serviceId}_${currentTime.replace(':', '_')}`;
            
            if (settings[lastSentKey] === today) continue;
            
            // Get random content from Firestore
            const contentSnapshot = await db
              .collection('all_services')
              .doc(serviceId)
              .collection('service_subcategories')
              .doc('all')
              .collection('data')
              .get();
            
            if (!contentSnapshot.empty) {
              // Pick random content
              const randomIndex = Math.floor(Math.random() * contentSnapshot.docs.length);
              const content = contentSnapshot.docs[randomIndex].data().value;
              const userName = settings.userName || 'Friend';
              const personalizedContent = content.replace(/\$name/g, userName);
              
              // Get user's FCM tokens
              const userTokensDoc = await db.collection('users').doc(userDoc.id).get();
              const tokensData = userTokensDoc.data()?.fcm_tokens || [];
              const tokens = tokensData.map((t: any) => t.token);
              
              if (tokens.length > 0) {
                // Send to all tokens
                const message = {
                  notification: {
                    title: getServiceTitle(serviceId),
                    body: personalizedContent,
                  },
                  data: { 
                    service: serviceId,
                    click_action: 'FLUTTER_NOTIFICATION_CLICK'
                  },
                  tokens: tokens,
                };
                
                const response = await admin.messaging().sendEachForMulticast(message);
                console.log(`✅ Sent to ${response.successCount} devices for ${serviceId}`);
              }
              
              await userDoc.ref.update({ [lastSentKey]: today });
              notificationsSent++;
            }
          }
        }
      }
      
      console.log(`✅ Sent ${notificationsSent} notifications at ${currentTime}`);
      return;
      
    } catch (error) {
      console.error('Error in notification scheduler:', error);
      return;
    }
  }
);

// ============================================
// SAVE NOTIFICATION SETTINGS
// ============================================
export const saveNotificationSettings = onCall(
  {
    cors: true,
    timeoutSeconds: 30,
    memory: '256MiB',
  },
  async (request) => {
    try {
      const data = request.data;
      const { userId, userName, notificationsEnabled, services } = data;
      
      if (!userId) {
        throw new Error('User ID required');
      }
      
      await db.collection('user_notification_settings').doc(userId).set({
        userId: userId,
        userName: userName || '',
        notificationsEnabled: notificationsEnabled || false,
        services: services || {},
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });
      
      return { success: true, message: 'Settings saved successfully' };
      
    } catch (error) {
      console.error('Error saving settings:', error);
      throw new Error('Failed to save settings');
    }
  }
);

// ============================================
// REGISTER FCM TOKEN
// ============================================
export const registerFCMToken = onCall(
  {
    cors: true,
    timeoutSeconds: 30,
    memory: '256MiB',
  },
  async (request) => {
    try {
      const data = request.data;
      const { userId, fcmToken, deviceType, deviceName } = data;
      
      if (!userId || !fcmToken) {
        throw new Error('User ID and FCM token required');
      }
      
      const userRef = db.collection('users').doc(userId);
      const userDoc = await userRef.get();
      
      if (!userDoc.exists) {
        await userRef.set({
          userId: userId,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }
      
      await userRef.update({
        fcm_tokens: admin.firestore.FieldValue.arrayUnion({
          token: fcmToken,
          deviceType: deviceType || 'unknown',
          deviceName: deviceName || 'unknown',
          registeredAt: admin.firestore.FieldValue.serverTimestamp(),
        }),
        lastActive: admin.firestore.FieldValue.serverTimestamp(),
      });
      
      return { success: true, message: 'Token registered successfully' };
      
    } catch (error) {
      console.error('Error registering token:', error);
      throw new Error('Failed to register token');
    }
  }
);

// ============================================
// REMOVE FCM TOKEN (for logout)
// ============================================
export const removeFCMToken = onCall(
  {
    cors: true,
    timeoutSeconds: 30,
    memory: '256MiB',
  },
  async (request) => {
    try {
      const data = request.data;
      const { userId, fcmToken } = data;
      
      if (!userId || !fcmToken) {
        throw new Error('User ID and FCM token required');
      }
      
      await db.collection('users').doc(userId).update({
        fcm_tokens: admin.firestore.FieldValue.arrayRemove({
          token: fcmToken,
        }),
      });
      
      return { success: true, message: 'Token removed successfully' };
      
    } catch (error) {
      console.error('Error removing token:', error);
      throw new Error('Failed to remove token');
    }
  }
);

// ============================================
// TEST NOTIFICATION (for debugging)
// ============================================
export const sendTestNotification = onCall(
  {
    cors: true,
    timeoutSeconds: 30,
    memory: '256MiB',
  },
  async (request) => {
    try {
      const data = request.data;
      const { userId, serviceId } = data;
      
      if (!userId) {
        throw new Error('User ID required');
      }
      
      // Get user's tokens
      const userTokensDoc = await db.collection('users').doc(userId).get();
      const tokensData = userTokensDoc.data()?.fcm_tokens || [];
      const tokens = tokensData.map((t: any) => t.token);
      
      if (tokens.length === 0) {
        return { success: false, message: 'No FCM tokens found for this user' };
      }
      
      // Get random content
      const service = serviceId || 'affirmations';
      const contentSnapshot = await db
        .collection('all_services')
        .doc(service)
        .collection('service_subcategories')
        .doc('all')
        .collection('data')
        .get();
      
      let content = "This is a test notification!";
      if (!contentSnapshot.empty) {
        const randomIndex = Math.floor(Math.random() * contentSnapshot.docs.length);
        content = contentSnapshot.docs[randomIndex].data().value;
      }
      
      // Get user name
      const settingsDoc = await db.collection('user_notification_settings').doc(userId).get();
      const userName = settingsDoc.data()?.userName || 'Friend';
      const personalizedContent = content.replace(/\$name/g, userName);
      
      // Send notification
      const message = {
        notification: {
          title: '🧪 Test Notification',
          body: personalizedContent,
        },
        data: { service: service },
        tokens: tokens,
      };
      
      const response = await admin.messaging().sendEachForMulticast(message);
      
      return { 
        success: true, 
        message: `Test notification sent to ${response.successCount} devices` 
      };
      
    } catch (error) {
      console.error('Error sending test notification:', error);
      throw new Error('Failed to send test notification');
    }
  }
);

// Helper function to get service title
function getServiceTitle(serviceId: string): string {
  const titles: Record<string, string> = {
    affirmations: '✨ Daily Affirmation',
    motivations: '🔥 Daily Motivation',
    quotes: '📚 Quote of the Day',
    jokes: '😂 Daily Joke',
    compliments: '💝 Sweet Compliment',
  };
  return titles[serviceId] || '🌟 Make Your Day';
}