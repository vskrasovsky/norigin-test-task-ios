# norigin-test-task-ios
iOS test task for NoriginMedia (https://github.com/NoriginMedia/candidate-tester)

### Architecture:

Simplified MVVM-C architecture is used for the project: single coordinator and bindings via swift property observers.

### Implemented interactions:
* Yellow line indicating the current program is updating live 
* Current programs are updated live
* Auto-scroll is triggered when pressing on the "NOW" button
* Auto-scroll is triggered when selecting certain day at the top days list
* Selected day is updated while scrolling tv programs
* Loading and error screen 

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

For testing on device set needed ip address for `baseApiPath` in `RequestConfig` file. 
