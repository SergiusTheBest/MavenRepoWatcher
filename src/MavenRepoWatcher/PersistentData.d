import std.json;
import std.file;

class PersistentData
{
    public static PersistentData load(in string fileName)
    {
        auto self = new PersistentData();

        if (exists(fileName))
        {
            auto jsonString = readText(fileName);
            auto json = parseJSON(jsonString);

            foreach (i; json["latestVersions"].object.byKeyValue)
            {
                self.latestVersions[i.key] = i.value.str;
            }
        }

        return self;
    }

    public void save(in string fileName)
    {
        auto json = JSONValue(["latestVersions" : JSONValue(latestVersions)]);

        if (exists(fileName))
        {
            remove(fileName);
        }

        write(fileName, json.toPrettyString());
    }

    public string[string] latestVersions;
}