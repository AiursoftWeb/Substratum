# Substratum

Substratum is a container-based hosting service and cluster management service.

## Basic Data structure

* DataCenters (1-1 mapping with SubPulse)
  * Clusters (1-1 mapping with SubCenter)
    * Hosts (1-1 mapping with SubHost)
      * Containers
    * Stacks
      * Services
        * Containers

* Day 1 Open-source
* Based on .NET 8
* Support both Single-machine and Cluster management
* Linux based
* Container based

## Substratum is SubHost + SubCenter + SubPulse

Substratum is a combination of SubHost, SubCenter, and SubPulse.

Substratum website will provide the installer for SubHost, SubCenter and SubPulse. Both files are `.tar.gz` files with `install.sh` script.

* SubHost-installer-1.0.0.tar.gz
* SubCenter-installer-1.0.0.tar.gz
* SubPulse-installer-1.0.0.tar.gz

Both SubHost and SubCenter supports Air-gapped installation.

* SubHost is a container-based hosting service and it contains the following services:
  * Docker (For running containers)
  * Workflow Engine (For running host workflows)
  * Web Portal (For managing containers and deploy single container services)
  * Performance Monitor (For monitoring performance) (Based on stathub) (By default server enabled until joined to SubCenter)
  * Log Monitor (For monitoring logs) (By default enabled until joined to SubCenter)
  * Registry (For storing images) (By default enabled until joined to SubCenter)
  * Nuget (For storing workflow packages) (By default enabled until joined to SubCenter)
  * InfluxDB (For storing performance data and workflow logs)
* SubCenter is a cluster management service

Substratum is a combination of both services.

## SubHost

SubHost will be installed on each machine in the cluster.

SubHost will lock down the machine (Disable SSH) and only allow API and Web Portal access.

SubHost authentication is based on Linux users. By default, after installing, user can use the root user to login to the Web Portal.

### Installation

* User must agree to the EULA during installation.
* SubHost will require the user to set root password during installation.
* SubHost will delete all data and users on the machine during installation.
* SubHost will require a data folder to be set during installation. (At least 50GB)
* SubHost will require a backup folder to be set during installation. (At least 50GB)
* SubHost will require a hostname to be set during installation. The hostname should be unique in the cluster.

## SubCenter

It is not supported to install SubCenter on a machine with SubHost.

SubCenter's authentication supports both Linux users and SubPulse users. It is suggested to use SubPulse users for authentication for easier cluster management.

SubHost can join SubCenter to form a cluster. It requires IP address and root password to join.

Usually, a SubCenter instance can host a cluster with around 2-200 hosts. For more than 200 hosts, it is suggested to create another SubCenter instance and manage it with SubPulse.

* SubCenter is a cluster management service
  * Cluster Workflow Engine (For running cluster workflows)
  * Cluster Monitor (For monitoring clusters) (based on stathub-server)
  * Cluster Registry (For storing cluster images)
  * Cluster Nuget (For storing cluster packages)
  * Cluster apt mirror (For storing cluster packages)
  * InfluxDB (For storing performance data and cluster logs)
  * Inventory Database (For storing cluster inventory data)
  * PXE Server (For auto OS installation)
  * Cluster Web Portal (For managing clusters)

SubCenter provides features like:

* Web Portal (Cluster)
* Inventory Management
* Stack Container Deployment (For deploying stack containers)
* Containers Live Migration
* DRS (Distributed Resource Scheduler)
* DPM (Dynamic Power Management)
* HA (High Availability)
* Storage DRS and Storage HA
* Begin/End Maintenance Mode
* Cluster Resource Pooling
* Software Defined Networking
* Software Defined Storage
  * SAN mode (User can set how many copies of data to store)
  * Shared mode
* Host Compliance
* PXE based auto OS installation

## SubPulse

Without SubPulse, SubCenter already has the ability to manage the cluster. However, it is not easy to monitor all clusters in a single dashboard.

When managing a large dataCenter, it is best practice to progressively upgrade SubCenter and SubHost instances.

When managing a large dataCenter, it is also necessary to auto monitor all clusters and provide incident management.

When there are a lot of clusters, SubPulse will be useful to monitor all clusters in a single dashboard.

SubCenter can join SubPulse to form a datacenter. It requires IP address and root password to join.

* SubPulse is a dashboard for monitoring clusters
  * Authentication Service (For authenticating users)
  * Deployment Service (For deploying SubHost and SubCenter)
  * Datacenter Inventory Database (For storing datacenter inventory data)
  * Cluster Heatmap (For monitoring clusters)
  * Incident Management (For managing incidents)
  * Alerting Service (For sending alert and manage on-call)
