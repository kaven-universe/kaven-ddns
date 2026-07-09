using Kaven.Standard;

await Utility.StartConsoleApplication<AppDDnsClient>(new ConsoleApplicationStartOptions()
{
    IoC = new IoC(),
});