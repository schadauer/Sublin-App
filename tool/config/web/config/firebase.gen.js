 var firebaseConfig = {
    apiKey: "%sys.env.SUBLIN_WEB_FIREBASE_API_KEY%",
    authDomain: "%sys.env.SUBLIN_WEB_FIREBASE_AUTH_DOMAIN%",
    projectId: "%sys.env.SUBLIN_WEB_FIREBASE_PROJECT_ID%",
    storageBucket: "%sys.env.SUBLIN_WEB_FIREBASE_STORAGE_BUCKET%",
    messagingSenderId: "%sys.env.SUBLIN_WEB_FIREBASE_MESSAGING_SENDER_ID%",
    appId: "%sys.env.SUBLIN_WEB_FIREBASE_APP_ID%",
    measurementId: "%sys.env.SUBLIN_WEB_FIREBASE_MEASUREMENT_ID%"
  };
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);
  firebase.analytics();
