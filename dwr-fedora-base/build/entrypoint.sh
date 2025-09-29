#!/bin/sh
# This script dynamically adds an entry to /etc/passwd if the user is not recoginized
#   Necessary for running containers on OpenShift with non-root users

# Use environment variables for username and display name
USER=${USER:-space}  # Default to 'space' if not set

# Check if the current user is recognized by the system
if ! whoami &> /dev/null; then
  # If the /etc/passwd file is writable, add an entry for the current user ID
  if [ -w /etc/passwd ]; then
    echo "${USER}:x:$(id -u):0:${USER}:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

# Execute the given command, passing along any arguments provided
exec "$@"