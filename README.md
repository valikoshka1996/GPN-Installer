# Prometheus, Node Exporter and Grafana Installation Script

## Description

Prometheus is installed and configured to collect metrics from the local server as well as from Node Exporter (port 9100).  
Node Exporter is installed to gather system metrics.  
Grafana is installed for visualizing the metrics. The web access to Grafana is available on port 3000.  
At the end of the script, the login and password for Grafana access will be displayed (default: admin/admin).

## How to Run

1. Save this script to a file, e.g. `install_prometheus_grafana.sh`.
2. Run the following command:

    ```bash
    sudo bash install_prometheus_grafana.sh
    ```

3. Wait for the installation to complete, and the login/password for Grafana will be displayed.

4. Now you can access Grafana via your web browser at `http://localhost:3000` using the login and password displayed at the end of the script.
