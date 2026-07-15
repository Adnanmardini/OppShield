# Containerization Audit

## Base Image
- node:22-alpine

## Build Strategy
- Multi-stage build

## Runtime User
- node (non-root)

## Exposed Port
- 3000

## Recommendations
- Add Docker layer caching optimization
- Add .dockerignore if missing
