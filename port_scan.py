import socket
import csv
import ipaddress

def scan_ports(ip_range, port_range):
    """Scan a range of IPs and ports, logging results to a CSV."""
    results = []
    for ip in ipaddress.IPv4Network(ip_range):
        for port in port_range:
            try:
                with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                    s.settimeout(1)  # Set timeout for connection attempts
                    result = s.connect_ex((str(ip), port))
                    if result == 0:
                        results.append((str(ip), port))
            except Exception as e:
                print(f"Error scanning {ip}:{port} - {e}")

    # Log results to CSV
    with open('port_scan_results.csv', 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['IP', 'Port'])
        writer.writerows(results)

# Example usage
scan_ports('192.168.1.0/24', range(20, 1025))
