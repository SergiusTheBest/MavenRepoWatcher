import std.json;
import std.file;

class ConfigData
{
    public this(in string fileName)
    {
        auto jsonString = readText(fileName);
        auto json = parseJSON(jsonString);

        string[] packageUrls;
        
        foreach (val; json["packageUrls"].array)
        {
            packageUrls ~= val.str;
        }

        this.packageUrls = cast(immutable string[])packageUrls;
        this.notifyEmail = json["notifyEmail"].str;
        this.senderSmtp = json["sender"]["smtp"].str;
        this.senderEmail = json["sender"]["email"].str;
        this.senderPassword = json["sender"]["password"].str;
    }

    public immutable string[] packageUrls;
    public immutable string notifyEmail;
    public immutable string senderSmtp;
    public immutable string senderEmail;
    public immutable string senderPassword;
}