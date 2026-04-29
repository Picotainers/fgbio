# fgbio

Minimal container for [fgbio](https://github.com/fulcrumgenomics/fgbio), built from upstream release artifacts.

## Quick Usage
```bash
docker run --rm docker.io/picotainers/fgbio:latest --help
```

## Usage
```bash
# Show available subcommands
docker run --rm docker.io/picotainers/fgbio:latest --help

# Example: print version/help banner from the jar entrypoint
docker run --rm docker.io/picotainers/fgbio:latest CollectDuplexSeqMetrics --help
```

## Building
```bash
docker build -t docker.io/picotainers/fgbio:latest .
```
