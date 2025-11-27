# ❌ BAD: Using 'latest' tag (Unpredictable builds)
# [DKL-DI-0001] Avoid latest tag
FROM ubuntu:latest

# ❌ BAD: No MAINTAINER or Labels (CIS Recommendation)
# [CIS-DI-0005] Enable Content Trust (checked via labels sometimes)

# ❌ BAD: Installing sudo is a huge red flag
# [DKL-DI-0006] Avoid sudo command
RUN apt-get update && \
    apt-get install -y sudo vim curl python3

# ❌ BAD: Leaving the apt cache (Bloats image, hides attack surface)
# [DKL-DI-0005] Clear apt-get caches
# (Notice I deleted the 'rm -rf /var/lib/apt/lists/*' line)

# ❌ BAD: Using ADD instead of COPY (ADD can fetch remote URLs/zip bombs)
# [DKL-DI-0004] Use COPY instead of ADD
ADD . /app

WORKDIR /app

# ❌ BAD: Hardcoded "Secret" (Dockle looks for common secret filenames)
# [DKL-DI-0002] Avoid sensitive directory or file
ENV AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
ENV AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

# ❌ BAD: Running as Root (The User instruction is missing!)
# [CIS-DI-0001] Create a user for the container
# [DKL-DI-0001] Avoid running as root

# ❌ BAD: Missing Healthcheck
# [CIS-DI-0006] Add HEALTHCHECK instruction to the container image

# ❌ BAD: Privileged Port 80 (Requires root)
EXPOSE 8080

CMD ["python3", "-m", "http.server", "8080"]
