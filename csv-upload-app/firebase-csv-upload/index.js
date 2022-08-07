const COLLECTION_NAME = `prompts2`
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
  });

  const promptsRef = database.ref(collectionName);
  promptsRef.set(records, function(r) {
    process.exit()
  });
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
    records.forEach(element => {
      clean(element)
    });
    
    try {
      let filename = csvfile.substring(0, csvfile.lastIndexOf('.'));
      await writeToDatabase(filename, records);
    }
    catch (e) {
      console.error(e);
    }
  }
}

const clean = async (obj) => {
  for (var propName in obj) {
    if (obj[propName] === '' || obj[propName] === null || obj[propName] === undefined) {
      delete obj[propName];
    }
  }
  return obj
}

  
importCsv(process.argv[2])
  .catch(e => console.error(e));