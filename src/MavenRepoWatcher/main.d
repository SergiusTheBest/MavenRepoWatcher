import std.stdio;
import ConfigData;
import PersistentData : PersistentData;
import NotificationMessageBuilder;
static import MavenRepoClient;
static import EmailSender;

int main(string[] argv)
{
    auto configData = new ConfigData("config.json");
    auto persistanceData = PersistentData.load("mavenRepoWatcher-data.json");
    auto messageBuilder = new NotificationMessageBuilder();

    foreach (string packageUrl; configData.packageUrls)
    {
        writeln("Checking " ~ packageUrl);

        auto latestVersion = cast(immutable char[])MavenRepoClient.getLatestVersion(packageUrl);
        auto knownVersion = persistanceData.latestVersions.get(packageUrl, "");

        if (knownVersion != latestVersion)
        {
            messageBuilder.addNotify(packageUrl, knownVersion, latestVersion);
            persistanceData.latestVersions[packageUrl] = latestVersion;
        }
    }

    writeln("----------------------------------");

    auto message = messageBuilder.build();
    writeln(message);

    if (!messageBuilder.isEmpty())
    {
        EmailSender.sendEmail(configData.senderSmtp, configData.senderEmail, configData.senderPassword, configData.notifyEmail, "I found new maven packages", message);
        persistanceData.save("mavenRepoWatcher-data.json");
    }

    return 0;
}