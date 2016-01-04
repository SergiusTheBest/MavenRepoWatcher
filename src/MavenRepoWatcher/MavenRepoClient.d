import std.net.curl;
import std.regex;

public char[] getLatestVersion(in string packageUrl)
{
    auto mavenMetadata = getMavenMetadata(packageUrl);
    auto capture = matchFirst(mavenMetadata, "<latest>(?P<ver>.*?)</latest>");
    return capture["ver"];
}

private char[] getMavenMetadata(in string packageUrl)
{
    return get(packageUrl ~ "/maven-metadata.xml");
}