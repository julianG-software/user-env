env-cleanup() {
    nix profile wipe-history && \
    nix-collect-garbage -d && \
    exit
}
