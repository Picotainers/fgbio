# fgbio
Small source-built container for `fgbio`.

## Quick Usage

```bash
# Pull the image
docker pull docker.io/picotainers/fgbio:latest

# Run the tool
docker run --rm -v "$(pwd):/data" docker.io/picotainers/fgbio:latest --help
```
