//var JREngagePlugin = {

//    nativeFunction: function(types, success, fail) {
//        return PhoneGap.exec(success, fail, "JREngagePlugin", "print", types);
//    }
//};


function JREngagePlugin()
{

}

JREngagePlugin.prototype.print = function(message, success, fail)
{
    // TODO: See about removing the success/fail callbacks from the PhoneGap.exec calls
    PhoneGap.exec(success, fail, 'JREngagePlugin', 'print', message);
};

JREngagePlugin.prototype.initialize = function(appid, tokenurl, success, fail)
{
    // TODO: See about removing the success/fail callbacks from the PhoneGap.exec calls
    PhoneGap.exec(success, fail, 'JREngagePlugin', 'initializeJREngage', [appid, tokenurl]);
};

JREngagePlugin.prototype.showAuthentication = function(success, fail)
{
    PhoneGap.exec(success, fail, 'JREngagePlugin', 'showAuthenticationDialog', []);
};

JREngagePlugin.install = function()
{
    if(!window.plugins)
    {
        window.plugins = {};
    }

    window.plugins.jrEngagePlugin = new JREngagePlugin();

    return window.plugins.jrEngagePlugin;
};

PhoneGap.addConstructor(JREngagePlugin.install);
