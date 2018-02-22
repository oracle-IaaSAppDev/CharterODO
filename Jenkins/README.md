***Building The Jenkins Server***

**Jenkins Configuration Guide**

* Install any current version of Jenkins. 
* create a directory /home/Jenkins
* create a directory /home/Jenkins/backups
* Once Jenkins is installed and working
  *   navigate to "Manage Jenkins Plug-ins" 
  *   Click the Available tab, search for "thin"  
       * Select the "thin backup" plug-in and install it
  * Copy the contents of this folder to /home/Jenkins/backups
  
  **Terraform Installation & Configuration Guide**
  
  * Install Terraform version 0.9.*
  * Get version 1.0.18 of the OCI Plug-in for TF
     * https://github.com/oracle/terraform-provider-oci/tree/v1.0.18
     * Install the Provider in the Jenkins user home /var/lib/jenkins
      

