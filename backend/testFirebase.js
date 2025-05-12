const db = require('./config/firebaseConfig');

// Uji coba untuk menambah data di Firestore
db.collection('test').add({
    name: 'Test User',
    email: 'zakihattamg@gmail.com'
})
.then(() => {
    console.log('Data berhasil ditambahkan!');
})
.catch((error) => {
    console.error('Error menambah data: ', error);
});