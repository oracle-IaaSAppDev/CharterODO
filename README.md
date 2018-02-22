# CharterODO
* Overview: 

Several projects have been bundled into a single git repo for delivery to Charter.  Each repo folder will have its own README file explaining that section. Once cloned it is suggested that this repo be broken up into individual repos for independent development cycles.

* Repos:
   * Jenkins:  This repo has the thin back up file for the Jenkins configuration.  The README file will explain how to install and configure Jenkins.
   * Chef:  This repo has three elements, the node.json file and two cookbooks, one cookbook to start the odo gold image and another cookbook to install and configure OMC agents on the engines.  It is recommended that each cookbook become it's own project with corresponding git repo.
   * ODO_Cartridge:  This contains the workspaces in .zip format
   * TFPlan:  This contains the Terraform configuration that will be called by Jenkins to manage campaigns.  It is recommended that this also become it's own git repo
