# Homelab Cybersecurity Stack

A secure repository containing network configurations, security exports, and defensive stack policies for my homelab environment.

## Objective & Security Rationale

At a fundamental level, this hardening configuration prevents automated botnet scanners from probing open ports and exploiting low-hanging fruit. By closing unmanaged vectors and tightening perimeter filters, the router ignores public internet noise and eliminates default entry points.

## Environment Architecture

- **Hardware/Platform:** MikroTik RouterOS
- **Purpose:** Cybersecurity lab segmentation, traffic inspection, and firewall hardening.

## Visual Overview

Here is an overview of the firewall filter rules providing perimeter protection and traffic segmentation:

![MikroTik Firewall Rules](images/mikrotik-firewall.jpg)

## Repository Structure

- `security-lab-export.rsc`: Sanitized MikroTik router configuration export featuring firewall rules, queue trees, interfaces, DHCP, and routing policies.
