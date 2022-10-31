using Constructs;
using HashiCorp.Cdktf;
using HashiCorp.Cdktf.Providers.Azurerm.MssqlVirtualMachine;
using HashiCorp.Cdktf.Providers.Azurerm.NetworkInterface;
using HashiCorp.Cdktf.Providers.Azurerm.NetworkSecurityGroup;
using HashiCorp.Cdktf.Providers.Azurerm.NetworkSecurityRule;
using HashiCorp.Cdktf.Providers.Azurerm.NetworkInterfaceSecurityGroupAssociation;
using HashiCorp.Cdktf.Providers.Azurerm.Provider;
using HashiCorp.Cdktf.Providers.Azurerm.PublicIp;
using HashiCorp.Cdktf.Providers.Azurerm.ResourceGroup;
using HashiCorp.Cdktf.Providers.Azurerm.Subnet;
using HashiCorp.Cdktf.Providers.Azurerm.VirtualMachine;
using HashiCorp.Cdktf.Providers.Azurerm.VirtualNetwork;
using System.Collections.Generic;

namespace MyCompany.MyApp
{
    class MainStack : TerraformStack
    {
        public MainStack(Construct scope, string id) : base(scope, id)
        {
            // define resources here
            new AzurermProvider(this, "azurerm", new AzurermProviderConfig {
                Features = new AzurermProviderFeatures()
            });

            ResourceGroup rg = new ResourceGroup(this, "rg", new ResourceGroupConfig {
                Location = "West Europe",
                Name = "VM-SSIS-RG"
            });

            VirtualNetwork n = new VirtualNetwork(this, "vnet", new VirtualNetworkConfig {
                Location = rg.Location,
                ResourceGroupName = rg.Name,
                AddressSpace = new []{"10.2.0.0/16"},
                Name = "vm-ssis-vnet"
            });

            Subnet s = new Subnet(this, "subnet", new SubnetConfig {
                ResourceGroupName = rg.Name,
                VirtualNetworkName = n.Name,
                AddressPrefixes = new[]{"10.2.0.0/24"},
                Name = "default"
            });

            PublicIp ip = new PublicIp(this, "vm-ssis-pip", new PublicIpConfig {
                Location = rg.Location,
                Name = "vm-ssis-public-ip",
                ResourceGroupName = rg.Name,
                Sku = "Standard",
                SkuTier = "Regional",
                AllocationMethod = "Static"
            });

            NetworkInterface nic = new NetworkInterface(this, "nic", new NetworkInterfaceConfig {
                Location = rg.Location,
                ResourceGroupName = rg.Name,
                Name = "vm-ssis-nic",
                IpConfiguration = new [] {
                    new NetworkInterfaceIpConfiguration {
                        Name = "vm-ssis-ip",
                        SubnetId = s.Id,
                        PrivateIpAddressAllocation = "Dynamic",
                        PublicIpAddressId = ip.Id
                    }
                }
            });

            NetworkSecurityGroup nsg = new NetworkSecurityGroup(this, "vm-ssis-nsg", new NetworkSecurityGroupConfig {
                Location = rg.Location,
                ResourceGroupName = rg.Name,
                Name = "vm-ssis-nsg"
            });

            NetworkSecurityRule rdp = new NetworkSecurityRule(this, "vm-ssis-rdp", new NetworkSecurityRuleConfig {
                ResourceGroupName = rg.Name,
                Name = "vm-ssis-rdp",
                NetworkSecurityGroupName = nsg.Name,
                Direction = "Inbound",
                Access = "Allow",
                Protocol = "Tcp",
                Priority = 300,
                SourcePortRange = "*",
                SourceAddressPrefix = "*",
                DestinationPortRange = "3389",
                DestinationAddressPrefix = "*"
            });

            NetworkInterfaceSecurityGroupAssociation nsga = new NetworkInterfaceSecurityGroupAssociation(this, "vm-ssis-nsga", new NetworkInterfaceSecurityGroupAssociationConfig {
                NetworkInterfaceId = nic.Id,
                NetworkSecurityGroupId = nsg.Id
            });

            VirtualMachine vm = new VirtualMachine(this, "vm", new VirtualMachineConfig {
                Location = "West Europe",
                ResourceGroupName = rg.Name,
                Name = "vm-ssis",
                NetworkInterfaceIds = new[]{nic.Id},
                VmSize = "Standard_D2s_v3",

                StorageImageReference = new VirtualMachineStorageImageReference {
                    Publisher = "microsoftsqlserver",
                    Offer     = "sql2019-ws2019",
                    Sku       = "sqldev",
                    Version   = "latest"
                },

                StorageOsDisk = new VirtualMachineStorageOsDisk {
                    Name = "vm-ssis-osdisk-0",
                    OsType = "Windows",
                    Caching = "ReadWrite",
                    CreateOption = "FromImage",
                    ManagedDiskType = "Premium_LRS",
                    DiskSizeGb = 127
                },

                StorageDataDisk = new[] {
                    new VirtualMachineStorageDataDisk {
                        Lun = 0,
                        Name = "vm-ssis-DataDisk-0",
                        CreateOption = "Empty",
                        Caching = "ReadOnly",
                        ManagedDiskType = "Premium_LRS",
                        DiskSizeGb = 1024
                    },
                    new VirtualMachineStorageDataDisk {
                        Lun = 1,
                        Name = "vm-ssis-DataDisk-1",
                        CreateOption = "Empty",
                        Caching = "None",
                        ManagedDiskType = "Premium_LRS",
                        DiskSizeGb = 1024
                    }
                },

                OsProfile = new VirtualMachineOsProfile {
                    AdminUsername = "bartekr",
                    AdminPassword = "Password!@#$1234",
                    ComputerName = "vm-ssis"
                },

                OsProfileWindowsConfig = new VirtualMachineOsProfileWindowsConfig {
                    ProvisionVmAgent = true,    // Attention: can't be updated after creation
                    EnableAutomaticUpgrades = true                        
                },

                DeleteDataDisksOnTermination = true,
                DeleteOsDiskOnTermination = true
            });

            new MssqlVirtualMachine(this, "vm-ssis", new MssqlVirtualMachineConfig {
                VirtualMachineId = vm.Id,
                SqlLicenseType = "PAYG",
                SqlConnectivityPort = 1433,
                StorageConfiguration = new MssqlVirtualMachineStorageConfiguration {
                    DiskType = "NEW",
                    StorageWorkloadType = "GENERAL",

                    DataSettings = new MssqlVirtualMachineStorageConfigurationDataSettings {
                        Luns = new double[] {0},
                        DefaultFilePath = "F:\\data"
                    },

                    LogSettings = new MssqlVirtualMachineStorageConfigurationLogSettings {
                        Luns = new double[] {1},
                        DefaultFilePath = "G:\\log"
                    },

                    // TempDbSettings = new MssqlVirtualMachineStorageConfigurationTempDbSettings {
                    //     DefaultFilePath = "D:\\tempDb"
                    // }
                }
            });
        }
    }
}