const COLLECTION_NAME = `prompts`
const { readFile }  = require(`fs`).promises;
const fs = require('fs');
const { parse } = require(`csv-parse/sync`);
const generateAutoId = require(`firebase-auto-ids`)
let firebaseAdmin = require(`firebase-admin`);
const { getDatabase } = require(`firebase-admin/database`);
let SERVICE_ACCOUNT = require(`../service_account.json`);
let DATABASE_URL = `https://mentalhealthapp-8462e-default-rtdb.firebaseio.com`;

// Check run command has CSV file location 
if (process.argv.length < 3) {
    console.error(`Please include a path to a csv files`);
    process.exit(1);
}

// Initialize Firebase Admin app
firebaseAdmin.initializeApp({
  credential: firebaseAdmin.credential.cert(SERVICE_ACCOUNT),
  databaseURL: DATABASE_URL
});

// Get a database reference
const database = getDatabase();

function id () {
  return generateAutoId(new Date().getTime())
}

const writeToDatabase = async (collectionName, records) => {
  // clean/shape data for storage
  records.forEach(record => {
    record.id = id();
    record.dateCreated = new Date().toISOString();
    record.category = collectionName;
    firebaseAdmin.firestore().collection(COLLECTION_NAME).doc(record.id).set(record).then(writeResult => {
      // Send back a message that we've succesfully written the message
      console.log(`${record.category} - Wrote ${record.id}`);
    });
  });

  // const promptsRef = database.ref(collectionName);
  // promptsRef.set(records, function(r) {
  //   process.exit()
  // });
  console.log(`${collectionName} - Wrote ${records.length} records`);
}

const importCsv = async (csvsFolders) => {
  var files = fs.readdirSync(csvsFolders);
  for (const csvfile of files) {
    let fileContents = await readFile(csvsFolders + csvfile, `utf8`);
    const records = parse(fileContents, {
      columns: true,
      skip_empty_lines: true,
      ltrim: true,
      rtrim: true
    });

    // remove empty keys from object
    let cleanedRecords = records.map(item => {
      return clean(item)
    })
    
    try {
      let filename = csvfile.substring(0, csvfile.lastIndexOf('.'));
      await writeToDatabase(filename, cleanedRecords);
    }
    catch (e) {
      console.error(e);
    }
  }
}

function clean(obj) {
  for (var propName in obj) {
    if (obj[propName] === '' || obj[propName] === null || obj[propName] === undefined) {
      delete obj[propName];
    }
  }
  let newObj = toCamel(obj);
  return newObj;
}

function toCamel(o) {
  var newO, origKey, newKey, value
  if (o instanceof Array) {
    return o.map(function(value) {
        if (typeof value === "object") {
          value = toCamel(value)
        }
        return value
    })
  } else {
    newO = {}
    for (origKey in o) {
      if (o.hasOwnProperty(origKey)) {
        newKey = (origKey.charAt(0).toLowerCase() + origKey.slice(1) || origKey).toString()
        value = o[origKey]
        if (value instanceof Array || (value !== null && value.constructor === Object)) {
          value = toCamel(value)
        }
        newO[newKey] = value
      }
    }
  }
  return newO
}
  
importCsv(process.argv[2])
  .catch(e => console.error(e));