# PluginManager



## INSTALL PLUGINS

Loop source directory and install plugins in subdirectories

Only plugins matching these conditions will be installed

1. *.zsc file exists -- THIS ALLOWS AVOID INSTALATION OF PLUGIN

1. Names of .txt .zsc and Data folder must match plugin name

		{PluginName}\
			{PluginName}.txt
			{PluginName}.zsc
			{PluginName}Data\



### How it works
For each plugin are harlinks created
	FROM: plugins source directory
	TO:   "c:\Program Files\Pixologic\ZBrush {version}\ZStartup\ZPlugs64\"

1. Hardlink to source .txt file {PluginName}.txt

1. Hardlink to Data folder {PluginName}Data\


## RELOAD PLUGINS

For each plugin is generated load button in PluginManager:Load Plugins
 Each button simply loads plugin source .txt and press  ZScript:Load