importScripts(
  "https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyCsJ2OcLNNjOtuIuz87kuqDaU2RDZ2KsOs",
  authDomain: "building-report-system.firebaseapp.com",
  projectId: "building-report-system",
  storageBucket: "building-report-system.appspot.com",
  messagingSenderId: "391687245600",
  appId: "1:391687245600:web:3876f3f20edc2b363dd145",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((m) => {
  console.log("Messaggio in background in arrivo: ", m);
});
