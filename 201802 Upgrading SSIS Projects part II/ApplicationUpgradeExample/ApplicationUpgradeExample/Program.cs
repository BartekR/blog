// based on https://msdn.microsoft.com/en-us/library/microsoft.sqlserver.dts.runtime.application.upgrade.aspx
// that code is not working at the time of writing (January 2018), but gives us some guidelines

// ATTENTION! Setting assembly version Microsoft.SqlServer.Dts.Runtime (11, 12, 13, 14) in References
// sets up the Application.ComponentStorePath property (source directory for SSIS tasks and components):
// C:\Program Files (x86)\Microsoft SQL Server\<version>0\DTS, i.e. C:\Program Files (x86)\Microsoft SQL Server\140\DTS
// if you switch the assembly always run Rebuild All as Build does not see the change

using System;
using System.Collections.ObjectModel;
using Microsoft.SqlServer.Dts.Runtime;

namespace ApplicationUpgradeExample
{
    class Program
    {
        static void Main(string[] args)
        {
            Application app = new Application();

            // add packages with migration options; first null == don't change package name, second null == package password
            UpgradePackageInfo packinfo1 = new UpgradePackageInfo("Package.dtsx", "Package.dtsx", null);

            Collection<UpgradePackageInfo> packages = new Collection<UpgradePackageInfo>();
            packages.Add(packinfo1);

            // directory with packages for the migration
            StorageInfo storeinfoSource = StorageInfo.NewFileStorage();
            storeinfoSource.RootFolder = "C:\\tmp\\MigrationSample";

            // directory for migrated packages
            StorageInfo storeinfoDest = StorageInfo.NewFileStorage();
            storeinfoDest.RootFolder = "C:\\tmp\\MigrationSample";

            // options for the process
            BatchUpgradeOptions upgradeOpts = new BatchUpgradeOptions
            {
                Validate = true,
                BackupOldPackages = true,
                ContinueOnError = true,
                ValidationFailureAsError = true,

                ProjectPath = "C:\\tmp\\MigrationSample\\MigrationSample.dtproj"
            };

            // package options
            PackageUpgradeOptions pkgUpgradeOpts = new PackageUpgradeOptions
            {
                RegeneratePackageID = true,
                UpgradeConnectionProviders = true
            };

            app.PackageUpgradeOptions = pkgUpgradeOpts;

            // events object
            MyEventsClass eventsClass = new MyEventsClass();

            // Upgrade
            app.Upgrade(packages, storeinfoSource, storeinfoDest, upgradeOpts, eventsClass);

        }
    }

    class MyEventsClass : DefaultEvents
    {
        public override void OnPreExecute(Executable exec, ref bool fireAgain)
        {
            Console.WriteLine("The PreExecute event of the " + exec.ToString() + " has been raised.");
            Console.Read();
        }
    }
}