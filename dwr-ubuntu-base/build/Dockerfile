FROM docker.io/codercom/enterprise-base:ubuntu

STOPSIGNAL SIGTERM

# Build Args
# uid 1001 is for kubernetes compatibility
ARG USERID=1002
ARG USERNAME=space
# gid 0 for running on openshift
ARG GROUPID=0
# Set username as ENV so it can be used by entrypoint script

ENV USER=${USERNAME}
ENV HOME=/home/${USER}

# Create non-root user and their home dir
# RUN useradd -m -d "${HOME}" --uid ${USERID} --gid ${GROUPID} -s /bin/bash "${USER}"

# RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
#     && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
#     && chmod 0440 /etc/sudoers.d/${USER}

# Install packages
RUN apt update && \
    apt install -y vim tree jq git && \
    apt upgrade -y && \
    apt clean

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin

# Add Starship shell prompt
# RUN curl -sSL https://starship.rs/install.sh | sh -s -- --yes --bin-dir "/usr/local/bin" && \
#     echo 'eval "$(starship init bash)"' >> $HOME/.bashrc && \
#     rm -rf /tmp/*

# A last pass on permissions:
## - Allow gid 0 to write to /etc/passwd (for OpenShift)
## - Allow gid 0 to write to $HOME (for OpenShift)
## - Set execute permissions any scripts/bin we've copied
RUN chmod g=u /etc/passwd && \
    chgrp -R 0 /home && chmod -R g=u /home && \
    chmod -R 775 /usr/local/bin/

# Switch to new user
USER $USER
WORKDIR $HOME

# Execute entrypoint
# This script dynamically adds an entry to /etc/passwd if the user is not recoginized
#   Necessary for running containers on OpenShift with non-root users
ENTRYPOINT [ "entrypoint.sh" ]
# `CMD ["command","--option","arg"]` runs in exec mode and helps the container exit cleanly
CMD ["/bin/bash"]