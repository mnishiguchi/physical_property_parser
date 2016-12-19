/*******************************************************************************
==> Overview
----------------
This module provides a function that initialzes the selectize.js library as
specified in the passed-in params.

==> Assumptions
----------------
+ Rails 5 with turbolinks and browserify-rails.
+ We submit the form by Ajax with the `remote` option set to `true`
+ We use selectize.js that transforms the the input field to a suggestion list
+ A query string always reflects the current state of the form values
+ We want to trigger the form submission when any change in form input values
+ We want to replace history every time the form is submitted
+ We can navigate through the history back and forth and each page shows as
the query string indicates.

==> About Browserify
----------------
+ https://github.com/substack/browserify-handbook#exports

==> About Selectize
----------------
+ https://github.com/selectize/selectize.js/tree/master/docs
+ https://selectize.github.io/selectize.js/#demo-github
+ https://github.com/selectize/selectize.js/blob/master/examples/github.html

==> Making Transformations Idempotent
https://github.com/turbolinks/turbolinks#making-transformations-idempotent
----------------
+ We need to detect whether selectize has already been initialized so that we
can avoid duplicate selectize controls. See `isAlreadyTransformed()`.
  * e.g. If yes, set up; if no, do nothing.

==> Usage
---------------
function selectizeFeaturedProperties(initialOptionItems=[]) {

    initializeSelectize({
        initialOptionItems: initialOptionItems,
        selectors         : {
                              scope          : '#featured_properties_index',
                              selectizeInput : '#property_container_name',
                              transformation : '.selectize-control',
                              searchResult   : '#search_result',
        },
        valueField        : 'property_container_name', // For the values to submit.
        labelField        : 'property_container_name', // For the tags in the input field.
        searchField       : [ 'property_container_name', 'notes' ],
        autocompletePath  : '/featured_properties/autocomplete.json',
        placeholder       : 'Type a keyword and select...',
        optionListTemplate: function (item, escape) {
            return (`
                <div>
                  <span class="title">
                    <span class="name">${escape(item.property_container_name)}</span>
                  </span>
                  <span class="notes">
                    ${escape(item.notes)}
                  </span>
                  <ul class="meta">
                    <li class="created_at">
                      <span>${escape(item.created_at)}</span>
                    </li>
                    <li class="updated_at">
                      <span>${escape(item.updated_at)}</span>
                    </li>
                  </ul>
                </div>
            `);
        },
    });
}
*******************************************************************************/

// http://stackoverflow.com/a/32082914/3837223
window.require = require;

// Make the config object that is passed in from outside be available throughout
// this file.
let config;


// ---
// PUBLIC INTERFACE
// ---


/**
 * Sets up the selectize and stores the reference to the selectize object.
 */
function initializeSelectize(params) {
    console.log("initializeSelectize");

    config = params;

    // Reject if there is no element with the selectizeInputSelector in DOM.
    // Reject if the selectize has already been initialized.
    // NOTE: This is important to avoid initializing selectize twice.
    if (!selectizeInputSelectorExists() || isAlreadyTransformed()) { return; }

    let selectedItems = getCurrentlySelectedItems();

    // ==> Configure selectize.
    // https://github.com/selectize/selectize.js/blob/master/docs/usage.md#data_searching
    // https://github.com/selectize/selectize.js/blob/master/docs/api.md#selectize-api
    const selectizeObject = $(config.selectors.selectizeInput).selectize({
        valueField  : config.valueField,  // For the values to be submitted.
        labelField  : config.labelField,  // For the labels in the input field.
        searchField : config.searchField, // The fields that we want selectize to search on.
        placeholder : config.placeholder,
        options     : config.initialOptionItems,
        items       : selectedItems,
        render      : { option: config.optionListTemplate },
        load        : load,
        onChange    : (value) => { console.log(value); submitForm(); }
    })[0].selectize;

    listenForSelectChange();
    listenForFormSubmit();
}


// ---
// PRIVATE FUNCTIONS
// ---


/**
 * Listens for a change on all the selectors in the scope.
 */
function listenForSelectChange() {
    $(`${config.selectors.scope} select`).on('change', () => {
        submitForm();
    });
}

/**
 * Listens for a form submission in the scope.
 * NOTE: We assume that there is only one form in the scope.
 */
function listenForFormSubmit() {
    // Add loading message when submit button is clicked.
    $(`${config.selectors.scope} form`).on('submit', () => {
        updateQueryStringAndReplaceState();
        showLoadingMessage();
    });
}

/**
 * Reads a list of currently selected items from the query string.
 */
function getCurrentlySelectedItems() {
    const urlParams = new URLSearchParams(window.location.search);
    const values    = urlParams.get(config.valueField);

    if (values) { return values.split(','); }
}

/**
 * @return {Boolean} true if the selectizeInputSelector exists in the DOM.
 */
function selectizeInputSelectorExists() {
    return $(config.selectors.selectizeInput).length;
}

/**
 * https://github.com/turbolinks/turbolinks#making-transformations-idempotent
 * @return {Boolean} true if selectize has already been initialized.
 */
function isAlreadyTransformed() {
    // Detect the existence of the transformationSelector in the DOM.
    return $(config.selectors.transformation).length;
}

/**
 * Generates a query string that reflects the current state of the form and
 * replaces the history state for the page with the generated query string.
 */
function updateQueryStringAndReplaceState() {
    // Generate a query string for the current form state.
    const queryString = $(`${config.selectors.scope} form`).serialize();

    // Update the history for the current page.
    history.replaceState(history.state, '', `?${queryString}`);
}

/**
 * Submits the form. We assume there is only one form in a given scope.
 */
function submitForm() {
    $(`${config.selectors.scope} form`).submit();
}

/**
 * https://github.com/selectize/selectize.js/blob/master/docs/usage.md#callbacks
 */
function load(query, callback) {
    if (!query.length) { return callback(); }

    $.ajax({
        url: `${config.autocompletePath}?q=${encodeURIComponent(query)}`,
        type: 'GET',
        error: reason => {
            console.error(reason);
            callback();
        },
        success: res => {
            console.log(res.results);
            callback(res.results.slice(0, 10));
        }
    });
}

/**
 * Shows a loading message that will be removed when search results are updated.
 * NOTE: The message is appended to the element that is specified in the config
 * so that the message will be removed automatically when the results are updated.
 */
function showLoadingMessage() {
    // The loading message relies on the pure-css-loader library's css file.
    // https://github.com/raphaelfabeni/css-loader
    $(config.selectors.searchResult).append(`
        <div style="position:absolute;top:0;left:0;width:100%;height:100%;">
          <div class="loader loader-default is-active"></div>
        </div>
    `);
}

module.exports = initializeSelectize;
