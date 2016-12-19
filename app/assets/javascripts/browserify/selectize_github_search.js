// About Browserify
// + https://github.com/substack/browserify-handbook#exports

// About Selectize
// + https://selectize.github.io/selectize.js/#demo-github
// + https://github.com/selectize/selectize.js/blob/master/examples/github.html

// Github repository search api
// + https://api.github.com/legacy/repos/search/:query
// + https://api.github.com/legacy/repos/search/elastic_selectize

// http://stackoverflow.com/a/32082914/3837223
window.require = require;

module.exports = function() {
    console.log("hello from selectize_github_search.js");

    // Reject if the selectize has already been initialized.
    if (isAlreadyTransformed()) { return; }

    $('#select-repo').selectize({
        valueField : 'url',
        labelField : 'name',
        searchField: 'name',
        create     : false,
        render     : { option: renderOption },
        score      : score,
        load       : load
    });
};


// ---
// PRIVATE FUNCTIONS
// ---


// https://github.com/turbolinks/turbolinks#making-transformations-idempotent
function isAlreadyTransformed() {
    return $('.selectize-control').length;
}

function score(search) {
    var score = this.getScoreFunction(search);
    return function(item) {
        return score(item) * (1 + Math.min(item.watchers / 100, 1));
    };
}

function load(query, callback) {
    if (!query.length) { return callback(); }

    $.ajax({
        url: `https://api.github.com/legacy/repos/search/${encodeURIComponent(query)}`,
        type: 'GET',
        error: () => {
            callback();
        },
        success: res => {
            console.log(res.repositories)
            callback(res.repositories.slice(0, 10));
        }
    });
}

function renderOption(item, escape) {
    return (`
        <div>
        <span class="title">
          <span class="name">${escape(item.name)}</span>
          <span class="by">  ${escape(item.username)}</span>
        </span>
        <span class="description">
          ${escape(item.description)}
        </span>
        <ul class="meta">
          <li class="watchers">
            <span>${escape(item.watchers)}</span> watchers
          </li>
          <li class="forks">
            <span>${escape(item.forks)}</span> forks
          </li>
        </ul>
        </div>
    `);
}
