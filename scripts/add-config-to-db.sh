# Mongo shell script

# Variables (replace these with your actual values)
connectionString="$2"
databaseName="$3"
collectionName="$4"

# Connect to the MongoDB API account
mongo $connectionString

# In the mongo shell, select the database
use $databaseName

# Add a document to the collection
db.$collectionName.insert({
    "id": "1",
    "Hash": "api",
    "fqdn": "$1"
})