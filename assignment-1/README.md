Linux System Diagnostic Toolkit
A Bash-based toolkit for performing basic Linux system diagnostics. The project provides scripts for collecting system information, checking disk usage, and testing network connectivity.

Project Structure
.
├── system-info.sh
├── disk-check.sh
├── network-check.sh
└── logs/
Scripts system-info.sh

Displays important information about the current system, including:

Hostname Current user System uptime CPU information Memory usage Operating system Kernel version Current working directory

The output is also recorded in the logs/ directory.

disk-check.sh

Checks the disk usage of a specified path and compares it against a user-defined threshold.

The threshold must be between 1 and 100.

network-check.sh

Performs basic network connectivity diagnostics.

The script can:

Resolve a hostname or IP address Perform an ICMP ping test Display network interface information Test TCP port availability

Network results are saved to the logs/ directory.

Requirements

The scripts require a GNU/Linux environment with the following utilities:

Bash df ip ping getent nc Installation

Clone the repository and move into the project directory:

git clone cd

Make the scripts executable:

chmod +x system-info.sh
chmod +x disk-check.sh
chmod +x network-check.sh
##Usage

System Information

Run the following command:

./system-info.sh

This displays information about the current Linux system and saves the results to a log file.

Disk Check

Run:

./disk-check.sh [path]

Example:

./disk-check.sh 80 /

The command checks the disk usage of / against an 80% threshold.

If the path is not provided, / is used as the default path.

Network Check

Run:

./network-check.sh [port]

Example:

./network-check.sh google.com

To test a specific TCP port:

./network-check.sh google.com 443 Exit Codes Exit Code Description 0 Operation completed successfully 1 Operational check failed or threshold was exceeded 2 Invalid arguments or input Exit Code 0

Indicates that the requested operation completed successfully.

For disk checks, this means disk usage is below the specified threshold.

Exit Code 1

Indicates an operational problem.

For example:

Disk usage has reached or exceeded the configured threshold. Hostname resolution failed. Ping failed. A requested TCP port is unavailable. Exit Code 2

Indicates invalid input or command usage.

Examples include:

Missing required arguments Invalid disk threshold TCP port outside the 1-65535 range Invalid filesystem path Logging

The scripts store diagnostic results in the logs/ directory.

Example:

logs/ ├── system-info.log ├── disk-check.log └── network-check.log

Log files are generated automatically when the scripts are executed.

Input Validation

The scripts validate command-line arguments before running diagnostics.

Disk Threshold

The threshold must be a number between: 1-100 TCP Port

The port number must be within:

1-65535

Filesystem Path

The specified path must exist before disk usage is checked.

Assumptions

This project assumes:

The system is running GNU/Linux. Bash is installed and available. The required GNU/Linux utilities are installed. The user has permission to access the specified filesystem paths. The user has permission to create and write log files. Network tests depend on the target host allowing ICMP traffic and/or connections to the requested TCP port.