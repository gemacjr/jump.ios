var jrEngage;
function testPlugin()
{
    //navigator.notification.alert("testPlugin() function");

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

/* When this function is called, Phonegap has been initialized and is ready to roll */
/* If you are supporting your own protocol, the var invokeString will contain any arguments to the app
launch.
see http://iphonedevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html
for more details -jm */
function onDeviceReady()
{
    // do your thing!
    //navigator.notification.alert("Phonegap is working");

    jrEngage = window.plugins.jrEngagePlugin;

    jrEngage.initialize(
        "appcfamhnpkagijaeinl",
        "http://jrauthenticate.appspot.com/login",
        null, null); // TODO: See if I can rewrite this to only take the first args and NO callbacks
//        function(result)
//        {
////            alert("Success : \r\n"+result);
//        },
//
//        function(error)
//        {
////            alert("Error : \r\n"+error);
//        }
//    );
}

function createTwoCellTableRow(key, value)
{
    var row       = document.createElement("tr");

    var cell1     = document.createElement("td");
    var cell2     = document.createElement("td");

    var textNode1 = document.createTextNode(key);
    var textNode2 = document.createTextNode(value);

    cell1.appendChild(textNode1);
    cell2.appendChild(textNode2);

    row.appendChild(cell1);
    row.appendChild(cell2);

    return row;
}

function createOneCellTableRow(value)
{
    var row      = document.createElement("tr");
    var cell     = document.createElement("td");
    var textNode = document.createTextNode(value);

    cell.appendChild(textNode);
    row.appendChild(cell);

    return row;
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

function showAuthenticationDialog()
{
    jrEngage.showAuthentication(
        function(result)
        {
//                    alert("Success : \r\n"+result);

            var jsonBlob = decodeURIComponent(result);
            var dict = JSON.parse(jsonBlob);

            console.log(jsonBlob);

            addValueToRowInTable(dict.provider, document.getElementById("providerTable"), "singleRow", "levelOne");
            addValueToRowInTable(dict.tokenUrl, document.getElementById("tokenUrlTable"), "singleRow", "levelOne");

            var stat      = dict.stat;
            var payload   = dict.payload;
            var profile   = dict.auth_info.profile;

            console.log(profile);

            var atable = document.getElementById("authResponseTable");

            for (var key in profile) {
                if (profile.hasOwnProperty(key)) {
                    console.log("key: " + key + "\nvalue: " + profile[key]);

                    addValueToRowInTable(key, atable, "keyRow", "levelOne");

                 /* Yeah, yeah, should be recursive, but for now the auth_info profile
                    is only ever two levels deep */
                    if (profile[key] && typeof profile[key] === 'object') {
                        var subobject = profile[key];
                        for (var subkey in subobject) {
                            if (subobject.hasOwnProperty(subkey)) {
                                addValueToRowInTable(subkey, atable, "keyRow", "levelTwo");
                                addValueToRowInTable(subobject[subkey], atable, "valueRow", "levelTwo");
                            }
                        }
                    } else {
                        addValueToRowInTable(profile[key], atable, "valueRow", "levelOne");
                    }
                }
            }
        },

        function(error)
        {
//                    alert("Error : \r\n"+error);
        }
    );
}
