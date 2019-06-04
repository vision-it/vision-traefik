# vision-traefik

[![Build Status](https://travis-ci.org/vision-it/vision-traefik.svg)](https://travis-ci.org/vision-it/vision-traefik)

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
