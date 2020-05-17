'use strict';

exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.request;
    const headers = request.headers;
//
    headers['X-Forwarded-Host'] = [
        { key: 'X-Forwarded-Host', value: request.headers.host[0].value }
    ]
    
    callback(null, request);
};
