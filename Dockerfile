# Encryption Wizard – OCI container image
#
# The jlink-generated minimal JRE (jre/) must exist in the build context
# before running docker build; it is created by the CI workflow.
#
# Usage:
#   docker run --rm ghcr.io/amentumcms/encryption-wizard [ARGS]
#   docker run --rm ghcr.io/amentumcms/encryption-wizard -h   # help (default)
#   docker run --rm -v /data:/data ghcr.io/amentumcms/encryption-wizard encrypt -i /data/secret.txt

FROM debian:12-slim

WORKDIR /app

# Copy the jlink-generated minimal JRE produced by the CI workflow
COPY jre/ ./jre/

# Copy the application JAR
COPY files/EW-Unified-4.0.005-FIPS.jar ./

LABEL org.opencontainers.image.title="Encryption Wizard" \
      org.opencontainers.image.description="FIPS-compliant encryption application" \
      org.opencontainers.image.vendor="AmentumCMS" \
      org.opencontainers.image.url="https://github.com/AmentumCMS/em-win"

# Run the application.  Default to -h so the container prints help when
# invoked with no arguments; pass any other arguments to override.
ENTRYPOINT ["./jre/bin/java", "-jar", "EW-Unified-4.0.005-FIPS.jar"]
CMD ["-h"]
