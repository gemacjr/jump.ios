var jrEngage;
function testJREngagePlugin()
{
    jrEngage.print
    (
        ["HelloxWorld"],

        function(result)
        {
            alert("Success : \r\n"+result);
        },

        function(error)
        {
            alert("Error : \r\n"+error);
        }
    );
}

function onBodyLoad()
{
    document.addEventListener("deviceready", onDeviceReady, false);
}

function onDeviceReady()
{
    jrEngage = window.plugins.jrEngagePlugin;

    var appId    = "appcfamhnpkagijaeinl";
    var tokenUrl = "http://jrauthenticate.appspot.com/login";

    jrEngage.initialize(
        appId,
        tokenUrl,
        null, null); // TODO: See if I can rewrite this to only take the first args and NO callbacks
}

function addValueToRowInTable(value, table, baseClassAttr, indentationClassAttr)
{
    var row      = document.createElement("tr");
    var cell     = document.createElement("td");
    var textNode = document.createTextNode(value);

    if (baseClassAttr) {
        row.className += baseClassAttr;
    }

    if (indentationClassAttr) {
        cell.className += indentationClassAttr;
    }

    if (baseClassAttr != "keyRow") {
        var div = document.createElement("div");
        div.className += "ellipsize";

        var nobr = document.createElement("nobr");

        nobr.appendChild(textNode);
        div.appendChild(nobr);

        cell.appendChild(div);
    }
    else {
        cell.appendChild(textNode);
    }

    row.appendChild(cell);
    table.appendChild(row);
}

function updateTables(resultDictionary)
{
    // TODO: Unhide the tables...

    addValueToRowInTable(resultDictionary.provider, document.getElementById("providerTable"), "singleRow", "levelOne");
    addValueToRowInTable(resultDictionary.tokenUrl, document.getElementById("tokenUrlTable"), "singleRow", "levelOne");

    var profile = resultDictionary.auth_info.profile;

    console.log(profile);

    var profileTable = document.getElementById("profileTable");

    for (var key in profile) {
        if (profile.hasOwnProperty(key)) {

            addValueToRowInTable(key, profileTable, "keyRow", "levelOne");

         /* Yeah, yeah, should be recursive, but for now the auth_info profile
            is only ever two levels deep */
            if (profile[key] && typeof profile[key] === 'object') {
                var subobject = profile[key];
                for (var subkey in subobject) {
                    if (subobject.hasOwnProperty(subkey)) {
                        addValueToRowInTable(subkey, profileTable, "keyRow", "levelTwo");
                        addValueToRowInTable(subobject[subkey], profileTable, "valueRow", "levelTwo");
                    }
                }
            } else {
                addValueToRowInTable(profile[key], profileTable, "valueRow", "levelOne");
            }
        }
    }
}

function handleAuthenticationResult(resultDictionary)
{
    var stat    = resultDictionary.stat;
    var payload = resultDictionary.payload;

    updateTables(resultDictionary);
}

function handleAuthenticationError(errorDictionary)
{

}

function showAuthenticationDialog()
{
    // TODO: Remove children elements from the tables...
    // TODO: Hide the tables...

    jrEngage.showAuthentication(
        function(result)
        {
            var jsonBlob         = decodeURIComponent(result);
            var resultDictionary = JSON.parse(jsonBlob);

            console.log(jsonBlob);

            handleAuthenticationResult(resultDictionary);
        },

        function(error)
        {
            var jsonBlob        = decodeURIComponent(error);
            var errorDictionary = JSON.parse(jsonBlob);

            console.log(jsonBlob);

            handleAuthenticationError(errorDictionary);
        }
    );
}
