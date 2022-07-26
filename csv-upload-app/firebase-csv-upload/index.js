const COLLECTION_NAME = `prompts`
const { readFile }  = require(`fs`).promises;
const { parse } = require(`csv-parse/sync`);
const generateAutoId = require(`firebase-auto-ids`)
let firebaseAdmin = require(`firebase-admin`);
const { getDatabase } = require(`firebase-admin/database`);
let SERVICE_ACCOUNT = require(`../service_account.json`);
let DATABASE_URL = `https://mentalhealthapp-8462e-default-rtdb.firebaseio.com`;

// Check run command has CSV file location 
if (process.argv.length < 3) {
    console.error(`Please include a path to a csv file`);
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

async function writeToDatabase(records) {
  // clean/shape data for storage
  records.forEach(record => {
    record.id = id();
    record.dateCreated = new Date().toISOString();
  });

  const promptsRef = database.ref(COLLECTION_NAME);
  promptsRef.set(records, function(r) {
    console.log(`Wrote ${records.length} records`);
    process.exit()
  });
}

async function importCsv(csvFileName) {
  const fileContents = await readFile(csvFileName, `utf8`);
  const records = parse(fileContents, {
    columns: true,
    skip_empty_lines: true,
    ltrim: true,
    rtrim: true
  });

  try {
    writeToDatabase(records);
  }
  catch (e) {
    console.error(e);
  }
}
  
importCsv(process.argv[2])
  .catch(e => console.error(e));