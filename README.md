# Homelab Cybersecurity Stack # <img src="Images/magnifying-glass.jpg" alt="Icon" width="30" style="vertical-align: middle;"> Homelab Cybersecurity Stack

A secure repository containing network configurations, security exports, and defensive stack policies for my homelab environment.

## Objective & Security Rationale

At a fundamental level, this hardening configuration prevents automated botnet scanners from probing open ports and exploiting low-hanging fruit. By closing unmanaged vectors and tightening perimeter filters, the router ignores public internet noise and eliminates default entry points.

## Environment Architecture

- **Hardware/Platform:** MikroTik RouterOS
- **Purpose:** Cybersecurity lab segmentation, traffic inspection, and firewall hardening.

## Visual Overview

Here is an overview of the firewall filter rules providing perimeter protection and traffic segmentation:

![MikroTik Firewall Rules](Images/mikrotik-firewall.jpg)

## Repository Structure

- `security-lab-export.rsc`: Sanitized MikroTik router configuration export featuring firewall rules, queue trees, interfaces, DHCP, and routing policies.

> **Note: Real-World Threat Landscape**
> 
> Before applying perimeter defenses, exposed network services are immediately targeted by automated botnets and malicious scanners across the public internet. 
> 
> When administrative interfaces and management ports are left exposed without proper firewall filtering, routers experience continuous, automated brute-force attacks. While the log entry above highlights unauthorized login failures via Telnet, similar aggressive scanning and credential-stuffing attempts occur across other exposed ports and services:
> 
> > **Note: Real-World Threat Landscape**
> 
> Before applying perimeter defenses, exposed network services are immediately targeted by automated botnets and malicious scanners across the public internet. 
> 
> When administrative interfaces and management ports are left exposed without proper firewall filtering, routers experience continuous, automated brute-force attacks. While the log entry below highlights unauthorized login failures via Telnet, similar aggressive scanning and credential-stuffing attempts occur across other exposed ports and services:
> 
> <img src="Images/bruteforce.jpg" alt="Botnet Brute-Force Attacks" width="350">
> 
 By enforcing a strict perimeter configuration—blocking unauthorized inbound traffic while explicitly allowing required ICMP, DNS, and dynamic DHCP lease management—the attack surface is eliminated, protecting the router from external compromise.

