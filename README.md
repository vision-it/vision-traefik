
# Initialization

- Get current config from modulesync_config
- Change the default branch to production when finished
- Generate new Travis secure notification using the Travis
- Remove this paragraph and change Travis branch to production

# vision-traefik

[![Build Status](https://travis-ci.org/vision-it/vision-traefik.svg?branch=development)](https://travis-ci.org/vision-it/vision-traefik)

## Usage

Include in the *Puppetfile*:

```
mod 'vision_traefik',
    :git => 'https://github.com/vision-it/vision-traefik.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
contain ::vision_traefik
```
