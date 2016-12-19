//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require list.min.js
//= require list.fuzzysearch.min.js
//= require selectize
//= require_self

// A container for namespacing our js code.
window.app = window.app || {};

// Expose our browerified modules.
window.app.selectizeGithubSearch = require('browserify/selectize_github_search');
window.app.propertyXpaths        = require('browserify/property_xpaths');
