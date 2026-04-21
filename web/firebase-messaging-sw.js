importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyDtGuDkjHXL-0M1TnsmxrNF6XLqcbewgQY",
  authDomain: "health-and-wellness-39c4f.firebaseapp.com",
  projectId: "health-and-wellness-39c4f",
  storageBucket: "health-and-wellness-39c4f.firebasestorage.app",
  messagingSenderId: "927264643140",
  appId: "1:927264643140:web:ddd56cbb910a0104f4c411",
  measurementId: "G-ZX27Z9GYF8"
});

const messaging = firebase.messaging();