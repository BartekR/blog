// https://msdn.microsoft.com/en-us/library/microsoft.sqlserver.dts.runtime.application.upgrade.aspx
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using Microsoft.SqlServer.Dts.Runtime;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {


            Application app = new Application();

            UpgradePackageInfo packinfo1 = new UpgradePackageInfo("C:\\temp\\Package.dtsx", "C:\\temp\\Package.dtsx", null);
            UpgradePackageInfo packinfo2 = new UpgradePackageInfo("C:\\temp\\Package2.dtsx", "C:\\temp\\Package2.dtsx", null);

            Collection<UpgradePackageInfo> packages = new Collection<UpgradePackageInfo>();
            packages.Add(packinfo1);
            packages.Add(packinfo2);


            StorageInfo storeinfoSource = StorageInfo.NewFileStorage();
            storeinfoSource.RootFolder = "C:\\temp";

            StorageInfo storeinfoDest = StorageInfo.NewFileStorage();
            BatchUpgradeOptions upgradeOpts = new BatchUpgradeOptions();
            upgradeOpts.Validate = true;
            upgradeOpts.BackupOldPackages = true;
            upgradeOpts.ContinueOnError = true;
            upgradeOpts.ValidationFailureAsError = true;        

            MyEventsClass eventsClass = new MyEventsClass();


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