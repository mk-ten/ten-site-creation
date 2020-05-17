'use strict';

const redirects = require('redirects.json');

exports.handler = (event, context, callback) => {
    
    const request = event.Records[0].cf.request;  
    const response = event.Records[0].cf.response;
    
    const headers = response.headers;
    const host = request.headers['x-forwarded-host'] ? request.headers['x-forwarded-host'][0].value : request.headers['host'][0].value;
    const path = request.uri;
    const queryString = request.querystring;
    
    let locationHeader = 'https://' + host;

    // This is a custom redirect for old base-paths (e.g. /us/en-us/)

    if (redirects[host]) {
        redirects[host].forEach((redirect) => {
            if (redirect.basePath !== '/' && path.startsWith(redirect.basePath)) {
                const start = path.indexOf(redirect.basePath) + redirect.basePath.length;
                const rawQueryString = (queryString) ? '?' + queryString : '';
                const rawPath = path.slice(start) + rawQueryString;
                locationHeader += '/selector?selectedSite=' + redirect.siteId + '&redirectUrl=' + encodeURIComponent(rawPath);
                
                response.status = 301;
                
                headers['Location'] = [{
                  key: 'Location',
                  value: locationHeader
                }];
            }
        });
    }
    
    // This is adding required security headers

    headers['strict-transport-security'] = [{
      key: 'Strict-Transport-Security',
      value: 'max-age=31536000; includeSubdomains; preload'
    }];
    
    headers['X-Content-Type-Options'] = [{
      key: 'X-Content-Type-Options',
      value: 'nosniff'
    }];
    
    headers['X-Frame-Options'] = [{
      key: 'X-Frame-Options',
      value: 'DENY'
    }];
    
    headers['X-XSS-Protection'] = [{
      key: 'X-XSS-Protection',
      value: '1; mode=block'
    }];
    
    headers['Referrer-Policy'] = [{
      key: 'Referrer-Policy',
      value: 'same-origin'
    }];
      
   return callback(null, response);
};
