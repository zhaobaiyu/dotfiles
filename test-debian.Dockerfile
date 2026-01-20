# Test Dockerfile for Debian installation script
FROM debian:bookworm

# Install sudo and create a test user
RUN apt-get update && \
    apt-get install -y sudo && \
    useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to test user
USER testuser
WORKDIR /home/testuser

# Copy the installation script
COPY --chown=testuser:testuser run_onchange_before_install_debian.sh /home/testuser/

# Make it executable
RUN chmod +x /home/testuser/run_onchange_before_install_debian.sh

# Run the installation script
RUN /home/testuser/run_onchange_before_install_debian.sh

# Verify installations
ENV PATH="/home/testuser/.local/bin:${PATH}"
RUN fish --version && \
    zsh --version && \
    fzf --version && \
    bat --version && \
    fd --version && \
    rg --version && \
    eza --version && \
    zoxide --version && \
    starship --version && \
    zellij --version && \
    lazygit --version && \
    uv --version

CMD ["/bin/bash"]
