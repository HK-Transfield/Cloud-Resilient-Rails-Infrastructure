# Ruby On Rails Server

## Overview
![Architecture of the project](/image.png)

### Explanation
This project is a webserver and database spun up with cloud resiliency (i.e. Load balancers, Autoscaling) using Terraform. Must have general security best practices, like a private subnet etc. Helps with getting more familiar with deployments.

When deployed correctly, it will display a webpage on a cloud-based infrastructure, this uses Ruby on Rails as the webserver and it would have a domain that would show it would alternate between the Availability zones.

If working correctly, the load balancer will alternate between the 2 ALZ's.

---

## Network Architecture
| NAME | CIDR | AZ | CustomIPv6Value |
|------|------|----|-----------------|
|sn-reserved-A | 10.17.0.0/20 | AZA | IPv6 00 |
|sn-db-A | 10.17.16.0/20 | AZA | IPv6 01 |
|sn-app-A | 10.17.32.0/20 | AZA | IPv6 02 |
|sn-web-A | 10.17.48.0/20 | AZA | IPv6 03 |

| NAME | CIDR | AZ | CustomIPv6Value |
|------|------|----|-----------------|
| sn-reserved-B | 10.17.64.0/20 | AZB | IPv6 04 |
| sn-db-B | 10.17.80.0/20 | AZB | IPv6 05 |
| sn-app-B | 10.17.96.0/20 | AZB | IPv6 06 |
| sn-web-B | 10.17.112.0/20 | AZB | IPv6 07 |
