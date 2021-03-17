  var firebaseConfig = {
    apiKey: "%sys.env.SUBLIN_FIREBASE_API_KEY_WEB%",
    authDomain: "%sys.env.SUBLIN_FIREBASE_AUTH_DOMAIN_WEB%",
    databaseURL: "%sys.env.SUBLIN_FIREBASE_URL%",
    projectId: "%sys.env.SUBLIN_FIREBASE_PROJECT_ID%",
    storageBucket: "%sys.env.SUBLIN_FIREBASE_STORAGE_BUCKET%",
    messagingSenderId: "%sys.env.SUBLIN_FIREBASE_PROJECT_NUMBER%",
    appId: "%sys.env.SUBLIN_FIREBASE_MOBILE_SDK_APP_ID_WEB%",
    measurementId: "%sys.env.SUBLIN_FIREBASE_MEASUREMENT_ID_WEB%"
  };
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);
  firebase.analytics();
