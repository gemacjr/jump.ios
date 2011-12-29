//var JREngagePlugin = {

//    nativeFunction: function(types, success, fail) {
//        return PhoneGap.exec(success, fail, "JREngagePlugin", "print", types);
//    }
//};


function JREngagePlugin()
{
    //    navigator.notification.alert("In JREngagePlugin javascript constructor");
}

JREngagePlugin.prototype.print = function(message, success, fail)
{
//    navigator.notification.alert("In javascript print function");
    PhoneGap.exec(success, fail, 'JREngagePlugin', 'print', message);
};

JREngagePlugin.prototype.initialize = function(appid, tokenurl, success, fail)
{
    PhoneGap.exec(success, fail, 'JREngagePlugin', 'initializeJREngage', [appid, tokenurl]);
};

JREngagePlugin.prototype.showAuthentication = function(success, fail)
{
    PhoneGap.exec(success, fail, 'JREngagePlugin', 'showAuthenticationDialog', []);
};

JREngagePlugin.install = function()
{
    //    navigator.notification.alert("In JREngagePlugin javascript install function");

    if(!window.plugins)
//    if (typeof window.plugins == "undefined")
    {
        window.plugins = {};
    }

    window.plugins.jrEngagePlugin = new JREngagePlugin();

    return window.plugins.jrEngagePlugin;
};

PhoneGap.addConstructor(JREngagePlugin.install);
