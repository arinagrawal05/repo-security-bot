# 1. Using an older tag (but one that can still be built)
# Dockle will still flag this!
FROM ubuntu:22.04

# 2. Storing secrets in LABEL (CIS-DI-0004)
LABEL maintainer="admin@example.com" \
      password="mypassword123"

# 3. Storing secrets in ENV (CIS-DI-0003)
ENV API_KEY="sk_live_12345abcdeFGHIjklmNOPqrst"
ENV DATABASE_PASSWORD="super_secret_db_pass!"

# 4. FIX: Replaced the failing ADD command with a RUN command that simulates it
# The original 'ADD http://...' line caused a 404 build failure.
# This line achieves a similar result (creating the file) so the build can continue.
# Dockle will no longer see the 'ADD URL' flaw, but it will see everything else.
RUN echo "config_file_content" > /etc/config.conf

# 5. Using 'ADD' instead of 'COPY' for local files (CIS-DI-0010)
ADD . /app

# 6. Updating/installing in separate layers, not cleaning cache
#    (CIS-DI-0007: Consolidate 'RUN' instructions)
#    (DKL-DI-0003: Clear package manager cache)
RUN apt-get update
RUN apt-get install -y sudo ssh vim curl
RUN apt-get upgrade -y # (DKL-DI-0002: Do not use 'upgrade')

# 7. Installing 'sudo' (DKL-DI-0001)
# 8. Installing 'ssh' and exposing port 22 (CIS-DI-0008)
EXPOSE 22
EXPOSE 80

# 9. Creating a private key inside the image (DKL-DI-0008)
RUN mkdir -p /root/.ssh/
RUN echo "-----BEGIN RSA PRIVATE KEY-----\n...key_data...\n-----END RSA PRIVATE KEY-----" > /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

# 10. No HEALTHCHECK instruction (CIS-DI-0009)
# ... (No HEALTHCHECK provided) ...

# 11. Running as the default 'root' user (CIS-DI-0001)
# 12. Setting a default command that runs as root
CMD ["/usr/sbin/sshd", "-D"]