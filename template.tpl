___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "DD Hubspot Consent State/Status (Unofficial)",
  "description": "Use with the Hubspot Consent Banner to identify the individual website user\u0027s consent state and configure when tags should execute.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "hubspotConsentStateCheckType",
    "displayName": "Select Consent State Check Type",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "hubspotAllConsentState",
        "displayValue": "All Consent State Check"
      },
      {
        "value": "hubspotSpecificConsentState",
        "displayValue": "Specific Consent State"
      }
    ],
    "simpleValueType": true,
    "help": "Select the type of consent state check you want to perform—either a specific consent category or all consent categories, based on Termly."
  },
  {
    "type": "RADIO",
    "name": "hubspotConsentCategoryCheck",
    "displayName": "Select Consent Category",
    "radioItems": [
      {
        "value": "hubspotNecessary",
        "displayValue": "Necessary"
      },
      {
        "value": "hubspotAnalytics",
        "displayValue": "Analytics"
      },
      {
        "value": "hubspotAdvertisement",
        "displayValue": "Advertisement"
      },
      {
        "value": "hubspotFunctionality",
        "displayValue": "Functionality"
      }
    ],
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "hubspotConsentStateCheckType",
        "paramValue": "hubspotSpecificConsentState",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "hubspotEnableOptionalConfig",
    "checkboxText": "Enable Optional Output Transformation",
    "simpleValueType": true
  },
  {
    "type": "GROUP",
    "name": "hubspotOptionalConfig",
    "displayName": "Hubspot Consent State Value Transformation",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SELECT",
        "name": "hubspotTrue",
        "displayName": "Transform \"True\"",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "hubspotTrueGranted",
            "displayValue": "granted"
          },
          {
            "value": "hubspotTrueAccept",
            "displayValue": "accept"
          }
        ],
        "simpleValueType": true
      },
      {
        "type": "SELECT",
        "name": "hubspotFalse",
        "displayName": "Transform \"False\"",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "hubspotFalseDenied",
            "displayValue": "denied"
          },
          {
            "value": "hubspotFalseDeny",
            "displayValue": "deny"
          }
        ],
        "simpleValueType": true
      },
      {
        "type": "CHECKBOX",
        "name": "hubspotUndefined",
        "checkboxText": "Also transform \"undefined\" to \"denied\"",
        "simpleValueType": true
      }
    ],
    "enablingConditions": [
      {
        "paramName": "hubspotEnableOptionalConfig",
        "paramValue": true,
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const getCookieValues = require('getCookieValues');
const makeString = require('makeString');
const copyFromWindow = require('copyFromWindow');
const Object = require('Object');
const getType = require('getType');
const decode = require('decodeUriComponent');

const checkType = data.hubspotConsentStateCheckType;
const transformEnabled = data.hubspotEnableOptionalConfig === true;

// Optional transformations
function transform(value) {
  if (value === true) {
    if (data.hubspotTrue === 'hubspotTrueGranted') return 'granted';
    if (data.hubspotTrue === 'hubspotTrueAccept') return 'accept';
  } else if (value === false) {
    if (data.hubspotFalse === 'hubspotFalseDenied') return 'denied';
    if (data.hubspotFalse === 'hubspotFalseDeny') return 'deny';
  } else if (value === undefined && data.hubspotUndefined === true) {
    return 'denied';
  }
  return value;
}

// Parse __hs_cookie_cat_pref cookie into a category map
function parseCookieValue(cookieValue) {
  const result = {
    necessary: true, // always true
    analytics: undefined,
    advertisement: undefined,
    functionality: undefined,
  };

  if (getType(cookieValue) !== 'string') return result;

  const parts = cookieValue.split('_');
  parts.forEach(function (part) {
    const splitPair = part.split(':');
    const key = splitPair[0];
    const value = splitPair[1];
    const boolVal = value === 'true';
    if (key === '1') result.analytics = boolVal;
    else if (key === '2') result.advertisement = boolVal;
    else if (key === '3') result.functionality = boolVal;
  });

  return result;
}

// Fallback logic if cookie is missing or invalid
function getFallbackConsent() {
  const hsp = copyFromWindow('_hsp');
  if (getType(hsp) === 'undefined') return undefined;

  return {
    necessary: true,
    analytics: false,
    advertisement: false,
    functionality: false,
  };
}

// MAIN EXECUTION
const cookieArray = getCookieValues('__hs_cookie_cat_pref');
const cookieValRaw = (cookieArray && cookieArray.length > 0) ? makeString(cookieArray[0]) : undefined;

// decode the cookie value only if it's defined
const cookieValDecoded = getType(cookieValRaw) === 'string' ? decode(cookieValRaw) : undefined;

const categoryMap = cookieValDecoded ? parseCookieValue(cookieValDecoded) : getFallbackConsent();

if (getType(categoryMap) !== 'object') return undefined;

if (checkType === 'hubspotAllConsentState') {
  if (transformEnabled) {
    Object.keys(categoryMap).forEach(function (key) {
      categoryMap[key] = transform(categoryMap[key]);
    });
  }
  return categoryMap;
}

if (checkType === 'hubspotSpecificConsentState') {
  let selectedCategory;
  switch (data.hubspotConsentCategoryCheck) {
    case 'hubspotNecessary':
      selectedCategory = 'necessary';
      break;
    case 'hubspotAnalytics':
      selectedCategory = 'analytics';
      break;
    case 'hubspotAdvertisement':
      selectedCategory = 'advertisement';
      break;
    case 'hubspotFunctionality':
      selectedCategory = 'functionality';
      break;
    default:
      return undefined;
  }

  let value = categoryMap[selectedCategory];
  if (transformEnabled) value = transform(value);
  return value;
}

// Default fallback
return undefined;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_hsp"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "__hs_cookie_cat_pref"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 5/20/2025, 9:16:56 AM


