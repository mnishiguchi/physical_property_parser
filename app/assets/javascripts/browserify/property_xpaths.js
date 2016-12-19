// http://stackoverflow.com/a/32082914/3837223
window.require = require;

const initializeSelectize = require('./initialize_selectize');

function propertyXpaths(initialOptionItems=[]) {

    // console.log(initialOptionItems)

    initializeSelectize({
        initialOptionItems: initialOptionItems,
        selectors         : {
                              scope          : '',
                              selectizeInput : '#property_xpaths',
        },
        valueField        : 'property_xpaths', // For the values to submit.
        labelField        : 'property_xpaths', // For the tags in the input field.
        searchField       : [ 'xpath' ],
        autocompletePath  : '/property_xpaths/autocomplete.json',
        placeholder       : 'Type a keyword and select...',
        optionListTemplate: function (item, escape) {

            console.log(item)
            
            return (`
                <h4>
                  <span class="xpath">${escape(item.xpath)}</span>
                </h4>
            `);
        },
    });
}

module.exports = propertyXpaths;
