# norigin-test-task-ios
iOS test task for NoriginMedia

### Mock-API:

A basic mock api is provided to supply EPG data for this task. 

This is packaged as a standard Node NPM module. To install simply run: `npm install` from the project root directory.
Of course Node.JS should be installed beforehand. For Native Developers not familar with NPM here is the [NPM Documentation](https://docs.npmjs.com/getting-started/installing-node)

To run the update & run mock-api server execute the command below:

```
npm run start
```
You should see the server start on port 1337.
```
Mock service running at http://localhost:1337
```
You can now request data from the mock-api: 
`Try It: http://localhost:1337/epg`
