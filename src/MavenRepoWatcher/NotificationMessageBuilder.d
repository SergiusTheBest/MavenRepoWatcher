class NotificationMessageBuilder
{
    public NotificationMessageBuilder addNotify(in string packageUrl, in string knownVersion, in string newVersion)
    {
        text ~= "* " ~ packageUrl ~ ": " ~ knownVersion ~ " => " ~ newVersion ~ "\n";
        return this;
    }

    public bool isEmpty() const
    {
        return text.length == 0;
    }

    public string build()
    {
        return isEmpty() ? "No packages have been updated." : "The following packages have been updated:\n\n" ~ text;
    }

    private string text;
}