using System.IO;
using Microsoft.SqlServer.Dts.Runtime; 

namespace SaveAndUpdateVersionToXML
{
    class Program
    {
        static void Main(string[] args)
        {
            // packages to upgrade
            System.Collections.ArrayList packages = new System.Collections.ArrayList();

            // SSIS project directory (to load packages from)
            string sourceDirectory = @"C:\Users\Administrator\source\repos\MigrationSample\";

            // target directory (to save migrated packages)
            string targetDirectory = @"C:\Users\Administrator\source\repos\MigrationSample.Migrated\";

            // add the packages; it's an example, so I'm adding manualy
            packages.Add("Package.dtsx");
            packages.Add("ScriptMigrationTesting.dtsx");

            // the events container
            MyEvents e = new MyEvents();

            // we use the appliction object for migration
            Application a = new Application();

            // load and upgrade packages
            foreach (string package in packages)
            {
                // load the package
                Package p = a.LoadPackage(Path.Combine(sourceDirectory, package), e);

                // and save to the target location
                a.SaveAndUpdateVersionToXml(Path.Combine(targetDirectory, package), p, DTSTargetServerVersion.SQLServer2017, e);
            }
        }
    }

    class MyEvents : DefaultEvents
    {

    }
}
