# VPC Network Infrastructure 🌐

* Assigned a CIDR block of 10.17.0.0/16.

## Subnets

### Availability Zone A


| NAME     | CIDR          | AZ  | CustomIPv6Value |
| ---------- | --------------- | ----- | ----------------- |
| sn-db-A  | 10.17.16.0/20 | AZA | IPv6 01         |
| sn-app-A | 10.17.32.0/20 | AZA | IPv6 02         |
| sn-web-A | 10.17.48.0/20 | AZA | IPv6 03         |

### Availability Zone B


| NAME     | CIDR           | AZ  | CustomIPv6Value |
| ---------- | ---------------- | ----- | ----------------- |
| sn-db-B  | 10.17.80.0/20  | AZB | IPv6 05         |
| sn-app-B | 10.17.96.0/20  | AZB | IPv6 06         |
| sn-web-B | 10.17.112.0/20 | AZB | IPv6 07         |

## Internet Gateway

* An IGW is assigned to the VPC.

## Route Tables

* A route table is attached to the VPC, and associated with the public web
  subnets in each AZ.
* The following default routes were added: