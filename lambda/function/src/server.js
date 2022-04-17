const express = require('express');
const moment = require('moment');

const app = express();

const credential = {
    accessKeyId: process.env.AWS_ACCESS_KEY,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    region: 'ap-southeast-1',
}
const fs = require('fs');
const converter = require('json-2-csv');
const AWS = require('aws-sdk');
const s3 = new AWS.S3(credential);
const cloudwatch = new AWS.CloudWatch(credential);
const logs = new AWS.CloudWatchLogs(credential);
const pageSize = 10;

const getPaginatedResults = async (fn) => {
    const EMPTY = Symbol("empty");
    const res = [];
    for await (const lf of (async function* () {
        let NextMarker = EMPTY;
        while (NextMarker || NextMarker === EMPTY) {
            const { marker, results } = await fn(NextMarker !== EMPTY ? NextMarker : undefined);
            yield* results;
            NextMarker = marker;
        }
    })()) {
        res.push(lf);
    }
    return res;
};

async function getLogGroupInfo() {
    return await getPaginatedResults(async (NextMarker) => {
        const logGroups = await logs.describeLogGroups({ nextToken: NextMarker }).promise();
        return {
            marker: logGroups.nextToken,
            results: logGroups.logGroups,
        };
    });
}

async function getLogGroupStats() {
    let now = moment();
    return await getPaginatedResults(async (NextMarker) => {
        const logGroups = await logs.describeLogGroups({ limit: pageSize, nextToken: NextMarker }).promise();
        const metrics = await Promise.all(logGroups.logGroups.map(async lg => {
            let m = await cloudwatch.getMetricStatistics({
                Namespace: 'AWS/Logs',
                MetricName: 'IncomingBytes',
                Dimensions: [{ Name: 'LogGroupName', Value: lg.logGroupName }],
                StartTime: moment().subtract(1, 'day').toISOString(),
                EndTime: now.toISOString(),
                Period: 60,
                Statistics: ['Sum'],
                Unit: 'Bytes'
            }).promise();
            return {
                logGroupName: lg,
                IncomingBytes: m.Datapoints
            }
        }));
        return {
            marker: logGroups.nextToken,
            results: metrics
        };
    })
}

const uploadFile = async (results) => {

    const fileName = moment().toISOString() + '-IncomingBytes.csv';
    fs.readFile(fileName, (err, data) => {
        if (err) throw err;
        const params = {
            Bucket: 'testBucket', // pass your bucket name
            Key: fileName, // file will be saved as testBucket/contacts.csv
            Body: JSON.stringify(data, null, 2)
        };
        s3.upload(params, function (s3Err, data) {
            if (s3Err) throw s3Err
            console.log(`File uploaded successfully at ${data.Location}`)
        });
    });
};

const createExportTask = async () => {
    const params = {
        destination: 'myserverlessapp-logs', // replace with your bucket name
        from: moment().add(-1,'day').toDate().getTime(),
        logGroupName: '/aws/lambda/my-serverless-app-production-api',
        to: moment().toDate().getTime(),
        destinationPrefix: 'random_string', // replace with random string used to give permisson on S3 bucket
    };

    await logs.createExportTask(params).promise().then((data) => {
        console.log(data)
        res.status(200).send(data);
    }).catch((err) => {
        console.error(err)
        res.status(501).send(err);
    });
}

app.get('/healthcheck', async (req, res) => {
    res.status(200).send("healthcheck "+moment().toISOString());
});

app.get('/', async (req, res) => {
    
    
    try {
        let logs = await getLogGroupStats()
        console.log('logs ',logs);

        converter.json2csv(logs, (err, csv) => {
            if (err) {
                throw err;
            }
        
            // print CSV string
            console.log("csv",csv);
            s3.putObject({
                Bucket: 'myserverlessapp-logs',
                Key: moment().format('DD-MM-YYYY').toString()+'/IncomingBytes.csv',
                Body: csv,
                ContentType: "application/csv"},
                function (err,data) {
                    if(err){
                        console.log(JSON.stringify(err))
                        res.status(500).send(error);
                    }
                    console.log('data ',JSON.stringify(data));
                    res.status(200).send(data);
                }
              );
        });
    } catch (error) {
        console.error(error)
        res.status(500).send(error);
    }

});

module.exports = app;